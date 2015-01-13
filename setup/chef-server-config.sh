# Usage: chef-server-config.sh user fullname email pass orgshort orglong

user=$1
fullname=$2
email=$3
pass=$4
orgshort=$5
orglong=$6

chef-server-ctl user-create $user $fullname $email $pass --filename ~/$user.pem
chef-server-ctl org-create $orgshort $orglong --association-user $user --filename ~/$orgshort-validator.pem
chef-server-ctl reconfigure