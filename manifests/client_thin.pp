#
# = Class: beegfs::client_thin
#
# This module manages BeeGFS thin client. Sets mounts
# without installing beegfs-client and beegfs-helpers.
# Mountpoints are defined with beegfs::mount_thin resource.
#

class beegfs::client_thin (
  $kernel_module     = "puppet:///modules/beegfs/${::kernelrelease}/${::beegfsversion}/${rdma_path}/beegfs.ko",
  $beegfs_mount_hash,
) inherits beegfs {
  file { [ "/lib/modules/${::kernelrelease}/updates/fs", "/lib/modules/${::kernelrelease}/updates/fs/beegfs_autobuild" ]:
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0755',
  }

  file { "/lib/modules/${::kernelrelease}/updates/fs/beegfs_autobuild/beegfs.ko":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    source  => $kernel_module,
    require => [ File["/lib/modules/${::kernelrelease}/updates/fs/beegfs_autobuild"] ],
  }

  exec { 'load_module':
    command => "/sbin/depmod -a && touch /etc/beegfs/depmod_${::kernelrelease}_${::beegfsversion}",
    path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
    creates => "/etc/beegfs/depmod_${::kernelrelease}_${::beegfsversion}",
    require => [ File["/lib/modules/${::kernelrelease}/updates/fs/beegfs_autobuild/beegfs.ko"] ],
  }

  kmod::load { 'beegfs': }

  if $beegfs_mount_hash {
    create_resources('beegfs::mount_thin', $beegfs_mount_hash)
  }
}
