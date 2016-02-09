#!/bin/bash
export PATH='/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/opt/bin'
VGNAME='vg00'
LVPREFIXES="$1"
LVIGNORE="swap"
LVLISTRAW=`lvs  --noheadings $VGNAME`

BACKUPMOUNT='/mnt/backup'
BACKUPDIR="$BACKUPMOUNT/$1-`date +%a`"
BACKUPDIRPREPARE="grep -q $BACKUPMOUNT /proc/mounts || mount /dev/mapper/backup $BACKUPMOUNT"

function output
{
	logger -t backup $1
}

$( $BACKUPDIRPREPARE )
if [ $? -ne 0 ];then
	output "$BACKUPDIRPREPARE not sucessfull"
	exit -1
fi

for i in $LVPREFIXES ; do
	for a in $LVLISTRAW ;do
		LVNAME=`echo $a|egrep "^$i.*"|egrep -v "$LVIGNORE"`
		if [ -n "$LVNAME" ];then
			mkdir $BACKUPDIR
			output "Creating snapshot backup_$LVNAME"
			lvcreate -L +1G -s -n backup_$LVNAME /dev/$VGNAME/$LVNAME
			if [ $? -ne 0 ];then
				output "snapshot backup_$LVNAME cannot be created"
				exit -1
			fi
			output "Coping data from backup_$LVNAME to $BACKUPDIR"
			dd if=/dev/$VGNAME/backup_$LVNAME of=$BACKUPDIR/$LVNAME
			if [ $? -ne 0 ];then
				output "Data from backup_$LVNAME cannot be copied"
				exit -1
			fi
			output "Removing snapshot backup_$LVNAME"
			lvremove -f /dev/$VGNAME/backup_$LVNAME
			if [ $? -ne 0 ];then
				output "snapshot backup_$LVNAME cannot be removed"
				exit -1
			fi
		fi
	done
done
