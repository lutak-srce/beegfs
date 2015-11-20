# Class: beegfs::client
#
# This module manages BeeGFS client
#
class beegfs::meta (
  $enable               = true,
  $meta_directory       = $beegfs::meta_directory,
  $mgmtd_host           = $beegfs::mgmtd_host,
  $version              = $beegfs::version,
  $interfaces_file      = $beegfs::interfaces_file,
  $net_filter_file      = $beegfs::net_filter_file,
  $allow_first_run_init = true,
  $num_workers          = 0,
) inherits beegfs {
  package { 'beegfs-meta':
    ensure => $version,
  }
  file { '/etc/beegfs/beegfs-meta.conf':
    require => Package['beegfs-meta'],
    content => template('beegfs/beegfs-meta.conf.erb'),
  }
  service { 'beegfs-meta':
    ensure    => running,
    enable    => $enable,
    provider  => redhat,
    require   => Package['beegfs-meta'],
    subscribe => File['/etc/beegfs/beegfs-meta.conf'];
  }
}
