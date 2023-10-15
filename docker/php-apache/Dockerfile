FROM php:8.1-apache

# Refer to https://tt-computing.com/docker-php8_0-lamp, Thanks!
  # Composer
  ARG composer_ver=2.5.5
  ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
  RUN chmod +x /usr/local/bin/install-php-extensions && sync && install-php-extensions @composer-${composer_ver}

  # その他パッケージ、PHP拡張
  RUN apt-get update \
    # unzip (composer create-project で必要)
    && apt-get install -y unzip git nodejs npm \
    # PHP GD
    && apt-get install -y zlib1g-dev libpng-dev libjpeg62-turbo-dev \
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    # PHP intl
    && apt-get install -y libicu-dev \
    && docker-php-ext-install intl \
    # PHP PDO MySQL
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install exif

  RUN rm -rf /var/www/html/* && git clone https://github.com/msyk/IMApp_Account /var/www/html
  RUN chown -R www-data /var/www
  RUN cd /var/www/html; composer update
  RUN echo "/* Added by Dockerfile */" >> /var/www/html/lib/params.php; \
    echo "\$dbDSN = 'mysql:host=db;port=3306;dbname=test_db;charset=utf8mb4';" >> /var/www/html/lib/params.php
  RUN cp /var/www/html/private/apache-deny-files.conf /etc/apache2/conf-enabled
