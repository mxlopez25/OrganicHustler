Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.hostname = "organic-backend"

  config.vm.provision "shell", path: "provision.sh"
  # Port Fowarding
  #config.vm.network "forwarded_port", guest: 3000, host: 3100, id:"organic"
  # Private IP
  config.vm.network "private_network", ip: "192.168.100.11"
end
