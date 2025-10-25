# -----------------------------
# Base: PHP 8.2 con Apache
# -----------------------------
FROM php:8.2-apache

# -----------------------------
# Instalar dependencias y extensiones PHP
# -----------------------------
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gettext-base \
    && docker-php-ext-install pdo pdo_pgsql \
    && rm -rf /var/lib/apt/lists/*

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
# Configurar puerto dinámico para Render
# Render asigna el puerto en la variable $PORT
# -----------------------------
ENV PORT 10000
EXPOSE $PORT

# -----------------------------
# CMD final: reemplazar el puerto en Apache y arrancar en primer plano
# -----------------------------
CMD sed -i "s|80|${PORT}|g" /etc/apache2/ports.conf \
    && sed -i "s|80|${PORT}|g" /etc/apache2/sites-available/000-default.conf \
    && apache2-foreground
