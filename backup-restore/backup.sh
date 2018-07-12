#!/bin/bash
url="http://ider-catalogo.ideca.gov.co:8080"
storage_ckan_locaton="/var/lib/ckan/default"
backup_root="/home/adminideca/backup"
repo_name="backup-catalogo"
log_location="/home/adminideca/backup"
log_filename="log_backup.txt"
users_file="users.jsonl"
groups_file="groups.json"
organizations_file="organizations.json"
tags_file="tags.json"
datasets_resources_file="datasets_resources.json"
views_file="views.json"
zip_file="ckan_storage.zip"
server_url="52.186.24.187"
server_user="adminideca"
api_key="30f1e072-bbc5-4557-9abd-a051ab1cae84"

repo_location=$backup_root/$repo_name
#zip_location=$backup_root/zip
log_file=$repo_location/$log_filename
users_file=$repo_location/$users_file
groups_file=$repo_location/$groups_file
organizations_file=$repo_location/$organizations_file
tags_file=$repo_location/$tags_file
datasets_resources_file=$repo_location/$datasets_resources_file
views_file=$repo_location/$views_file
zip_file=$repo_location/$zip_file

current_location=$(pwd)
#echo $current_location

# Configure diretories
if [ ! -d $backup_root ]; then
  mkdir -p $backup_root
  chmod -R 777 $backup_root
fi 

if [ ! -d $repo_location ]; then
  cd $backup_root
  git clone git@bitbucket.org:soporte-ider/backup-catalogo.git
  chmod -R 777 $repo_location
  #chown -R www-data:www-data $repo_location
  #git init
  #git remote add origin git@bitbucket.org:soporte-ider/backup-catalogo.git
  #git push -u origin master
  cd $current_location
fi 

# if [ ! -d $zip_location ]; then
#   mkdir -p $zip_location
#   chmod -R 777 $zip_location
# fi

#Get into the virtual environment
. /usr/lib/ckan/default/bin/activate

# Backing up Users
echo -n `date +'%Y-%m-%d %H:%M:%S'`" Backing up users..." | tee -a $log_file
ckanapi dump users --all -O $users_file -p 4 -r $url -a $api_key
echo "OK!" | tee -a $log_file

# Backing up Groups
echo -n `date +'%Y-%m-%d %H:%M:%S'`" Backing up groups..." | tee -a $log_file
curl -s -d '{"all_fields":"true","include_dataset_count":"true","include_extras":"true","include_tags":"true","include_groups":"true","include_users":"true","limit":"10000"}' -H "Content-Type: application/json" -X POST $url/api/3/action/group_list | jq '.[]' | jq '.[]?' | jq -s '.' > $groups_file
echo "OK!" | tee -a $log_file

# Backing up Organizations
echo -n `date +'%Y-%m-%d %H:%M:%S'`" Backing up organizations..." | tee -a $log_file
curl -s -d '{"all_fields":"true","include_dataset_count":"true","include_extras":"true","include_tags":"true","include_groups":"true","include_users":"true","limit":"10000"}' -H "Content-Type: application/json" -X POST $url/api/3/action/organization_list | jq '.[]' | jq '.[]?' | jq -s '.' > $organizations_file
echo "OK!" | tee -a $log_file

# Backing up Tags
echo -n `date +'%Y-%m-%d %H:%M:%S'`" Backing up tags..." | tee -a $log_file
curl -s -d '{"all_fields":"true","limit":"10000"}' -H "Content-Type: application/json" -X POST $url/api/3/action/tag_list | jq '.[]' | jq '.[]?' | jq -s '.' > $tags_file
echo "OK!" | tee -a $log_file

# Backing up Datasets and Resources
echo -n `date +'%Y-%m-%d %H:%M:%S'`" Backing up datasets/resources..." | tee -a $log_file
#cmd_1="curl -s -d '{"all_fields":"true"}' -H \"Content-Type: application/json\" -X POST $url/api/3/action/current_package_list_with_resources | jq '.[]' | jq '.[]?' | jq -s '.' > $datasets_resources_file"
#echo $cmd_1
curl -s -d '{"all_fields":"true", "limit": "10000"}' -H "Content-Type: application/json" -X POST $url/api/3/action/current_package_list_with_resources | jq '.[]' | jq '.[]?' | jq -s '.' > $datasets_resources_file

echo "OK!" | tee -a $log_file

# Backing up Views
# Get resources ids
echo -n `date +'%Y-%m-%d %H:%M:%S'`" Backing up views..." | tee -a $log_file
#cmd_list_res="cat datasets_resources.json | jq '.[]' | jq '.resources[]' | jq '.id'"
res_array=($(cat $datasets_resources_file | jq '.[]' | jq '.resources[]' | jq '.id'))

#echo $res_array
# Iterate through resources ids to get their views
for i in "${res_array[@]}"
do
  #echo $i
  get_res_cmd="curl -s -d '{\"id\":$i}' -H \"Content-Type: application/json\" -X POST $url/api/3/action/resource_view_list | jq '.result[]' | jq -s '.'"
  output=`eval $get_res_cmd`
  num_views=`echo $output | jq length`
  #  echo $num_views
  
  #num_views=`eval $num_views_cmd`
  #echo $num_views

  #Iterate over resources that have views
  if (( $num_views > 0 )); then
    # if the resource has one view then get rid off the enclosing "[]" and insert it
    if (( $num_views == 1)); then
      view=`echo $output | jq '.[]'`
      final_result+=$view","
    # If the resurce has more than one view, iterate over each of them and add to the final result
    else
      #echo $output
      views=`echo $output | jq '.'`
      num_sub_views=`echo $views | jq length`
      for (( i=0; i<$num_sub_views; i++ ))
      do
        view_cmd="echo '$views' | jq '.[$i]'"
        #echo $view_cmd
        view=`eval $view_cmd`
        final_result+=$view","
      done
    fi
  fi 
done
#Remove last comma (,)
final_result="${final_result%\,}"
#Add "[" at the begining and a "]" to the end of the objects. This is intended to get a well formed json file.
final_result="["$final_result"]"
# pretty print
echo $final_result | jq '.'> $views_file
echo "OK!" | tee -a $log_file

# Backing up storage
echo -n `date +'%Y-%m-%d %H:%M:%S'`" Backing up storage..." | tee -a $log_file
if [ -f $zip_file  ]; then
  rm $zip_file
fi 
cd $storage_ckan_locaton
zip -r $zip_file *
cd $current_location
echo "OK!" | tee -a $log_file 
 
# Copy files to server
echo -n `date +'%Y-%m-%d %H:%M:%S'`" Copy files to server..." | tee -a $log_file
rsync -avzh --exclude '.git' $backup_root $server_user@$server_url:. 
echo "OK!" | tee -a $log_file

# Uploading files to repository
echo -n `date +'%Y-%m-%d %H:%M:%S'`" Uploading to repository..." | tee -a $log_file
cd $repo_location
git add --all
msg=$(date +'%Y-%m-%d %H:%M:%S')
msg="Backup "$msg
echo $msg
git commit -m "'$msg'"
git push
cd $current_location
echo "OK!" | tee -a $log_file

