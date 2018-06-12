#!/usr/bin/env bash

PATH=/opt/oulib/ojs/bin:/usr/local/bin:/usr/bin:/bin:/sbin:$PATH

source /opt/oulib/ojs/etc/ojs_conf.sh

if [  -z "$1" ]; then
  cat <<USAGE
ojs_dump.sh performs a dump of the database for a OJS site.

Usage: ojs_dump.sh \$SITEPATH
            
\$SITEPATH  OJS site to sql dump (eg. /srv/example).
USAGE

  exit 1;
fi

SITEPATH=$1

echo "Dumping $SITEPATH database"

## Grab the basename of the site to use in a few places.
SITE=$(basename "$SITEPATH")

## Perform sql-dump
sudo -u nginx bash -c "mysqldump -h $PKPDBHOST -u $PKPUSER -p$PKPPASS $PKPDB  --result-file=$SITEPATH/db/ojs_${SITE}_dump.sql"

echo "Finished dumping $SITEPATH database."
