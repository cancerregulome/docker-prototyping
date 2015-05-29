#!/bin/bash
INVOKING_USER=$1
INPUT_FILE=$2
OUTPUT_DIR=$3

echo "systemsbiology.net" > /etc/defaultdomain
echo "rpcbind: 10.0.210.5" >> /etc/hosts.allow
echo "rpcbind: 10.0.210.6" >> /etc/hosts.allow
echo "+::::::" >> /etc/passwd
echo "+:::" >> /etc/group
echo "+::::::::" >> /etc/shadow
echo "domain systemsbiology.net server 10.0.210.5" >> /etc/yp.conf
echo "domain systemsbiology.net server 10.0.210.6" >> /etc/yp.conf
echo "/titan yp:auto.titan noacl,noatime,rsize=32768,wsize=32768,tcp,vers=3,hard,intr" >> /etc/auto.master
echo "NEED_IDMAPD=yes" >> /etc/default/nfs-common
echo "NEED_GSSD=no" >> /etc/default/nfs-common
sudo ypbind
sudo service rpcbind restart
sudo reload autofs
sudo service autofs restart
sleep 10
sudo ypcat -k auto.titan > /etc/auto.titan
echo "/titan /etc/auto.titan noacl,noatime,rsize=32768,wsize=32768,tcp,vers=3,hard,intr" > /etc/auto.master
sudo /etc/init.d/autofs stop
sudo /etc/init.d/autofs start

chown -R $INVOKING_USER /gidget

su -c "PYTHONPATH=/usr/local/lib/python2.7:/usr/local/lib/python3.4:/gidget/commands/maf_processing/python:/gidget/commands/maf_processing/python/archive:/gidget/commands/feature_matrix_construction/main:/gidget/commands/feature_matrix_construction/main/archive:/gidget/commands/feature_matrix_pipeline/utilpython /gidget/gidget/gidget_run_all.py --config=/gidget/config/gidget.config $INPUT_FILE $OUTPUT_DIR" $INVOKING_USER
