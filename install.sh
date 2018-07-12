#!/bin/bash
# Script for installing Ckan automatically
# Author: Luis Ballesteros
# email: luballe@luballe.com

#Am I running as root?
echo "ver 1.16"
echo "*** Checking if am I root..."
if [ "$EUID" -ne 0 ]
  then echo "Por favor ejecutar como root!"
  exit
fi
echo "*** I'm root!"

echo "*** Setting up datetime.."
cp /usr/share/zoneinfo/America/Bogota /etc/localtime
echo "Datetime set up!"

echo "*** Setting up installation directory..."
cur_dir=$(pwd)
echo "*** Current directory: "$cur_dir

#Get config file
echo "*** Checking for config.ini file..."
if [ ! -f $cur_dir/config.ini ]; then
  echo "*** No config file, downloading..."
  wget https://raw.githubusercontent.com/luballe/ckan_installer/master/config.ini
else
  echo "*** Config file found!"
fi

#Declare and initialize array of config parameters
echo "*** Getting parameters from config.ini file..."
declare -A parameters
parameters=( )

#Populate array of parameters from config file
IFS="="
while read -r name value
do
  #Checks if the key is not empty
  if [ -n "$name" ]; then
    parameters[$name]=${value}
  fi
done < config.ini
echo "*** Parameters loaded!"

echo "*** Populating variables from parameters..."
#pupulate variables from parameteres
site_title=${parameters[site_title]}
site_url=${parameters[site_url]}
ckan_port=${parameters[ckan_port]}
install_path=${parameters[install_path]}
storage_path=${parameters[storage_path]}
logo=${parameters[logo]}
ckan_default_password=${parameters[ckan_default_password]}
datastore_default_password=${parameters[datastore_default_password]}
admin_name=${parameters[admin_name]}
admin_fullname=${parameters[admin_fullname]}
admin_password=${parameters[admin_password]}
admin_email=${parameters[admin_email]}
email_to=${parameters[email_to]}
error_email_from=${parameters[error_email_from]}
smtp_server=${parameters[smtp_server]}
smtp_starttls=${parameters[smtp_starttls]}
smtp_user=${parameters[smtp_user]}
smtp_password=${parameters[smtp_password]}
smtp_mail_from=${parameters[smtp_mail_from]}
contact_mail_to=${parameters[contact_mail_to]}
contact_recipient_name=${parameters[contact_recipient_name]}
contact_subject=${parameters[contact_subject]}
echo "*** Variables populated!"

# Setting up site_url
echo "*** Setting up site_url variable..."
echo "*** Site URL: "$site_url
if [ $site_url == "IP" ]; then
  echo "*** IT IS IP!"
  site_url=$(curl ipinfo.io/ip)
else
  echo "*** IT IS NOT IP"
fi
echo "*** site_url variable set up!"

# Setting up installation directory
echo "*** Setting up installation directory..."
if [ $install_path == "CUR_DIR" ]; then
  echo "*** IT IS CUR_DIR!"
else
  new_cur_dir=$install_path"/ckan_files"
  rm $new_cur_dir -rf
  mkdir -p $new_cur_dir
  cp $cur_dir/config.ini $new_cur_dir
  cur_dir=$new_cur_dir
  cd $cur_dir
  echo "*** New current directory: " $cur_dir
fi
echo "*** Installation directory set up!"

#Restore storage path
echo "*** Setting up storage path directory..."
rm $storage_path -rf
mkdir -p $storage_path
chmod -R 777 $storage_path
echo "*** Storage directory set up!"

#Update operating system
echo "*** Updating (apt-get -y update)..."
apt -y update
echo "*** Upgrading (apt-get -y upgrade)..." 
apt -y upgrade
echo "*** Installing git..."
apt install -y git git-core
echo "*** git installed!"

#download git files
echo "*** Downloading config files from git..."
#rm $cur_dir/* -rf
git clone https://github.com/luballe/ckan_installer.git
echo "*** Config files downloaded!"

#Configuring statoverride
echo "*** Configuring statoverride..."
cp $cur_dir/ckan_installer/sys_config_files/apache/statoverride /var/lib/dpkg/statoverride
echo "*** Statoverride Configured!"

#uninstall ckan
echo "*** Uninstalling CKAN..."
dpkg -r python-ckan
rm /usr/lib/ckan/ -rf
rm /var/lib/ckan/ -rf
rm /etc/ckan -rf
echo "*** CKAN Uninstalled!"

#Uninstall solr-jetty
echo "*** Uninstalling Solr-Jetty..."
apt purge -y --auto-remove solr-jetty
#apt purge -y solr-jetty
rm /etc/solr/conf -rf
rm /etc/default/jetty -rf
echo "*** Solr-Jetty Uninstalled!"

#Uninstall postgresql
echo "*** Uninstalling Postgres..."
sudo service postgresql stop
apt --purge -y remove postgresql*
rm /var/lib/postgresql -rf
rm /var/lib/sudo/postgres/ -rf
echo "*** Postgres Uninstalled!"

#Uninstall postfix
echo "*** Uninstalling Postfix..."
apt --purge -y remove postfix
echo "*** Postfix Uninstalled!"

#Uninstall redis
echo "*** Uninstalling Redis..."
apt --purge -y remove redis*
rm /var/log/redis -rf
echo "*** Redis Uninstalled!"

#Uninstall supervisor
echo "*** Uninstalling Supervisor..."
apt --purge -y remove supervisor
rm /etc/supervisor/conf.d -rf
rm /var/log/supervisor -rf
echo "*** Supervisor Uninstalled!"

#Install packages needed
echo "*** Installing packages (apt-get install -y ...... )..."
apt install -y build-essential libxslt1-dev libxml2-dev libffi-dev libgeos* tmux htop zip unzip jq
echo "*** Packages installed!"

#Install lipq
echo "*** Installing lipq..."
apt install -y libpq5
echo "*** libpq installed!"

#Install redis
echo "*** Installing redis..."
apt install -y redis-server
echo "*** redis installed!"

#Configuring apache
echo "*** Configuring apache..."
apt install -y apache2 libapache2-mod-wsgi
service apache2 stop
cp $cur_dir/ckan_installer/sys_config_files/apache/ports.conf /etc/apache2/
cp $cur_dir/ckan_installer/sys_config_files/apache/000-default.conf /etc/apache2/sites-available/
cp $cur_dir/ckan_installer/sys_config_files/apache/apache2.conf /etc/apache2/
service apache2 start
echo "*** Apache Configured!"

#Configuring nginx
echo "Configuring nginx..."
apt install -y nginx nginx-common
#cp $cur_dir/ckan_installer/sys_config_files/nginx/nginx.conf /etc/nginx/
echo "nginx Configured!"

#Install ckan package
echo "*** Checking if Ckan installer is already here..."
if [ ! -f $cur_dir/ckan_installer/installer/python-ckan_2.8-xenial_amd64.deb ]; then
  echo "*** Downloading ckan installer..."
  wget http://packaging.ckan.org/python-ckan_2.8-xenial_amd64.deb -P $cur_dir/ckan_installer/installer
  echo "*** Ckan installer downloaded!"
else
  echo "*** Yes ckan installer is here!"
fi

echo "*** Installing ckan installer package..."
dpkg -i $cur_dir/ckan_installer/installer/python-ckan_2.8-xenial_amd64.deb
echo "*** Ckan installed from package!"

#Pre-configure and install postfix 
echo "*** Setting up postfix..."
debconf-set-selections <<< "postfix postfix/mailname string $site_url"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
apt install -y postfix
echo "*** postfix set up!"

#Fixing virtual environment
echo "*** Fixing virtual environment..."
apt install -y python-dev python-virtualenv
#Enter in virtual environment
#echo "*** Entering in virtual environment..."
. /usr/lib/ckan/default/bin/activate
cd /usr/lib/ckan/default/src/ckan
#echo "*** Inside virtual environment!"
#cp /usr/bin/python2.7 $(which python2.7)
echo "Virtual environment fixed!"

#create ckan_default role 
echo "*** Setting up Ckan database..."
apt install -y postgresql
echo -n "create user ckan_default password '$ckan_default_password' nosuperuser nocreatedb nocreaterole" > $cur_dir/ckan_installer/pg/create_user1.sql
sudo -u postgres psql --file=$cur_dir/ckan_installer/pg/create_user1.sql
#create ckan_default db ith ckan_default as owner
sudo -u postgres createdb -O ckan_default ckan_default -E utf-8
#create datastore_default role
echo -n "create user datastore_default password '$datastore_default_password' nosuperuser nocreatedb nocreaterole" > $cur_dir/ckan_installer/pg/create_user2.sql
sudo -u postgres psql --file=$cur_dir/ckan_installer/pg/create_user2.sql
#create datastore_default db with ckan_default as owner
sudo -u postgres createdb -O ckan_default datastore_default -E utf-8
#check dbs created
sudo -u postgres psql -l
echo "*** Ckan database set up!"

#Configuring solr jetty
echo "*** Configuring solr jetty..."
apt install -y solr-jetty
mv /etc/solr/conf/schema.xml /etc/solr/conf/schema.xml.bak
ln -s /usr/lib/ckan/default/src/ckan/ckan/config/solr/schema.xml /etc/solr/conf/schema.xml
cp $cur_dir/ckan_installer/sys_config_files/solr_jetty/jetty8 /etc/default/jetty8
apt upgrade -y 
curl http://localhost:8983/solr/admin/
echo "*** solr jetty configured!"

#Configure production.ini from template
echo "*** Configuring production.ini..."
sed -e "s;%logo%;$logo;g " -e "s;%site_title%;$site_title;g" -e "s;%site_url%;$site_url;g" -e "s;%ckan_port%;$ckan_port;g" -e "s;%ckan_default_password%;$ckan_default_password;g" -e "s;%datastore_default_password%;$datastore_default_password;g" -e "s;%email_to%;$email_to;g" -e "s;%error_email_from%;$error_email_from;g" -e "s;%smtp_server%;$smtp_server;g" -e "s;%smtp_starttls%;$smtp_starttls;g" -e "s;%smtp_user%;$smtp_user;g" -e "s;%smtp_password%;$smtp_password;g" -e "s;%smtp_mail_from%;$smtp_mail_from;g" -e "s;%contact_mail_to%;$contact_mail_to;g" -e "s;%contact_recipient_name%;$contact_recipient_name;g" -e "s;%contact_subject%;$contact_subject;g" -e "s;%storage_path%;$storage_path;g" $cur_dir/ckan_installer/config/default/production.ini > /etc/ckan/default/production.ini
echo "*** production.ini configured!"

#Configure who.ini and apache.wsgi
echo "*** Configuring who.ini & apache.wsgi"
cp $cur_dir/ckan_installer/config/default/who.ini /etc/ckan/default/
cp $cur_dir/ckan_installer/config/default/apache.wsgi /etc/ckan/default/
echo "*** who.ini & apache.wsgi configured!"

#Configuring email
echo "*** Configuring email..."
cp $cur_dir/ckan_installer/sys_config_files/emails/* /usr/lib/ckan/default/src/ckan/ckan/templates/emails
echo "*** Email configured!"

#Upgrade pip
echo "*** Upgrading pip..."
pip install --upgrade pip
echo "*** pip upgraded!"

#Install ckanapi
echo "*** installing ckan api..."
pip install ckanapi
echo "*** Ckan api installed!"

#Install xloader
echo "*** Installing xloader..."
pip install -e git+https://github.com/davidread/ckanext-xloader.git#egg=ckanext-xloader
cd /usr/lib/ckan/default/src/ckanext-xloader
pip install -r requirements.txt
pip install -U requests[security]
sudo -u postgres psql datastore_default -f full_text_function.sql
sudo -u postgres createdb -O ckan_default xloader_jobs -E utf-8
echo "*** xloader installed!"

#Install viewhelpers
echo "*** Installing viewhelpers..."
cd /usr/lib/ckan/default/src/
#git clone https://github.com/ckan/ckanext-viewhelpers.git
cp -r $cur_dir/ckan_installer/extensions/viewhelpers/ckanext-viewhelpers /usr/lib/ckan/default/src/
cd ckanext-viewhelpers/
python setup.py install
echo "*** viewhelpers installed!"

#Install mapviews
echo "*** Installing mapviews..."
cd /usr/lib/ckan/default/src/
#git clone https://github.com/ckan/ckanext-mapviews.git
cp -r $cur_dir/ckan_installer/extensions/mapviews/ckanext-mapviews /usr/lib/ckan/default/src/
cd ckanext-mapviews
python setup.py install
echo "*** mapviews installed!"

#Install basiccharts
echo "*** Installing basiccharts..."
cd /usr/lib/ckan/default/src/
#git clone https://github.com/ckan/ckanext-basiccharts.git
cp -r $cur_dir/ckan_installer/extensions/basiccharts/ckanext-basiccharts /usr/lib/ckan/default/src/
cd ckanext-basiccharts
python setup.py install
echo "*** basiccharts installed!"

#Install dashboard
echo "*** Installing dashboard..."
cd /usr/lib/ckan/default/src/
#git clone https://github.com/ckan/ckanext-dashboard.git
cp -r $cur_dir/ckan_installer/extensions/dashboard/ckanext-dashboard /usr/lib/ckan/default/src/
cp $cur_dir/ckan_installer/extensions/dashboard/navigablemap.js /usr/lib/ckan/default/lib/python2.7/site-packages/ckanext_mapviews-0.1-py2.7.egg/ckanext/mapviews/theme/public/
cd ckanext-dashboard
python setup.py install
echo "*** dashboard installed!"

#Install geoview
echo "*** Installing geoview..."
cd /usr/lib/ckan/default/src/
#git clone https://github.com/ckan/ckanext-geoview.git
cp -r $cur_dir/ckan_installer/extensions/geoview/ckanext-geoview /usr/lib/ckan/default/src/
cd ckanext-geoview
python setup.py develop
echo "*** geoview installed!"

#Install agsview
echo "*** Installing agsview..."
cd /usr/lib/ckan/default/src/
#git clone https://github.com/AppGeo/ckanext-agsview.git
cp -r $cur_dir/ckan_installer/extensions/agsview/ckanext-agsview /usr/lib/ckan/default/src/
cd ckanext-agsview
python setup.py develop
echo "*** agsview installed!"

#Install contact
echo "*** Installing contact..."
cd /usr/lib/ckan/default/src/ 
#git clone https://github.com/NaturalHistoryMuseum/ckanext-contact.git
#cp $cur_dir/ckan_installer/config/contact/contact.py /usr/lib/ckan/default/src/ckanext-contact/ckanext/contact/controllers/contact.py
cp -r $cur_dir/ckan_installer/extensions/contact/ckanext-contact /usr/lib/ckan/default/src/
cd ckanext-contact
python setup.py develop
echo "*** contact installed!"

#Install ider_theme
echo "*** Installing ider_theme..."
cd /usr/lib/ckan/default/src/ 
#git clone https://github.com/NaturalHistoryMuseum/ckanext-contact.git
#cp $cur_dir/ckan_installer/config/contact/contact.py /usr/lib/ckan/default/src/ckanext-contact/ckanext/contact/controllers/contact.py
cp -r $cur_dir/ckan_installer/extensions/ider_theme/ckanext-ider_theme /usr/lib/ckan/default/src/
cp $cur_dir/ckan_installer/extensions/ider_theme/logoBogotaMejor112x279.png /usr/lib/ckan/default/src/ckan/ckan/public/base/images/
cp $cur_dir/ckan_installer/extensions/ider_theme/logoPedro_2.png /usr/lib/ckan/default/src/ckan/ckan/public/base/images/
cp $cur_dir/ckan_installer/extensions/ider_theme/c1.jpg /usr/lib/ckan/default/src/ckan/ckan/public/base/images/
cp $cur_dir/ckan_installer/extensions/ider_theme/c2.jpg /usr/lib/ckan/default/src/ckan/ckan/public/base/images/
cp $cur_dir/ckan_installer/extensions/ider_theme/c3.jpg /usr/lib/ckan/default/src/ckan/ckan/public/base/images/
cp $cur_dir/ckan_installer/extensions/ider_theme/Mapa_IDER3.png /usr/lib/ckan/default/src/ckan/ckan/public/base/images/
cd ckanext-ider_theme
python setup.py develop
echo "*** ider_theme installed!"

#Install spatial
echo "*** Installing spatial..."
apt install -y postgresql-9.5-postgis-2.2
cd /usr/lib/ckan/default/src/
sudo -u postgres psql -d ckan_default -f /usr/share/postgresql/9.5/contrib/postgis-2.2/postgis.sql
sudo -u postgres psql -d ckan_default -f /usr/share/postgresql/9.5/contrib/postgis-2.2/spatial_ref_sys.sql
sudo -u postgres psql -d ckan_default -c 'ALTER VIEW geometry_columns OWNER TO ckan_default;'
sudo -u postgres psql -d ckan_default -c 'ALTER TABLE spatial_ref_sys OWNER TO ckan_default;'
sudo -u postgres psql -d ckan_default -c "SELECT postgis_full_version()"
pip install -e "git+https://github.com/okfn/ckanext-spatial.git#egg=ckanext-spatial"
cd ckanext-spatial
pip install -r pip-requirements.txt
cp $cur_dir/ckan_installer/extensions/spatial/dataset_map_sidebar.html /usr/lib/ckan/default/src/ckanext-spatial/ckanext/spatial/templates/spatial/snippets
echo "*** spatial installed!"

#Install harvester
echo "*** Installing harvester..."
cd /usr/lib/ckan/default/src/
pip install -e git+https://github.com/ckan/ckanext-harvest.git#egg=ckanext-harvest
cd ckanext-harvest
pip install -r pip-requirements.txt
echo "*** harvester installed!"

#Install DCAT
echo "*** Installing DCAT..."
cd /usr/lib/ckan/default/src/
pip install -e git+https://github.com/ckan/ckanext-dcat.git#egg=ckanext-dcat
cd ckanext-dcat
pip install -r requirements.txt
echo "*** DCAT Installed!"
 
#Installing pdf view
echo "*** Installing pdf_view..."
cd /usr/lib/ckan/default/src/
pip install ckanext-pdfview
echo "*** Pdf_view installed!"

#Install ider_security
echo "*** Installing ider_security..."
cd /usr/lib/ckan/default/src/ 
cp -r $cur_dir/ckan_installer/extensions/ider_security/ckanext-ider_security /usr/lib/ckan/default/src/
cd ckanext-ider_security
#python setup.py develop
echo "*** ider_security installed!"

#Install pycsw
#echo "*** Installing pycsw..."
#cd /usr/lib/ckan/default/src/
#git clone https://github.com/geopython/pycsw.git
#cd pycsw
#git checkout 2.2.0
#apt-get build-dep -y lxml
#pip install -e .
#python setup.py build
#python setup.py install
#sudo -u postgres createdb -O ckan_default pycsw -E utf-8
#sudo -u postgres psql -d pycsw -f /usr/share/postgresql/9.3/contrib/postgis-2.1/postgis.sql
#sudo -u postgres psql -d pycsw -f /usr/share/postgresql/9.3/contrib/postgis-2.1/spatial_ref_sys.sql
#sudo -u postgres psql -d pycsw -c 'ALTER VIEW geometry_columns OWNER TO ckan_default;'
#sudo -u postgres psql -d pycsw -c 'ALTER TABLE spatial_ref_sys OWNER TO ckan_default;'
#sudo -u postgres psql -d pycsw -c "SELECT postgis_full_version()"
#cp default-sample.cfg default.cfg
#ln -s /usr/lib/ckan/default/src/pycsw/default.cfg /etc/ckan/default/pycsw.cfg
#echo "*** pycsw installed!"

#Initialize CKAN database
echo "*** Initializing Ckan database..."
cd /usr/lib/ckan/default/src/
ckan db init
echo "*** Ckan Database initialized!"
 
#Finish installation of spatial
echo "*** Finishing installation of spatial..."
cd /usr/lib/ckan/default/src/ckanext-spatial
paster --plugin=ckanext-spatial spatial initdb 4326 --config=/etc/ckan/default/production.ini
echo "*** Installation of spatial finished!"

#Finish installation of harvest
echo "*** Finishing installation of harvester..."
cd /usr/lib/ckan/default/src/ckanext-harvest
paster --plugin=ckanext-harvest harvester initdb --config=/etc/ckan/default/production.ini
cp $cur_dir/ckan_installer/extensions/harvest/harvester_cron /var/spool/cron/crontabs/www-data
chown www-data:crontab /var/spool/cron/crontabs/www-data
chmod 755 /var/spool/cron/crontabs/www-data
cat /var/spool/cron/crontabs/www-data | crontab -
echo "*** Installation of harvester finished!"

#DATASTORE set permissions
echo "*** Setting permissions of datastore..."
ckan datastore set-permissions | sudo -u postgres psql --set ON_ERROR_STOP=1
echo "*** Datastore permissions set up!"

#FILESTORE
echo "*** Setting up filestore..."
mkdir -p /var/lib/ckan/default
chown www-data /var/lib/ckan/default
chmod u+rwx /var/lib/ckan/default
echo "*** Filestore setup!"

# #Fix css
# echo "*** Fixing css..."
# cp $cur_dir/ckan_installer/sys_config_files/css/main.min.css /usr/lib/ckan/default/src/ckan/ckan/public/base/css
# echo "*** Css fixed!"

#Installing auth
echo "*** Installing auth..."
cp $cur_dir/ckan_installer/sys_config_files/auth/get.py /usr/lib/ckan/default/src/ckan/ckan/logic/action/
echo "*** Auth installed!"



#Restart services
echo "*** Restarting apache..."
service apache2 restart
echo "*** Apache restarted!"
echo "*** Restarting nginx..."
service nginx restart
echo "*** Nginx restarted!"

#Create sysadmin user
echo "*** Creating sysadmin user..."
cd /usr/lib/ckan/default/src/ckan
yes | paster sysadmin add $admin_name email="$admin_email" password="$admin_password" fullname="$admin_fullname" -c /etc/ckan/default/production.ini | tee /usr/lib/ckan/default/admin.json
echo "*** Sysadmin user created!"
 
#Configure xloader jobs in supervisord
echo "*** Configuring xloader jobs in supervisord..."
apt install -y supervisor
touch /var/log/ckan-worker.log
chown www-data:www-data /var/log/ckan-worker.log
chmod 777 /var/log/ckan-worker.log
touch /var/run/supervisor.sock
chown www-data:www-data /var/run/supervisor.sock
chmod 777 /var/run/supervisor.sock
cp /usr/lib/ckan/default/src/ckan/ckan/config/supervisor-ckan-worker.conf /etc/supervisor/conf.d/
echo "*** Restarting supervisord..."
service supervisor restart
sleep 5
echo "*** Restarting Done! Testing...."
supervisorctl status
echo "*** Testing Done!"
#supervisorctl restart ckan-worker:*
echo "*** Xloader jobs configured in supervisord!"

#Configure harvester jobs in supervisord
echo "*** Configuring harvester jobs in supervisord..."
mkdir -p /var/log/ckan/std/
touch /var/log/ckan/std/gather_consumer.log
chown www-data:www-data /var/log/ckan/std/gather_consumer.log
chmod 755 /var/log/ckan/std/gather_consumer.log
touch /var/log/ckan/std/fetch_consumer.log
chown www-data:www-data /var/log/ckan/std/fetch_consumer.log
chmod 755 /var/log/ckan/std/fetch_consumer.log
cp $cur_dir/ckan_installer/extensions/harvest/ckan_harvesting.conf /etc/supervisor/conf.d/
echo "*** Supervisorctl reread..."
supervisorctl reread
echo "*** Done!"
echo "*** Adding ckan_gather_consumer and ckan_fetch_consumer jobs..."
sleep 5
supervisorctl add ckan_gather_consumer
supervisorctl add ckan_fetch_consumer
echo "*** Jobs added Done!"
echo "*** Testing supervisor Jobs..."
sleep 12
supervisorctl status
echo "*** Job Tested!"

#Test DATASTORE
echo "*** Testing datastore..."
curl -X GET "http://127.0.0.1:"$ckan_port"/api/3/action/datastore_search?resource_id=_table_metadata"
echo "*** Testing Done!"

#Restore users
echo "*** Restoring users..."
ckanapi load users -I $cur_dir/ckan_installer/pg/users.jsonl -p 3 -c /etc/ckan/default/production.ini
echo "*** Users restored!"

#Restore Organizations
echo "*** Restoring organizations..."
myvariable=$(whoami)
echo $myvariable
ckanapi load organizations -I $cur_dir/ckan_installer/pg/organizations.jsonl -p 3 -c /etc/ckan/default/production.ini
echo "*** Organizations restored!"

#Restore groups
echo "*** Restoring groups..."
ckanapi load groups -I $cur_dir/ckan_installer/pg/groups.jsonl -p 3 -c /etc/ckan/default/production.ini
echo "*** Groups restored!"

#Restore datasets
echo "*** Restoring datasets..."
ckanapi load datasets -I $cur_dir/ckan_installer/pg/datasets.jsonl -p 3 -c /etc/ckan/default/production.ini
echo "*** Datasets restored!"

# # #Restoring resource_view
# # #echo "*** Restoring resource_view"
# # #echo -n "drop table public.resource_view" > $cur_dir/pg/drop_resource_view.sql
# # #cmd_str="PGPASSWORD='$ckan_default_password' psql --file=$cur_dir/pg/drop_resource_view.sql -h localhost -p 5432 -U ckan_default"
# # #eval $cmd_str
# # #cmd_str="PGPASSWORD='$ckan_default_password' psql --file=$cur_dir/pg/backup_resource_view.sql -h localhost -p 5432 -U ckan_default"
# # #eval $cmd_str
# # #echo "*** resource_view restored!"
 
#Recreate Indexes
echo "*** Recreating indexes..."
paster --plugin=ckan search-index rebuild --config=/etc/ckan/default/production.ini
echo "*** Indexes recreated!"

echo "*** All Done ***!"
