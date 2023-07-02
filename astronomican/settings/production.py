from astronomican.settings.base import *

from dynaconf import Dynaconf

from os import environ
from os.path import join as path_join

STATIC_ROOT = path_join(BASE_DIR, '../static')

ASTRONOMICAN_CONFIG = environ["ASTRONOMICAN_CONFIG"]

settings = Dynaconf(
    environments=False,
    envvar_prefix="ASTRONOMICAN",
    settings_files=[ ASTRONOMICAN_CONFIG ],
)

SECRET_KEY = settings.get('SECRET_KEY', None)

DATABASES = settings.get('DATABASES', None)

DEBUG = settings.get('DEBUG', False)

ALLOWED_HOSTS = settings.get('ALLOWED_HOSTS', '*')

LANGUAGE_CODE = settings.get('LANGUAGE_CODE', 'en-us')
TIME_ZONE = settings.get('TIME_ZONE', 'America/New_York')
