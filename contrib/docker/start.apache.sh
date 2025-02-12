#!/bin/bash

# Create the storage tree if needed and fix permissions
cp -r storage.skel/* storage/
chown -R www-data:www-data storage/ bootstrap/

if [ ! -f .migratedone ]; then
    php artisan migrate --force
    php artisan import:cities
    php artisan key:generate
    touch .migratedone
fi

# Refresh the environment
php artisan storage:link
php artisan horizon:publish
php artisan route:cache
php artisan view:cache
php artisan config:cache

# Finally run Apache
apache2-foreground
