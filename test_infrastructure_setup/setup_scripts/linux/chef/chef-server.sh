# Usage: chef-server.sh params_file

# source the parameter file
source $1

read -s -p "Enter the root password for the chef server: " $password

# Run the setup script on the Chef server and reboot
./chef-server-ssh.sh $password $user $fullname $email $orgshort $orglong $chef_server $fqdn $pass

