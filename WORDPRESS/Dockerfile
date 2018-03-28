#Dockerfile para la creacion de un servidor Wordpress conectado a la base de datos mysql

FROM debian:latest

# Actualizar repositorios
RUN apt-get update

# Configurar mysql
RUN echo "mysql-server-5.5 mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server-5.5 mysql-server/root_password_again password root" | debconf-set-selections

# Descargar repositorios
RUN apt-get install apache2 php-mysql php libapache2-mod-php mysql-server wget nano curl -y

# Agregar permisos de mysql
RUN /etc/init.d/mysql start && mysql -uroot -proot -e "create database wordpress" && mysql -uroot -proot -e "grant all on wordpress.* to 'wordpress'@'localhost' identified by 'dbpassword'; flush privileges"

# Descargar y descomprimir Wordpress
RUN cd /tmp; wget https://wordpress.org/latest.tar.gz
RUN cd /var/www/html; rm index.html; tar xzvf /tmp/latest.tar.gz; mv wordpress/* .; rm -rf wordpress

# Copiar archivo de la conexion de la base de datos de Wordpress
COPY wp-config.php /var/www/html/wp-config.php

# Cambiar dueño a partir del directorio /var/www/html
RUN chown www-data:www-data /var/www/html/ -R

# Instalar y configurar supervisord
RUN apt-get install supervisor -y
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Exponer puertos
EXPOSE 22 80

# Ejecutar supervisord
CMD ["/usr/bin/supervisord"]
