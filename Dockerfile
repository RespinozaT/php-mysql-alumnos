FROM php:8.2-apache

# Instala extensiones necesarias
RUN docker-php-ext-install pdo pdo_mysql

# Copia los archivos del proyecto
COPY . /var/www/html/

ENV PORT=10000
EXPOSE 10000

# Cambiar Apache para que escuche en $PORT
RUN sed -i "s/80/\${PORT}/g" /etc/apache2/sites-available/000-default.conf

CMD ["apache2-foreground"]
