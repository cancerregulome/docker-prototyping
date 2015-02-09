#!/usr/bin/expect -f

set chef_user [lindex $argv 0]
set node_num [lindex $argv 1]
set host [lindex $argv 2]
set password [lindex $argv 3]

spawn knife bootstrap --sudo --ssh-user $chef_user --no-host-key-verify -r \'recipe\[solrcloud\], recipe\[solrcloud::build_containers\], recipe\[solrcloud::run_containers\]\' -j \'\{\"node_id\":\"$node_num\"\}\' $host
expect "Enter your password: "
send "$password\r"
interact 
