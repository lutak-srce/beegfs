# Define: beegfs::client
#
# This module manages BeeGFS client
#
define beegfs::mount ($cfg, $mnt, $cfg_source, $netfilter = '', $netfilter_source = '', $version = '') {
  include beegfs::client

  if $netfilter != '' and $netfilter_source != '' {
    if $::rdma != true {
      $netfilter_source_path = $netfilter_source
    } else {
      $netfilter_source_path = "${netfilter_source}-rdma"
    }
    file { "/etc/beegfs/${netfilter}":
      ensure  => file,
      owner   => root,
      group   => root,
      mode    => '0644',
      require => Package['beegfs-client'],
      source  => $netfilter_source_path,
    }
  }

  file { $mnt:
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0755',
  }
  file { "/etc/beegfs/${cfg}":
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    require => Package['beegfs-client'],
    source  => $cfg_source,
  }
}
