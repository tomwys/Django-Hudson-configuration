#!/bin/sh
cd `dirname $0`/workspace
TMP=/tmp/hudson-python-install
rm -rf $TMP _
python setup.py install --root $TMP
mv $TMP/usr/local/lib/python2.6/dist-packages/ _
CONFIG=`cat tox.ini | grep commands | sed 's/commands = django-admin.py test //'`
echo `pwd`/_ > project.pth
cat << eof > tox_hudson.ini
[tox]
envlist = py26
[testenv]
commands = pip uninstall prl-www -y
        mv project.pth .tox/py26/lib/python2.6/site-packages/project.pth
	django-admin.py hudson --exclude=migrations $CONFIG
eof
tox -c tox_hudson.ini
