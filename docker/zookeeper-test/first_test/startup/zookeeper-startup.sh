#!/bin/bash

max_zookeepers=$1
current_zookeepers=`grep server $ZOOKEEPER_CONF/zoo.cfg | wc -l`

while true; do
	if [[ $current_zookeepers == $max_zookeepers ]]; then
		java -cp $ZOOKEEPER_HOME/zookeeper.jar:$ZOOKEEPER_HOME/lib/slf4j-api-1.7.5.jar:$ZOOKEEPER_HOME/lib/slf4j-log4j12-1.7.5.jar:$ZOOKEEPER_HOME/lib/log4j-1.2.16.jar:$ZOOKEEPER_CONF/conf org.apache.zookeeper.server.quorum.QuorumPeerMain $ZOOKEEPER_CONF/zoo.cfg
	fi
done
