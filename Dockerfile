# Based on https://github.com/progaming/php-oci-docker/blob/master/Dockerfile

FROM php:8.2.0-fpm-alpine3.17

# Install Oracle Instantclient
RUN mkdir /opt/oracle \
    && cd /opt/oracle \
    && wget https://download.oracle.com/otn_software/linux/instantclient/218000/instantclient-basiclite-linux.x64-21.8.0.0.0dbru.zip \
    && wget https://download.oracle.com/otn_software/linux/instantclient/218000/instantclient-sdk-linux.x64-21.8.0.0.0dbru.zip \
    && unzip instantclient-basiclite-linux.x64-21.8.0.0.0dbru.zip \
    && unzip instantclient-sdk-linux.x64-21.8.0.0.0dbru.zip \
    && rm -rf /opt/oracle/*.zip \
    && echo "export LD_LIBRARY_PATH=/lib:/opt/oracle/instantclient_21_8:$LD_LIBRARY_PATH" >> /etc/profile.d/oracle_client.sh \
    && echo "export PATH=/opt/oracle/instantclient_21_8:$PATH" >> /etc/profile.d/oracle_client.sh \
    && apk add --no-cache \
                autoconf \
                curl \
                git \
                freetype-dev \
                libjpeg-turbo-dev \
                libmcrypt-dev \
                libpng-dev \
                libzip-dev \
                zlib-dev \
                icu-dev \
                g++ \
                make \
                unixodbc-dev \
                libxml2-dev \
                libaio \
                libaio-dev \
                libnsl \
                libc6-compat \
                openssl \
                linux-headers \
    && ln -s /lib/libc.so.6 /usr/lib/libresolv.so.2 \
    && ln -s /lib/ld-musl-x86_64.so.1 /lib/ld-linux-x86-64.so.2

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- \
        --install-dir=/usr/local/bin \
        --filename=composer

# Install PHP extensions
RUN docker-php-ext-configure gd \
    && echo 'instantclient,/opt/oracle/instantclient_21_8/' | pecl install oci8 \
    && docker-php-ext-configure pdo_oci --with-pdo-oci=instantclient,/opt/oracle/instantclient_21_8,21.8 \
    && docker-php-ext-install \
            intl \
            gd \
            pdo_oci \
            soap \
            sockets \
            zip \
            pcntl \
    && docker-php-ext-enable \
            oci8 \
            opcache

# Install APCu and APC backward compatibility
# RUN pecl install apcu \
#     && pecl install apcu_bc-1.0.3 \
#     && docker-php-ext-enable apcu --ini-name 10-docker-php-ext-apcu.ini \
#     && docker-php-ext-enable apc --ini-name 20-docker-php-ext-apc.ini

# Install PHPUnit
# ADD phpunit-9.5.20.phar /usr/local/bin/phpunit
# RUN chmod +x /usr/local/bin/phpunit
