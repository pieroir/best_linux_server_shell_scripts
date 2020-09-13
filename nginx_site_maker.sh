#!/bin/bash

echo "Hello, please enter your site name like example.com"
read siteName

mkdir /var/www/html/$siteName
chown root:www-data /var/www/html/$siteName
chmod 775 /var/www/html/$siteName


#nginx conf
nameConf=${siteName//./_}
fullsiteName=$siteName" www."$siteName

cp /etc/nginx/sites-available/default.example /etc/nginx/sites-available/$nameConf
sed -i "s/SITENAMEFULL/$fullsiteName/g" /etc/nginx/sites-available/$nameConf
sed -i "s/SITENAME/$siteName/g" /etc/nginx/sites-available/$nameConf
ln -s  /etc/nginx/sites-available/$nameConf /etc/nginx/sites-enabled/$nameConf
systemctl restart nginx

#install wordpress 
echo "Do you want install wordpress in it (Y/n) [default is no] ?"
read wpask
if [ $wpask = 'Y' ]
then
        echo "-----begin install wordpress ..."
        cd /var/www/html/$siteName
        curl -O https://wordpress.org/latest.tar.gz
        tar xzvf latest.tar.gz
        rm latest.tar.gz
        echo "-----wordpress download"
        mv wordpress/* /var/www/html/$siteName
        rm wordpress -r
        echo "------wordpress replaced"
        mysql -u root -pPASSWORD-e "CREATE DATABASE $nameConf CHARACTER SET utf8 COLLATE utf8_general_ci;"
        echo "------database maked with name = $siteName"
        chown root:www-data /var/www/html/$siteName -r
        chmod 775 /var/www/html/$siteName -r
        echo "------ install completed ."

fi
