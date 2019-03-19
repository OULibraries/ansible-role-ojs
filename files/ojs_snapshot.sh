#!/usr/bin/env bash

PATH=/opt/oulib/ojs/bin:/usr/local/bin:/usr/bin:/bin:/sbin:$PATH

source /opt/oulib/ojs/etc/ojs_conf.sh

if [  -z "$1" ]; then
    cat <<USAGE
ojs_snapshot.sh creates a db dump and tar backup for a site.

Usage: ojs_snapshot.sh \$SITEPATH
            
\$SITEPATH   OJS site to tar (eg. /srv/example).

Backups will be stored at $SITEPATH/snapshots/$SITE.$DOW.tar.gz. $DOW is
the lowercase day-of-week abbreviation for the current day.

USAGE
    exit 1;
fi

SITEPATH=$1
SITE=$(basename "$SITEPATH")
OJSDIR=$(basename "${PKPDIR}")
SNAPSHOTDIR="$SITEPATH/snapshots"
DOW=$( date +%a | awk '{print tolower($0)}')

if [[ ! -e "$SITEPATH" ]]; then
    echo "Can't create snapshot of nonexistent site at $SITEPATH."
    exit 1;
fi

echo "Making ${DOW} snapshot for $SITEPATH"

# Make a db backup in case the latest one is old
ojs_dump.sh $SITEPATH
# If we don't have a target s3 bucket, use the local filesystem.
if [ -z "${OJS_S3_SNAPSHOT_DIR}" ]; then
 # Tar files required to rebuild, with $SITE as TLD inside tarball.
    sudo -u nginx tar -czf  "$SNAPSHOTDIR/$SITE.$DOW.tar.gz" -C ${PKPPARENT}/ "${SITE}/db" "${SITE}/etc" "${SITE}/files" "${SITE}/${OJSDIR}" "${SITE}/public"

# Otherwise use aws s3
else
    SNAPSHOTDIR=${OJS_S3_SNAPSHOT_DIR}
    sudo -u nginx tar -cf - -C ${PKPPARENT} "${SITE}/etc" "${SITE}/db" "${SITE}/files" "${SITE}/${OJSDIR}" "${SITE}/public" | gzip --stdout --best | aws s3 cp - "$SNAPSHOTDIR/$SITE.$DOW.tar.gz" --sse
fi

echo "Snapshot created at ${SNAPSHOTDIR}/${SITE}.${DOW}.tar.gz"
