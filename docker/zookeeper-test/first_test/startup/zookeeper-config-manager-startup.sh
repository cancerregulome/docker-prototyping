#!/bin/bash

max_zookeepers=$1
current_zookeepers=`grep server $ZOOKEEPER_CONF/zoo.cfg | wc -l`

while true; do
	if [[ $current_zookeepers < $max_zookeepers ]]; then
		if [[ !`grep $HOSTNAME $ZOOKEEPER_CONF/zoo.cfg` ]]; then
			((current_zookeepers += 1))
			if [[ `grep server.$current_zookeepers $ZOOKEEPER_CONF/zoo.cfg` ]]; then
				sed -i "/server.$current_zookeepers/ s/.*/server.$zookeepers=$HOSTNAME:2888:3888" $ZOOKEEPER_CONF/zoo.cfg
			else
				echo "server.$zookeepers=$HOSTNAME:2888:3888" >> $ZOOKEEPER_CONF/zoo.cfg
				echo $current_zookeepers > $ZOOKEEPER_DATA_DIR/myid
			fi
		fi 
		
	elif [[ $current_zookeepers > $max_zookeepers ]]; then
		for server in `grep server $ZOOKEEPER_CONF/zoo.cfg | sort -r`; do 
			if [[ $current_zookeepers > $max_zookeepers ]]; then
				sed -i "/$server/ s/.*//" $ZOOKEEPER_CONF/zoo.cfg
				(($current_zookeepers -= 1))
			else
				break	
			fi
		done
	current_zookeepers=`grep server $ZOOKEEPER_CONF/zoo.cfg | wc -l`
done




