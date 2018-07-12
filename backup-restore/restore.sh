#!/bin/bash
url="http://ider-catalogo.ideca.gov.co:8080"
log_location="./"
log_filename="log_restore.txt"
log_path=$log_location$log_filename
api_key="30f1e072-bbc5-4557-9abd-a051ab1cae84"

#Get into the virtual environment
. /usr/lib/ckan/default/bin/activate

# Restoring Users
echo -n `date +'%Y-%m-%d %H:%M:%S'`" Restoring users..." | tee -a $log_path
ckanapi load users -I users.jsonl -p 4 -c /etc/ckan/default/production.ini
echo "OK!" | tee -a $log_path

## Backing up Groups
#echo -n `date +'%Y-%m-%d %H:%M:%S'`" Backing up groups..." | tee -a $log_path
#curl -s -d '{"all_fields":"true","include_dataset_count":"true","include_extras":"true","include_tags":"true","include_groups":"true","include_users":"true"}' -H "Content-Type: application/json" -X POST $url/api/3/action/group_list | jq '.[]' | jq '.[]?' | jq -s '.' > groups.json
#echo "OK!" | tee -a $log_path
#
## Backing up Organizations
#echo -n `date +'%Y-%m-%d %H:%M:%S'`" Backing up organizations..." | tee -a $log_path
#curl -s -d '{"all_fields":"true","include_dataset_count":"true","include_extras":"true","include_tags":"true","include_groups":"true","include_users":"true"}' -H "Content-Type: application/json" -X POST $url/api/3/action/organization_list | jq '.[]' | jq '.[]?' | jq -s '.' > organizations.json
#echo "OK!" | tee -a $log_path
#
## Backing up Tags
#echo -n `date +'%Y-%m-%d %H:%M:%S'`" Backing up tags..." | tee -a $log_path
#curl -s -d '{"all_fields":"true"}' -H "Content-Type: application/json" -X POST $url/api/3/action/tag_list | jq '.[]' | jq '.[]?' | jq -s '.' > tags.json
#echo "OK!" | tee -a $log_path
#
## Backing up Datasets and Resources
#echo -n `date +'%Y-%m-%d %H:%M:%S'`" Backing up datasets/resources.." | tee -a $log_path
#curl -s -d '{"all_fields":"true"}' -H "Content-Type: application/json" -X POST $url/api/3/action/current_package_list_with_resources | jq '.[]' | jq '.[]?' | jq -s '.' > datasets_resources.json
#echo "OK!" | tee -a $log_path
#
## Backing up Views
## Get resources ids
#echo -n `date +'%Y-%m-%d %H:%M:%S'`" Backing up views..." | tee -a $log_path
##cmd_list_res="cat datasets_resources.json | jq '.[]' | jq '.resources[]' | jq '.id'"
#res_array=($(cat datasets_resources.json | jq '.[]' | jq '.resources[]' | jq '.id'))
#
## Iterate through resources ids to get their views
#for i in "${res_array[@]}"
#do
#  #echo $i
#  get_res_cmd="curl -s -d '{\"id\":$i}' -H \"Content-Type: application/json\" -X POST $url/api/3/action/resource_view_list | jq '.result[]' | jq -s '.'"
#  output=`eval $get_res_cmd`
#  num_views=`echo $output | jq length`
#  #  echo $num_views
#  
#  #num_views=`eval $num_views_cmd`
#  #echo $num_views
#
#  #Iterate over resources that have views
#  if (( $num_views > 0 )); then
#    # if the resource has one view then get rid off the enclosing "[]" and insert it
#    if (( $num_views == 1)); then
#      view=`echo $output | jq '.[]'`
#      final_result+=$view","
#    # If the resurce has more than one view, iterate over each of them and add to the final result
#    else
#      #echo $output
#      views=`echo $output | jq '.'`
#      num_sub_views=`echo $views | jq length`
#      for (( i=0; i<$num_sub_views; i++ ))
#      do
#        view_cmd="echo '$views' | jq '.[$i]'"
#        #echo $view_cmd
#        view=`eval $view_cmd`
#        final_result+=$view","
#      done
#    fi
#  fi 
#done
##Remove last comma (,)
#final_result="${final_result%\,}"
##Add "[" at the begining and a "]" to the end of the objects. This is intended to get a well formed json file.
#final_result="["$final_result"]"
## pretty print
#echo $final_result | jq '.'> views.json
#echo "OK!" | tee -a $log_path
#
