#getting base image PHP

FROM php:7.4-apache

MAINTAINER priyam singh <2020priyamsingh@gmail.com>

# Executed during the building of the image
RUN apt-get update
RUN apt-get install -y libzip-dev zip unzip zlib1g-dev
RUN docker-php-ext-install mysqli zip
 
# Executed when container created out of image
CMD ["apache2ctl","-D","FOREGROUND"]
EXPOSE 80 

