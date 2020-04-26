# frozen_string_literal: true

# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure('2') do |config|
  config.vm.box = 'fedora/31-cloud-base'

  MEMORY = 4048
  CPUS = 4

  config.vm.provider :virtualbox do |v|
    v.gui = true if ENV['GUI_TEST']

    v.memory = MEMORY
    v.cpus = CPUS
  end

  config.vm.provider :libvirt do |libvirt|
    libvirt.driver = 'kvm'
    libvirt.cpu_mode = 'host-passthrough'

    libvirt.memory = MEMORY
    libvirt.cpus = CPUS
  end

  if ENV['GUI_TEST']
    config.vm.provision 'shell', inline: 'sudo dnf groupinstall -y "Cinnamon Desktop" && sudo systemctl set-default graphical'
  end

  # dnf cache
  config.vm.provision 'shell', inline: 'echo "keepcache=1" | sudo tee -a /etc/dnf/dnf.conf'
  Dir.mkdir('.dnf-cache') unless File.exist?('.dnf-cache')
  config.vm.synced_folder '.dnf-cache', '/var/cache/dnf', type: 'sshfs' # need sshfs to be bidirectional

  config.vm.synced_folder '~/fedora_kd', '/home/vagrant/fedora_kd'

  config.vm.provision 'shell', inline: '/bin/sh /home/vagrant/fedora_kd/setup_deps.sh'

  config.vm.provision 'ansible_local' do |ansible|
    ansible.become = true
    ansible.limit = 'all,localhost'
    ansible.playbook = 'setup.yml'
    ansible.provisioning_path = '/home/vagrant/fedora_kd/userland'
  end
end
