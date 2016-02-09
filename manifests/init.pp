# == Class: lvmbackup
#
# Full description of class lvmbackup here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { lvmbackup:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2016 Your name here, unless otherwise noted.
#
define backup (
  $hour = 0,
  $minute = 0,
  $script = undef,
  $script_args = undef,
  $chsys_tools_path = '/opt/chillisys/bin/',
){
  file {"${chsys_tools_path}/${script}":
    ensure => file,
    source => "puppet:///modules/${module_name}/${script}",
    mode   => '0770',
    owner  => 'root',
  }->
  cron {"Backup script ${script}":
    ensure  => present,
    user    => root,
    hour    => $hour,
    minute  => $minute,
    command => "${chsys_tools_path}/${script} ${script_args}",
  }
}
