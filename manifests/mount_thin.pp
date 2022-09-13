# Define: beegfs::mount_thin
#
# This module manages BeeGFS mount
#
define beegfs::mount_thin ($cfg, $mnt, $cfg_source, $authn) {
  file { $mnt:
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0755',
  }
  if ( $authn ) {
    file { "/etc/beegfs/connauthfile-${title}":
      ensure  => file,
      owner   => root,
      group   => root,
      mode    => '0600',
      content => $authn,
    }
  }
  file { "/etc/beegfs/${cfg}":
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    source  => $cfg_source,
  }
  mount { $mnt:
    ensure  => mounted,
    atboot  => true,
    device  => 'beegfs_nodev',
    fstype  => 'beegfs',
    options => "rw,relatime,cfgFile=/etc/beegfs/${cfg},_netdev",
    dump    => 0,
    pass    => 0,
    require => [ File[$mnt], File["/etc/beegfs/${cfg}"] ],
  }
}
