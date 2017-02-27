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

echo "Importing $SITEPATH database"

## Grab the basename of the site to use in a few places.
SITE=$(basename "$SITEPATH")

## Import sql-dump
sudo -u apache bash -c "mysql -h $PKPDBHOST -u $PKPUSER -p$PKPPASS -D $PKPDB < $SITEPATH/db/ojs_${SITE}_dump.sql"

echo "Finished importing $SITEPATH database."

