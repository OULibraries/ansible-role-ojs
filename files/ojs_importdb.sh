#!/usr/bin/env bash

PATH=/opt/oulib/ojs/bin:/usr/local/bin:/usr/bin:/bin:/sbin:$PATH

source /opt/oulib/ojs/etc/ojs_conf.sh

if [  -z "$1" ]; then
  cat <<USAGE
ojs_importdb.sh imports a OJS database file. 

Usage: ojs_importdb.sh \$SITEPATH [\$DBFILE]
            
\$SITEPATH  OJS site path
\$DBFILE    OJS database file to load

If \$DBFILE is not given, then \$SITEPATH/db/ojs_\$SITE_dump.sql will be used.
USAGE

  exit 1;
fi

SITEPATH=$1
echo "Processing $SITEPATH"

if [[ ! -e $SITEPATH ]]; then
    echo "No site exists at ${SITEPATH}."
    exit 1;
fi

## Grab the basename of the NEW site to use in a few places.
SITE=$(basename "$SITEPATH")

if [[ ! -z "$2" ]]
then
    DBFILE=$2
else
    DBFILE="${SITEPATH}/db/ojs_${SITE}_dump.sql"
fi       

if [[ ! -f $DBFILE ]]; then
    echo "No file exists at ${DBFILE}."
    exit 1;
fi

## Load sql-dump to local DB
echo "Importing database for $SITE from file at $DBFILE."
sudo -u apache mysql -h ${PKPDBHOST} -u ${PKPUSER} -p${PKPPASS} ${PKPDB} < ${DBFILE} || exit 1;
echo "Database imported."
