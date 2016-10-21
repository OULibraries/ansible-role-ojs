## Read useful values out of the config file

PKPCFG=$1/ojs/config.inc.php
PKPDBHOST=`cat $PKPCFG | grep ^host | cut -d "=" -f 2 | xargs`
PKPDB=`cat $PKPCFG | grep ^name | cut -d "=" -f 2 | xargs`
PKPUSER=`cat $PKPCFG | grep ^username | cut -d "=" -f 2 | xargs`
PKPPASS=`cat $PKPCFG | grep ^password | cut -d "=" -f 2 | xargs`
