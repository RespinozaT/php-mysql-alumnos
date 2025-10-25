# -----------------------------
# Dockerfile final para Render
# -----------------------------
FROM php:8.2-apache

# -----------------------------
# Instalar extensiones necesarias
# -----------------------------
RUN apt-get update && apt-get install -y libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql

# -----------------------------
# Copiar la aplicación
# -----------------------------
WORKDIR /var/www/html
COPY . /var/www/html/

# -----------------------------
# Configurar Apache
# -----------------------------
RUN a2enmod rewrite \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf

# -----------------------------
# Exponer el puerto que Render asigna
# -----------------------------
EXPOSE 10000

# -----------------------------
# Iniciar Apache con puerto dinámico
# -----------------------------
# Render define la variable de entorno $PORT
# Reemplazamos el puerto de Apache dinámicamente antes de arrancar
CMD envsubst '$PORT' < /etc/apache2/sites-available/000-default.conf > /etc/apache2/sites-enabled/000-default.conf && apache2-foreground
