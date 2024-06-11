Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2204"
  config.vm.hostname = "test-vm"
  config.vm.network "public_network", bridge: "wlo1"
  config.vm.provider "virtualbox" do |deb|
    deb.customize ["modifyvm", :id, "--ioapic", "on"]
    deb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    deb.name = "dummy-node"
    deb.memory = 1024
    deb.cpus = 1
  end
  config.vm.synced_folder "./in_sync", "/home/vagrant/in_sync"
end