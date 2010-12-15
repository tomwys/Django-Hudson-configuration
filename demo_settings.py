from base_settings import *

from os import path

PROJECT=__file__.split('/')[5]

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': path.join('/hdbs', PROJECT + '-database.sqlite'),
    }
}
