def get_redhat_beegfs_version
  version = Facter::Util::Resolution.exec('/bin/rpm -qa beegfs-utils')
  if match = /^beegfs-utils-(\d+\.\d+.*)$/.match(version)
    match[1]
  else
    nil
  end
end

Facter.add('beegfsversion') do
  setcode do
    case Facter.value('osfamily')
      when 'RedHat'
        get_redhat_beegfs_version()
      else
        nil
    end
  end
end
