import os
import site

site.addsitedir(os.path.abspath(os.path.dirname(__file__)))
os.environ['DJANGO_SETTINGS_MODULE'] = 'demo_settings'
import django.core.handlers.wsgi
application = django.core.handlers.wsgi.WSGIHandler()
