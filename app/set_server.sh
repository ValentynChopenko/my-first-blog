#!/bin/bash

export DJANGO_DB_NAME="default"
export DJANGO_SUPERUSER_NAME="admin"
export DJANGO_SUPERUSER_EMAIL="admin@gmail.com"
export DJANGO_SUPERUSER_PASSWORD="djangoadmin"
echo 'Hello changes of all, guys!'

python -c "import os
os.environ['DJANGO_SETTINGS_MODULE'] = 'mysite.settings'
import django
django.setup()
from django.contrib.auth.management.commands.createsuperuser import get_user_model
if get_user_model().objects.filter(username='$DJANGO_SUPERUSER_NAME'):
    print('Super user already exists. SKIPPING...')
else:
    print('Creating super user...')
    get_user_model()._default_manager.db_manager('$DJANGO_DB_NAME').create_superuser(username='$DJANGO_SUPERUSER_NAME', email='$DJANGO_SUPERUSER_EMAIL', password='$DJANGO_SUPERUSER_PASSWORD')
    print('Super user created...')"
