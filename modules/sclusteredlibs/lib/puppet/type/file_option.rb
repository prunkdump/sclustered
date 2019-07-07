Puppet::Type.newtype(:file_option) do

  desc <<-EOT
    Ensures that a given line is contained within a file.  The implementation
    matches the full line, including whitespace at the beginning and end.  If
    the line is not contained in the given file, Puppet will add the line to
    ensure the desired state.  Multiple resources may be declared to manage
    multiple lines in the same file.

    Example:

        file_line { 'sudo_rule':
          path => '/etc/sudoers',
          line => '%sudo ALL=(ALL) ALL',
        }
        file_line { 'sudo_rule_nopw':
          path => '/etc/sudoers',
          line => '%sudonopw ALL=(ALL) NOPASSWD: ALL',
        }

    In this example, Puppet will ensure both of the specified lines are
    contained in the file /etc/sudoers.

    **Autorequires:** If Puppet is managing the file that will contain the line
    being managed, the file_line resource will autorequire that file.

  EOT

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, :namevar => true) do
    desc 'An arbitrary name used as the identity of the resource.'
  end

  newparam(:multiple) do
    desc 'An optional value to determine if match can change multiple lines.'
    newvalues(true, false)
  end

  newparam(:after) do
    desc 'An optional value used to specify the line after which we will add any new lines. (Existing lines are added in place)'
  end

  newparam(:option) do
    desc 'The line to be appended to the file located by the path parameter.'
  end

  newparam(:value) do
    desc 'The value of the option.'
  end

  newparam(:separator) do
    desc 'the separator.'
    defaultto ' = '
  end

  newparam(:path) do
    desc 'The file Puppet will ensure contains the line specified by the line parameter.'
    validate do |value|
      unless (Puppet.features.posix? and value =~ /^\//) or (Puppet.features.microsoft_windows? and (value =~ /^.:\// or value =~ /^\/\/[^\/]+\/[^\/]+/))
        raise(Puppet::Error, "File paths must be fully qualified, not '#{value}'")
      end
    end
  end

  # Autorequire the file resource if it's being managed
  autorequire(:file) do
    self[:path]
  end

  validate do
    unless self[:option] and self[:value] and self[:path]
      raise(Puppet::Error, "Both option, value and path are required attributes")
    end
  end
end
