#!/bin/bash
max_zookeepers=$1
current_zookeepers=`grep server $ZOOKEEPER_CONF/zoo.cfg | wc -l`

if [[ !`grep $HOSTNAME $ZOOKEEPER_CONF/zoo.cfg` ]]; then
	((current_zookeepers += 1))
	if [[ `grep server.$current_zookeepers $ZOOKEEPER_CONF/zoo.cfg` ]]; then
		sed -i "/server.$current_zookeepers/ s/.*/server.$zookeepers=$HOSTNAME:2888:3888" $ZOOKEEPER_CONF/zoo.cfg
	else
		echo "server.$zookeepers=$HOSTNAME:2888:3888" >> $ZOOKEEPER_CONF/zoo.cfg
		echo $current_zookeepers > $ZOOKEEPER_DATA_DIR/myid
	fi
fi

while true; do
	if [[ $current_zookeepers == $max_zookeepers ]]; then
		java -cp $ZOOKEEPER_HOME/zookeeper.jar:$ZOOKEEPER_HOME/lib/slf4j-api-1.7.5.jar:$ZOOKEEPER_HOME/lib/slf4j-log4j12-1.7.5.jar:$ZOOKEEPER_HOME/lib/log4j-1.2.16.jar:$ZOOKEEPER_CONF/conf org.apache.zookeeper.server.quorum.QuorumPeerMain $ZOOKEEPER_CONF/zoo.cfg
	else
		current_zookeepers=`grep server $ZOOKEEPER_CONF/zoo.cfg | wc -l`
	fi
done
