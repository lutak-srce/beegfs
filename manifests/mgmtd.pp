# Class: beegfs::client
#
# This module manages BeeGFS client
#
class beegfs::mgmtd (
  $enable                         = true,
  $mgmtd_directory                = $beegfs::mgmtd_directory,
  $client_auto_remove_mins        = $beegfs::client_auto_remove_mins,
  $meta_space_low_limit           = $beegfs::meta_space_low_limit,
  $meta_space_emergency_limit     = $beegfs::meta_space_emergency_limit,
  $storage_space_low_limit        = $beegfs::storage_space_low_limit,
  $storage_space_emergency_limit  = $beegfs::storage_space_emergency_limit,
  $meta_inodes_low_limit          = $beegfs::meta_inodes_low_limit,
  $meta_inodes_emergency_limit    = $beegfs::meta_inodes_emergency_limit,
  $storage_inodes_low_limit       = $beegfs::storage_inodes_low_limit,
  $storage_inodes_emergency_limit = $beegfs::storage_inodes_emergency_limit,
  $mgmtd_template                 = $beegfs::mgmtd_template,
  $major_version        = $beegfs::major_version,
  $version                        = $beegfs::version,
  $interfaces_file                = $beegfs::interfaces_file,
  $net_filter_file                = $beegfs::net_filter_file,
  $allow_first_run_init           = true,
  $allow_new_servers              = true,
) inherits beegfs {
  package { 'beegfs-mgmtd':
    ensure => $version,
  }
  file { '/etc/beegfs/beegfs-mgmtd.conf':
    require => Package['beegfs-mgmtd'],
    content => template($mgmtd_template),
  }
  if $major_version == '7' {
    service { 'beegfs-mgmtd':
      ensure    => running,
      enable    => $enable,
      require   => Package['beegfs-mgmtd'],
      subscribe => File['/etc/beegfs/beegfs-mgmtd.conf'];
    }
  } else {
    service { 'beegfs-mgmtd':
      ensure    => running,
      enable    => $enable,
      provider  => redhat,
      require   => Package['beegfs-mgmtd'],
      subscribe => File['/etc/beegfs/beegfs-mgmtd.conf'];
    }
  }
}
