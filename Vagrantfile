Vagrant.configure("2") do |config|
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true

  ### DB vm ####
  config.vm.define "db02" do |db02|
    db02.vm.box = "eurolinux-vagrant/centos-stream-9"
    db02.vm.box_version = "9.0.43"
    db02.vm.hostname = "db02"
    db02.vm.network "private_network", ip: "192.168.56.20"
    db02.vm.provision "shell", path: "db_setup.sh"
    db02.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.linked_clone = true
    end
  end

  ### Memcache vm ####
  config.vm.define "mc02" do |mc02|
    mc02.vm.box = "eurolinux-vagrant/centos-stream-9"
    mc02.vm.box_version = "9.0.43"
    mc02.vm.hostname = "mc02"
    mc02.vm.network "private_network", ip: "192.168.56.30"
    mc02.vm.provision "shell", path: "mc_script.sh"
    mc02.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.linked_clone = true
    end
  end

  ### RabbitMQ vm ####
  config.vm.define "rmq02" do |rmq02|
    rmq02.vm.box = "eurolinux-vagrant/centos-stream-9"
    rmq02.vm.box_version = "9.0.43"
    rmq02.vm.hostname = "rmq02"
    rmq02.vm.network "private_network", ip: "192.168.56.40"
	rmq02.vm.provision "shell", path: "rmq_script.sh"
    rmq02.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.linked_clone = true
    end
  end

  ### tomcat vm ###
  config.vm.define "app02" do |app02|
    app02.vm.box = "eurolinux-vagrant/centos-stream-9"
    app02.vm.box_version = "9.0.43"
    app02.vm.hostname = "app02"
    app02.vm.network "private_network", ip: "192.168.56.50"
	app02.vm.provision "shell", path: "tomcat_setup.sh"
    app02.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.linked_clone = true
    end
  end

  ### Nginx VM ###
  config.vm.define "web02" do |web02|
    web02.vm.box = "ubuntu/jammy64"
    web02.vm.hostname = "web02"
    web02.vm.network "private_network", ip: "192.168.56.60"
    web02.vm.provision "shell", path: "nginx_setup.sh"
    web02.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.memory = "1024"
      vb.linked_clone = true
    end
  end
end