#установка необходимых пакетов
apt-get update
apt-get install -y openssl
apt-get -y install vim
apt-get -y install wget
apt-get -y install nginx
apt-get -y install mariadb-server
echo "=========PHP-INSTALL========="
apt-get -y install  php7.3 php-fpm php-mysql php-mbstring php-json
echo "=========PHP-INSTALL-END========="

#владелец, права, папка, конфиг nginx
chown -R www-data /var/www/*
chmod -R 755 /var/www/*
mkdir /var/www/site
touch /var/www/site/index.php
mv /tmp/site.conf /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/site.conf /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

#генерируем ssl
mkdir /etc/nginx/ssl
openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/ssl/certs/site.crt -keyout /etc/ssl/private/site.key -subj "/C=RU/ST=Kazan/L=Kazan/O=21 School/OU=lcarry/CN=site"

#создаем БД
service mysql start
mysql -e "CREATE DATABASE wp_base;"
mysql -e "CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';"
mysql -e "GRANT ALL PRIVILEGES ON wp_base.* TO 'admin'@'localhost' WITH GRANT OPTION;"
mysql -e "UPDATE mysql.user SET plugin='mysql_native_password' WHERE user='admin';"
mysql -e "FLUSH PRIVILEGES;"

#устанавливаем wordpress
cd /tmp/
wget -c https://wordpress.org/latest.tar.gz
tar -xvzf /tmp/latest.tar.gz
mv wordpress/ /var/www/site/
mv /tmp/wp-config.php /var/www/site/wordpress

#устанавливаем phpmyadmin
mkdir /var/www/site/phpmyadmin
wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz
tar -xzvf phpMyAdmin-5.0.4-all-languages.tar.gz
rm -rf phpMyAdmin-5.0.4-all-languages.tar.gz
mv phpMyAdmin-5.0.4-all-languages/ /var/www/site/phpmyadmin
mv /tmp/config.inc.php /var/www/site/phpmyadmin/phpMyAdmin-5.0.4-all-languages  

service php7.3-fpm start
service nginx start
