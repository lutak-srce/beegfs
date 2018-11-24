# Class: beegfs::client
#
# This module manages BeeGFS client
#
class beegfs::admon (
  $enable               = true,
  $mgmtd_host           = $beegfs::mgmtd_host,
  $version              = $beegfs::version,
  $net_filter_file      = $beegfs::net_filter_file,
  $http_port            = '8000',
) inherits beegfs {
  package { 'beegfs-admon':
    ensure => $version,
  }
  file { '/etc/beegfs/beegfs-admon.conf':
    require => Package['beegfs-admon'],
    content => template('beegfs/beegfs-admon.conf.erb'),
  }
  service { 'beegfs-admon':
    ensure    => running,
    enable    => $enable,
    require   => Package['beegfs-admon'],
    subscribe => File['/etc/beegfs/beegfs-admon.conf'];
  }
}
