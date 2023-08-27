#!/bin/bash

/usr/local/sbin/kea-admin db-version mysql -h mariadb -u kea -p kea -n kea
if [ $? -ne 0 ] ; then
  /usr/local/sbin/kea-admin db-init mysql -h mariadb -u kea -p kea -n kea
else
  /usr/local/sbin/kea-admin db-upgrade mysql -h mariadb -u kea -p kea -n kea
fi
