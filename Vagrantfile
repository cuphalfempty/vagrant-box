# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "puppetlabs/debian-8.2-64-puppet"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  config.vm.synced_folder "../build", "/var/www/html", owner: "www-data", group: "www-data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "file", source: "~/.gitconfig", destination: ".gitconfig"
  config.vm.provision "file", source: "~/.vimrc", destination: ".vimrc"
  # http://stackoverflow.com/questions/30075461/how-do-i-add-my-own-public-key-to-vagrant-vm
  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: ".ssh/me.pub"
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password root'
    sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password root'
    sudo apt-get install -y mysql-server-5.5 mysql-client-5.5
    sudo service mysql start
    mysql -uroot -proot -e "create database if not exists app_db"
    mysql -uvagrant -pvagrant app_db -e "show tables" &> /dev/null || mysql -uroot -proot -e "grant all on app_db.* to vagrant@localhost identified by 'vagrant'"
    echo -e "[client]\nuser=root\npassword=root\n" > /home/vagrant/.my.cnf
    sudo apt-get install -y postgresql-9.4 postgresql-client-9.4
    sudo -u postgres psql -c "CREATE USER vagrant WITH PASSWORD 'vagrant';"
    sudo -u postgres createdb -O vagrant app_db
    sudo apt-get install -y php5 php5-cli php5-mysql php5-pgsql php5-curl php5-gd php5-apcu
    sudo php5enmod apcu gd
    grep apc.rfc1867 /etc/php5/apache2/php.ini &> /dev/null || sudo sh -c "echo -e '\n;APC configuration\napc.rfc1867 = 1' >> /etc/php5/apache2/php.ini"
    sudo apt-get install -y apache2 libapache2-mod-php5
    sudo a2enmod rewrite
    sudo cp /vagrant/files/etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/
    sudo a2ensite 000-default
    sudo service apache2 restart
    sudo apt-get install -y git tree vim
    sudo cat /home/vagrant/.ssh/me.pub >> /home/vagrant/.ssh/authorized_keys
  SHELL

  # Fixes issues when box fails on initiating network:
  # ==> php7: Configuring and enabling network interfaces...
  # or
  #     php7: SSH auth method: private key
  # http://askubuntu.com/questions/760871/network-settings-fail-for-ubuntu-xenial64-vagrant-box
  config.vm.provider "virtualbox" do |vb|
    vb.customize ['modifyvm', :id, '--cableconnected1', 'on']
  end

  # multi-box config
  config.vm.define "php5", primary: true do |php5|
  end
  config.vm.define "php7", autostart: false do |php7|
    php7.vm.box = "kaorimatz/ubuntu-16.04-amd64"
    php7.vm.network "private_network", ip: "192.168.33.20"
  end
end
