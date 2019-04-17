#!/usr/bin/env bash

PATH=/opt/oulib/ojs/bin:/usr/local/bin:/usr/bin:/bin:/sbin:$PATH

source /opt/oulib/ojs/etc/ojs_conf.sh

if [  -z "$1" ]; then
  cat <<USAGE
ojs_importdb.sh performs a database import to an OJS site.

Usage: ojs_importdb.sh \$SITEPATH

\$SITEPATH  OJS target site for sql import (eg. /srv/example).
USAGE

  exit 1;
fi

SITEPATH=$1

echo "Creating $SITEPATH database if not alreay present"
sudo -u nginx bash -c "mysql -h $PKPDBHOST -u $PKPUSER -p$PKPPASS -e 'CREATE DATABASE IF NOT EXISTS $PKPDB'"

echo "Importing $SITEPATH database"

## Grab the basename of the site to use in a few places.
SITE=$(basename "$SITEPATH")


## Import sql-dump
sudo -u nginx bash -c "mysql -h $PKPDBHOST -u $PKPUSER -p$PKPPASS $PKPDB < $SITEPATH/db/ojs_${SITE}_dump.sql"

echo "Imported $(sudo -u nginx bash -c "mysql --disable-column-names -B -h $PKPDBHOST -u $PKPUSER -p$PKPPASS $PKPDB -e 'select count(*) from information_schema.tables where table_schema = database();'") Tables"


echo "Finished importing $SITEPATH database."
