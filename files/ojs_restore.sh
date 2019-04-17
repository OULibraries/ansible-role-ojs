#!/usr/bin/env bash

PATH=/opt/oulib/ojs/bin:/usr/local/bin:/usr/bin:/bin:/sbin:$PATH

## Require arguments
if [  -z "$1" ]; then
    cat <<USAGE
ojs_restore.sh restores an existing site snapshot backup.

Usage: ojs_restore.sh \$SITEPATH \$DOW

\$SITEPATH   path to OJS site to restore
\$DOW        lowercase day-of-week abbreviation indicating backup 
             to restore. Must be one of sun, mon, tue, wed, thu, fri, or sat.
USAGE

    exit 1;
fi

SITEPATH=$1
DOW=$2
SITE=$(basename "$SITEPATH")
SNAPSHOTFILE="${SITEPATH}/snapshots/${SITE}.${DOW}.tar.gz"

if [ ! -d "$SITEPATH" ]; then
    echo "${SITEPATH} doesn't exist, nothing to restore."
    exit 0
fi

if [ -z "${DOW}" ]; then
    echo "No snapshot specified."
    echo "The following snapshots exist:"
    ls "${SITEPATH}/snapshots/"
    exit 0
fi

if [ ! -f "$SNAPSHOTFILE" ]; then
    echo "No snapshot at ${SNAPSHOTFILE}"
    exit 0
fi

echo "Restoring ${DOW} snapshot of ${SITEPATH}."

# Tarballs include the $SITE folder, so we need to strip that off
# when extracting
sudo -u nginx tar -xvf  "${SNAPSHOTFILE}" -C "${SITEPATH}" --strip-components=1 --no-overwrite-dir

echo "Files from snapshot restored." 
echo "Now run ojs_importdb.sh ${SITEPATH} to restore the db for the site."
