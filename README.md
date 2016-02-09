# backup
Puppet module and scripts to create lvm backup and wrapper to do lvm backup of kvm lists.

All scripts are really simple, but were quite usefull for me so i guess could be source of inspiration for others :-D

# Puppet module

Includes puppet module to copy selected script and schedule a cron job.

Example : 

```
backup {'sys_backup':
  hour         => 21,
  minute       => 30,
  script       => 'lvm_backup.sh',
  script_args  => 'sys',
}->
  backup {'kvm_backup':
  hour   => 23,
  minute => 00,
  script => 'kvm_backup.sh',
}
```
# Scripts

You can find two of them 
- files/lvm_backup.sh
- files/kvm_backup.sh 

## lvm_backup.sh

This script is used to create backup of LVs. It will get list of LVs identified with prefix.
For example if you run ./lvm_backup.sh sys_  from LVs:
sys_home
sys_test
bigtest

only first two will be backed up.

At the beggining of sctipt you can declare basic variables - like volume group name, disk to mount as an backup disk and so on.

## kvm_backup.sh

Is only wrapper for lvm_backup.sh, it gets list of virtual machines from libvirt and runs lvm_backup.sh with prefixes to backup them.


