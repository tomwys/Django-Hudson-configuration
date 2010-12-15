DEMOS_DIR=/home/hudson/apache2/demos
NAME=$1
SETTINGS=$2
DIR=$DEMOS_DIR/$NAME
LDIR=`dirname $0`
DOMAIN="$NAME.hudson.tomwys.net"

# copy sources
mkdir $DIR
virtualenv --no-site-packages $DIR/env
. $DIR/env/bin/activate
pip -q install . --download-cache=/home/hudson/.pip_cache

# demo config
cp $LDIR/demo_settings.py $DIR/env/lib/python2.6/site-packages
cp $LDIR/django.wsgi $DIR/env/lib/python2.6/site-packages
cp $LDIR/start.sh $DIR
echo "from $SETTINGS import *" > $DIR/env/lib/python2.6/site-packages/base_settings.py

django-admin.py syncdb --noinput --settings=demo_settings
django-admin.py migrate --settings=demo_settings | true
django-admin.py loaddata demo --settings=demo_settings | true
echo "update django_site set domain=\"$DOMAIN\" where id=1;" | sqlite3 /hdbs/"$NAME-database.sqlite"
chmod a+rwX /hdbs -R

cp $LDIR/site-layout $LDIR/sites/$NAME
sed "s/domain/$DOMAIN/" -i $LDIR/sites/$NAME
sed "s@path@$DIR/env/lib/python2.6/site-packages/django.wsgi@" -i $LDIR/sites/$NAME


sudo apache2ctl restart
