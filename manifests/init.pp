# Class: beegfs
#
# Base BeeGFS class
#
class beegfs (
  $mgmtd_host = 'localhost',
  $meta_directory = '/meta',
  $storage_directory = '/storage',
  $mgmtd_directory = '/mgmtd',
  $client_auto_remove_mins = 0,
  $meta_space_low_limit = '5G',
  $meta_space_emergency_limit = '3G',
  $storage_space_low_limit = '100G',
  $storage_space_emergency_limit = '10G',
  $meta_inodes_low_limit = '10M',
  $meta_inodes_emergency_limit = '1M',
  $storage_inodes_low_limit = '10M',
  $storage_inodes_emergency_limit = '1M',
  $version = 'present',
  $major_version = '2015',
  $interfaces_file = '',
  $net_filter_file = '',
) {
  case $major_version {
    default: {
      require yum::repo::beegfs
    }
    '2015': {
      require yum::repo::beegfs
    }
  }

  package { 'beegfs-utils':
    ensure => $version,
  }
  file { '/etc/beegfs/beegfs-client.conf':
    require => Package['beegfs-utils'],
    content => template('beegfs/beegfs-client.conf.erb'),
  }
}
