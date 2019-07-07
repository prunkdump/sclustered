Facter.add(:room) do
   setcode do
      hostname = Facter.value(:hostname)
      hostname.split(/-?\d+$/)[0]
   end
end
