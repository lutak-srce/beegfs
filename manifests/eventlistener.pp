# Class: beegfs::hive
#
# This module manages BeeGFS Event Listener
#
class beegfs::eventlistener (
  $enable                = false,
  $file_event_log_target = '',
  $client_addr           = '',
  $update_port           = 9000,
  $bee_update_debug      = 0,
) inherits beegfs {
  file { '/etc/beegfs/beegfs-eventlistener.conf':
    require => Package['beegfs-utils'],
    content => template('beegfs/beegfs-eventlistener.conf.erb'),
  }

  if ( $enable ) {
    service { 'beegfs-eventlistener':
      ensure    => running,
      enable    => true,
      require   => [ Package['beegfs-utils'], File['/etc/beegfs/beegfs-eventlistener.conf'] ],
    }
  }
}
