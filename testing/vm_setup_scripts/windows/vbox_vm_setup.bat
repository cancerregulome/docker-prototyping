REM Using VirtualBox 4.3.18 (PXE booting is broken in 4.3.22)

REm chef_server_create () {
	REM Import the cluster base image for the chef server and nodes, add a shared folder containing server setup scripts, and configure the servers
	REM VBoxManage import $iso_dir/$cluster_base.ova --vsys 0 --vmname "Chef Server Centos"
	REM VBoxManage sharedfolder add "Chef Server Centos" --name "vm_setup_scripts" --hostpath $vbox_share --transient --automount
	REM VBoxManage startvm "Chef Server Centos" --type headless
	REM VBoxManage guestcontrol execute --image /media/sf_vm_setup_scripts/fix_networking.sh
	REM VBoxManage guestcontrol execute --image /media/sf_vm_setup_scripts/chef_server.sh
	REM May need to wait before the poweroff?
	REM VBoxManage controlvm "Chef Server Centos" poweroff
REM }

REM chef_node_create () {
	REM node_name=ChefNode$1
	REM VBoxManage import $iso_dir/$cluster_base.ova --vsys 0 --vmname $node_name
	REM VBoxManage sharedfolder add $node_name --name "vm_setup_scripts" --hostpath $vbox_share --transient --automount
	REM VBoxManage startvm $node_name --type headless
	REM VBoxManage guestcontrol $node_name execute --image /media/sf_vm_setup_scripts/fix_networking.sh
	REM VBoxManage guestcontrol $node_name execute --image /media/sf_vm_setup_scripts/fix_hosts_file.sh
	REM VBoxManage controlvm $node_name poweroff
REM }

REM If VirtualBox isn't installed, install it
REM verify_virtualbox

REM If Apache isn't installed, install it
REM verify_apache

REM Setup the environment


SET home_dir=C:\Users\Abby

REM The network location of the kickstart file
SET kickstart=http://lime.systemsbiology.net:8888/anaconda-ks.cfg

REM The directory where all of your ISO files live
SET iso_dir=%home_dir%\Desktop\ISB

REM The name of the .ova image file to import
SET cluster_base=ClusterBase

REM The directory where VirtualBox stores vms, by default
SET vbox_vm_dir=%home_dir%\VirtualBox VMs

REM The VirtualBox TFTP directory (you probably won't need to change this)
SET vbox_tftp_dir=%home_dir%\.VirtualBox\TFTP

REM The test infrastructure setup root directory (i.e., the absolute path to the location on your local machine where you have copied the test_infrastructure_setup directory)
SET setup_dir=%home_dir%\Desktop\test_infrastructure_setup

REM The directory functioning as a shared volume between VMs and the host 
SET vbox_share=%home_dir%\Desktop\test_infrastructure_setup\setup_scripts

REM Location of the Linux Guest Additions iso file
SET guest_additions=C:\Program Files\Oracle\VirtualBox-old\VBoxGuestAdditions.iso

:BaseImagePrompt
REM Ask the user if they want to create a new base image to clone from
SET /P yn="Would you like to create a new VirtualBox base image to clone from? [Y|N] "
IF "%yn%" == "Y" IF "%yn%" == "y" (
	GOTO BaseImageSelect
) ELSE (
	IF "%yn%" == "N" IF "%yn%" == "n" (
		GOTO NetworkPrompt
	) ELSE (
		ECHO That wasn't a valid choice.
		GOTO BaseImagePrompt
	)
)  

:BaseImageSelect
REM Ask the user which base image they want to create
ECHO "Which base image would you like to create?"
ECHO "	[1] Centos6.6"
SET /P base_image="Enter a number: "

IF "%base_image%" == "1" (
	GOTO Centos6BaseCreate
) ELSE (
	ECHO "That wasn't a valid choice."
	GOTO BaseImageSelect
)


:NetworkPrompt
REM Ask the user if they want to create a new network for the VMs
SET /P yn="Would you like to create a new local network for your Virtualbox cluster? [Y/N] "
IF "%yn%" == "Y" || "%yn%" == "y" (
	GOTO NetworkCreate
) ELSE (
	IF "%yn% == "N" || "%yn%" == "n" (
		GOTO ChefServerPrompt
	) ELSE (
		ECHO That wasn't a valid choice.
		GOTO NetworkPrompt
	)
)

:NetworkCreate
REM Create the network
VBoxManage natnetwork add --netname NatNetwork --network 10.0.2.0/24 --enable --dhcp on
VBoxManage hostonlyif ipconfig vboxnet0 --dhcp create
VBoxManage dhcpserver add --netname NatNetwork --ifname vboxnet0 --ip 192.168.56.100 --netmask 255.255.255.0 --lowerip 192.168.56.101 --upperip 192.168.56.254 --enable

:Centos6BaseCreate
REM Create the necessary directories and boot files 
IF NOT EXIST %vbox_tftp_dir%\images\RHEL\x86_64\6.6 (
	MKDIR %vbox_tftp_dir%\images\RHEL\x86_64\6.6
)
echo %setup_dir%

COPY %setup_dir%\centos6_boot_files\initrd.img %vbox_tftp_dir%\images\RHEL\x86_64\6.6
COPY %setup_dir%\centos6_boot_files\vmlinuz %vbox_tftp_dir%\images\RHEL\x86_64\6.6

IF NOT EXIST %vbox_tftp_dir%\pxelinux.cfg (
	MD %vbox_tftp_dir%\pxelinux.cfg
)

COPY %setup_dir%\centos6_boot_files\pxelinux.0 %vbox_tftp_dir%

ECHO DEFAULT centos6.6 > %vbox_tftp_dir%\pxelinux.cfg\default
ECHO LABEL centos6.6 >> %vbox_tftp_dir%\pxelinux.cfg\default
ECHO KERNEL images\RHEL\x86_64\6.6\vmlinuz  >> %vbox_tftp_dir%\pxelinux.cfg\default
ECHO APPEND initrd=images\RHEL\x86_64\6.6\initrd.img ks=%kickstart% ksdevice=eth0 >> %vbox_tftp_dir%\pxelinux.cfg\default

REM Create the centos6 base vm
VBoxManage createvm --name %cluster_base% --ostype "RedHat_64" --register
REM Add network interfaces and memory
VBoxManage modifyvm %cluster_base% --memory 2048 --vram 12
VBoxManage modifyvm %cluster_base% --nic1 nat --nic2 hostonly --hostonlyadapter2 "VirtualBox Host-Only Ethernet Adapter"
REM Create a hard drive
VBoxManage createhd --filename %cluster_base%.vdi --size 20000
REM Create and attach storage devices and Linux Guest Additions
VBoxManage storagectl %cluster_base% --name IDE --add ide 
VBoxManage storageattach %cluster_base% --storagectl IDE --port 0 --device 0 --type dvddrive --medium %iso_dir%\CentOS-6.6-x86_64-minimal.iso
VBoxManage storageattach %cluster_base% --storagectl IDE --port 1 --device 1 --type dvddrive --medium %iso_dir%\VBoxGuestAdditions.iso
VBoxManage storagectl %cluster_base% --name SATA --add sata 
VBoxManage storageattach %cluster_base% --storagectl SATA --port 1 --device 0 --type hdd --medium %cluster_base%.vdi
REM Modify the boot order
VBoxManage modifyvm %cluster_base% --boot1 disk --boot2 net --boot3 none --boot4 none
REM Start the VM
VBoxManage startvm %cluster_base%

REM Install guest additions



:ChefServerPrompt
REM Ask the user if they want to create a new chef server
REM read -p "Would you like to create a new chef server? [Y/N] " yn

REM while true; do
	REM case $yn in
		REM Y|y)
			REM chef_server_create;;
		REM N|n)
			REM break;;
		REM *)
	REM esac
REM done

:ChefNodePrompt
REM read -p "How many chef nodes would you like to create? " node_num

REM if [[ -z "$node_num" ]]; then
	REM read -p "Please enter a number of nodes greater or equal to zero: " node_num
REM else
	REM count=0

	REM while [[ $count < $node_num ]]; do
		REM chef_node_create $node_num
		REM ((count += 1))
	REM done
REM fi










