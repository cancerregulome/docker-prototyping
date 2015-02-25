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

REM The boot files root directory (i.e., the absolute path to the location on your local machine where you have the linux boot files)
SET bootfiles_dir=%home_dir%\Desktop\testing\centos6_boot_files

REM The directory functioning as a shared volume between VMs and the host 
SET vbox_share=%home_dir%\Desktop\testing\chef_setup_scripts

REM Location of the Linux Guest Additions iso file
SET guest_additions=C:\Program Files\Oracle\VirtualBox-old\VBoxGuestAdditions.iso