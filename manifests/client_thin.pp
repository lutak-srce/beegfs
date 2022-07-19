#
# = Class: beegfs::client_thin
#
# This module manages BeeGFS thin client. Sets mounts
# without installing beegfs-client and beegfs-helpers.
# Mountpoints are defined with beegfs::mount_thin resource.
#

class beegfs::client_thin (
  $kernel_module       = "puppet:///modules/beegfs/${::kernelrelease}/${::beegfsversion}/${rdma_path}/beegfs.ko",
  $default_client_conf = false,
  $beegfs_mount_hash,
) {
  file { [ "/lib/modules/${::kernelrelease}/updates/fs", "/lib/modules/${::kernelrelease}/updates/fs/beegfs_autobuild", '/etc/beegfs' ]:
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0755',
  }

  file { "/lib/modules/${::kernelrelease}/updates/fs/beegfs_autobuild/beegfs.ko":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    source  => $kernel_module,
    require => [ File["/lib/modules/${::kernelrelease}/updates/fs/beegfs_autobuild"] ],
    notify  => Exec['load_module'],
  }

  exec { 'load_module':
    command     => '/sbin/depmod -a',
    path        => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
    require     => [ File["/lib/modules/${::kernelrelease}/updates/fs/beegfs_autobuild/beegfs.ko"] ],
    refreshonly => true,
  }

  kmod::load { 'beegfs': 
    require => [ Exec['load_module'] ],
  }  

  if $default_client_conf {
    file { '/etc/beegfs/beegfs-client.conf':
      require => File['/etc/beegfs'],
      content => template('beegfs/beegfs-client.conf.erb'),
    }
  }

  if $beegfs_mount_hash {
    $defaults = {
      require => [ Kmod::Load['beegfs'], File['/etc/beegfs'] ],
    }
    create_resources('beegfs::mount_thin', $beegfs_mount_hash, $defaults)
  }
}
