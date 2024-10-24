# Class: beegfs::hive
#
# This module manages BeeGFS Hive Index
#
class beegfs::hive (
  $enable     = false,
  $threads    = 2,
  $index_path = '',
  $mount_path = '',
  $port       = 9000,
  $debug      = 0,
  
) inherits beegfs {
  include yum::repo::beegfs::hive

  package { 'beegfs-hive-index':
    ensure => $version,
  }

  if ( $index_path != '' ) {
    $index_paths = "${mount_path}:${index_path}"
    $idx_path = $index_path
  } else {
    $index_paths = $mount_path
    $idx_path = $mount_path
  }

  file { '/etc/beegfs/index/config':
    require => Package['beegfs-hive-index'],
    content => template('beegfs/beegfs-hive-config.erb'),
  }

  if ( $enable ) {
    file { '/etc/beegfs/index/updateEnv.conf':
      require => Package['beegfs-hive-index'],
      content => template('beegfs/beegfs-hive-updateEnv.conf.erb'),
    }
      
    service { 'bee-update':
      ensure    => running,
      enable    => true,
      require   => [ Package['beegfs-hive-index'], File['/etc/beegfs/index/updateEnv.conf'] ],
    }
  }
}
