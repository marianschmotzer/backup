#!/bin/bash

LVMBACKUPPATH='/home/smoco/'

for i in `virsh -q list --name`;do 
  $LVMBACKUPPATH/lvm_backup.sh $i
done
