# -----------------------------
# Dockerfile para Render: PHP + Apache + PostgreSQL
# -----------------------------
FROM php:8.2-apache

# -----------------------------
# Variables de entorno
# -----------------------------
# Render inyecta el puerto dinámico
ENV PORT=10000

# -----------------------------
# Instalar extensiones de PHP necesarias
# -----------------------------
RUN apt-get update && apt-get install -y \
    libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql

# -----------------------------
# Copiar la aplicación
# -----------------------------
WORKDIR /var/www/html
COPY . /var/www/html/

# -----------------------------
# Configurar Apache para Render
# -----------------------------
# Cambiar el puerto de Apache al que Render asigna
RUN sed -i "s/80/${PORT}/g" /etc/apache2/sites-available/000-default.conf \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Habilitar mod_rewrite si usas URLs amigables
RUN a2enmod rewrite

# Exponer el puerto que Render usará
EXPOSE ${PORT}

# -----------------------------
# Iniciar Apache en primer plano
# -----------------------------
CMD ["apache2-foreground"]
