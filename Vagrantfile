Vagrant.configure("2") do |config|
  config.vm.box = "freebsd/FreeBSD-13.0-STABLE"
  config.vm.provider "virtualbox" do |vb, override|
    vb.memory = "1024"
    override.vm.network "forwarded_port", guest: 80, host: 8999
  end
  config.vm.provision "shell", path: "provision.sh"
  config.vbguest.auto_update = false
end

