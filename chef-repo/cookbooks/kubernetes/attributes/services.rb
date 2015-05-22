# Service attributes

# Zookeeper service attributes
default["kubernetes"]["services"]["zookeeper"]["v1beta3"]["metadata_name"] = "zookeeper-services"
default["kubernetes"]["services"]["zookeeper"]["v1beta3"]["metadata_label_name"] = "zookeeper-services"
default["kubernetes"]["services"]["zookeeper"]["v1beta3"]["service_ports"] = [ { "port": 2181 , "targetPort": 2181, "protocol": "TCP" }, { "port": 2888, "targetPort": 2888, "protocol": "TCP" }, { "port": 3888, "targetPort": 3888, "protocol": "TCP" } ]

