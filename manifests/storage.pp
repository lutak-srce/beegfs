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
  $storage_template     = $beegfs::storage_template,
  $major_version        = $beegfs::major_version,
  $allow_first_run_init = true,
  $num_workers          = 16,
) inherits beegfs {
  package { 'beegfs-storage':
    ensure => $version,
  }
  file { '/etc/beegfs/beegfs-storage.conf':
    require => Package['beegfs-storage'],
    content => template($storage_template),
  }
  if $major_version == '7' {
    service { 'beegfs-storage':
      ensure    => running,
      enable    => $enable,
      require   => Package['beegfs-storage'],
      subscribe => File['/etc/beegfs/beegfs-storage.conf'],
    }
  } else {
    service { 'beegfs-storage':
      ensure    => running,
      enable    => $enable,
      provider  => redhat,
      require   => Package['beegfs-storage'],
      subscribe => File['/etc/beegfs/beegfs-storage.conf'],
    }
  }
}
