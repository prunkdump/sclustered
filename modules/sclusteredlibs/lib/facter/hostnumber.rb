Facter.add(:hostnumber) do
   setcode do
      hostname = Facter.value(:hostname)
      hostname.scan(/\d+$/)[0]
   end
end
