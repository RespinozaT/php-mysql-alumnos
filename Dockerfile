FROM php:8.2-apache

# Instalar dependencias y extensiones
RUN apt-get update && apt-get install -y \
    libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql \
    && docker-php-ext-enable pdo_pgsql \
    && rm -rf /var/lib/apt/lists/*

# Copiar aplicación
WORKDIR /var/www/html
COPY . /var/www/html/

# Configurar Apache
RUN a2enmod rewrite \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Puerto dinámico para Render
ENV PORT 10000
EXPOSE $PORT

# Iniciar Apache usando puerto dinámico
CMD sed -i "s|80|${PORT}|g" /etc/apache2/ports.conf \
    && sed -i "s|80|${PORT}|g" /etc/apache2/sites-available/000-default.conf \
    && apache2-foreground
