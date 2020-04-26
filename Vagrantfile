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
    v.memory = MEMORY
    v.cpus = CPUS
  end

  config.vm.provider :libvirt do |libvirt|
    libvirt.memory = MEMORY
    libvirt.cpus = CPUS
  end

  config.vm.synced_folder '~/fedora_kd', '/home/vagrant/fedora_kd'

  config.vm.provision 'shell', inline: '/bin/sh /home/vagrant/fedora_kd/setup_deps.sh'

  config.vm.provision 'ansible_local' do |ansible|
    ansible.become = true
    ansible.limit = "all,localhost"
    ansible.playbook = 'setup.yml'
    ansible.provisioning_path = '/home/vagrant/fedora_kd/userland'
  end
end
