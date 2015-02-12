#!/usr/bin/expect -f

set password [lindex $argv 0]
set user [lindex $argv 1]
set fullname [lindex $argv 2]
set email [lindex $argv 3]
set orgshort [lindex $argv 4]
set orglong [lindex $argv 5]
set chef_server [lindex $argv 6]
set fqdn [lindex $argv 7]
set pass [lindex $argv 8]

spawn ssh root@$chef_server \"bash -s\" -- \< ./chef-server-setup.sh $hostname $fqdn $user $fullname $email $pass $orgshort $orglong

expect "root@$chef_server's password: "

send $password

