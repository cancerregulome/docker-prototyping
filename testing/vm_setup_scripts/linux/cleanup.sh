#!/bin/bash

VBoxManage unregistervm "chef-server" --delete
#VBoxManage unregistervm "Chef Server Centos" --delete

rm /Users/ahahn/Desktop/Chef_Cluster/chef-server.ova
