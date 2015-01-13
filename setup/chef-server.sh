# Usage: chef-server.sh params_file

# Assumptions:
# 1) Network configuration is done.
# 2) Passwordless ssh to root@chef-server works.

# source the parameter file
source $1

# Run the setup script on the Chef server and reboot
ssh root@$hostname "bash -s" -- < ./chef-server-setup.sh $hostname $fqdn
ssh root@$hostname "bash -s" -- < ./sbin/reboot
sleep 180

# Run the configuration script on the Chef server
ssh root@$hostname "bash -s" -- < ./chef-server-config.sh $user $fullname $email $pass $orgshort $orglong