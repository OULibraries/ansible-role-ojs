#!/usr/bin/env bash
# ojs_snapshot.sh creates a db dump and tar backup for a site.
PATH=/opt/ojs/bin:/usr/local/bin:/usr/bin:/bin:/sbin:$PATH

source /opt/ojs/etc/ojs_conf.sh

if [  -z "$1" ]; then
    cat <<USAGE
ojs_snapshot.sh creates a db dump and tar backup for a site.

Usage: ojs_snapshot.sh \$SITEPATH
            
\$SITEPATH   OJS site to tar (eg. /srv/example).

Backups will be stored at $SITEPATH/snapshots/$SITE.$DOW.tar. $DOW is
the lowercase day-of-week abbreviation for the current day.

USAGE
    exit 1;
fi

SITEPATH=$1
SITE=$(basename "$SITEPATH")
SNAPSHOTDIR="$SITEPATH/snapshots"
DOW=$( date +%a | awk '{print tolower($0)}')

if [[ ! -e "$SITEPATH" ]]; then
    echo "Can't create snapshot of nonexistent site at $SITEPATH."
    exit 1;
fi

echo "Making ${DOW} snapshot for $SITEPATH"

# Make a db backup in case the latest one is old
ojs_dump.sh $SITEPATH

# Tar files required to rebuild, with $SITE as TLD inside tarball. 
#sudo -u apache tar -cf  "$SNAPSHOTDIR/$SITE.$DOW.tar" -C /srv/ "${SITE}/etc" "${SITE}/files" "${SITE}/ojs" "${SITE}/public"
sudo -u apache tar --exclude "${SNAPSHOTDIR}" -cf "$SNAPSHOTDIR/$SITE.$DOW.tar" "${SITEPATH}"

echo "Snapshot created at ${SNAPSHOTDIR}/${SITE}.${DOW}.tar"
