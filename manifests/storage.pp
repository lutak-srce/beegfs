# Class: beegfs::client
#
# This module manages BeeGFS client
#
class beegfs::storage (
  $enable               = true,
  $storage_directory    = $beegfs::storage_directory,
  $mgmtd_host           = $beegfs::mgmtd_host,
  $version              = $beegfs::version,
  $interfaces_file      = $beegfs::interfaces_file,
  $net_filter_file      = $beegfs::net_filter_file,
  $allow_first_run_init = true,
  $num_workers          = 16,
) inherits beegfs {
  package { 'beegfs-storage':
    ensure => $version,
  }
  file { '/etc/beegfs/beegfs-storage.conf':
    require => Package['beegfs-storage'],
    content => template('beegfs/beegfs-storage.conf.erb'),
  }
  service { 'beegfs-storage':
    ensure    => running,
    enable    => $enable,
    provider  => redhat,
    require   => Package['beegfs-storage'],
    subscribe => File['/etc/beegfs/beegfs-storage.conf'];
  }
}
