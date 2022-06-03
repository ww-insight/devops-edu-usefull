#!/bin/bash
VM_NAME=$1
VM_USER=$2
VM_PASS=$3

# Download debian.iso
if [ ! -f ./ubuntu-20.04.4-live-server-amd64.iso ]; then
    wget https://releases.ubuntu.com/20.04/ubuntu-20.04.4-live-server-amd64.iso
fi
#Create VM
VBoxManage createvm --name $VM_NAME --ostype "Other_64" --register --basefolder `pwd`
#Set memory and network
VBoxManage modifyvm $VM_NAME --ioapic on
VBoxManage modifyvm $VM_NAME --memory 2048 --vram 128 --cpus 2
VBoxManage modifyvm $VM_NAME --nic1 bridged
#Create Disk and connect Debian Iso
VBoxManage createhd --filename `pwd`/$VM_NAME/$VM_NAME_DISK.vdi --size 8000 --format VDI
VBoxManage storagectl $VM_NAME --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach $VM_NAME --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium  `pwd`/$VM_NAME/$VM_NAME_DISK.vdi
#VBoxManage storagectl $VM_NAME --name "IDE Controller" --add ide --controller PIIX4
#VBoxManage storageattach $VM_NAME --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium `pwd`/ubuntu-20.04.4-live-server-amd64.iso
#VBoxManage modifyvm $VM_NAME --boot1 dvd --boot2 disk --boot3 none --boot4 none
#Enable RDP
VBoxManage modifyvm $VM_NAME --vrde on
VBoxManage modifyvm $VM_NAME --vrdemulticon on --vrdeport 10001
#Install OS
VBoxManage unattended install $VM_NAME --iso=ubuntu-20.04.4-live-server-amd64.iso --user=$VM_USER --password=$VM_PASS
#Start the VM
#VBoxHeadless --startvm $VM_NAME
