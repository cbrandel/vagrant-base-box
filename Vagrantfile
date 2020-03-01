
ANSIBLE_PATH = __dir__ # absolute path to Ansible directory on host machine

require File.join(ANSIBLE_PATH, 'lib', 'vagrant')
require 'yaml'

_conf = YAML.load_file("#{ANSIBLE_PATH}/provision/default.yml")

if File.exist?("#{ANSIBLE_PATH}/local.yml")
  local_config = YAML.load_file("#{ANSIBLE_PATH}/local.yml")
  _conf.merge!(local_config) if local_config
end

ensure_plugins(_conf.fetch('vagrant_plugins')) if _conf.fetch('vagrant_install_plugins')

Vagrant.configure("2") do |config|

  config.vm.box = _conf.fetch('vagrant_box')
  if(_conf.has_key?('vagrant_box_version'))
    config.vm.box_version = _conf.fetch('vagrant_box_version')
  end
  config.vm.hostname =  _conf.fetch('vagrant_hostname')
  config.vm.network :private_network, ip: _conf.fetch('vagrant_ip')
  config.ssh.forward_agent = true

  if Vagrant.has_plugin?('vagrant-hostmanager')
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
  end
  
  config.vm.provider 'virtualbox' do |v|
    v.name = config.vm.hostname
    v.customize ['modifyvm', :id, '--cpus', _conf.fetch('vagrant_cpus').to_i]
    v.customize ['modifyvm', :id, '--memory', _conf.fetch('vagrant_memory').to_i]
    v.customize ['modifyvm', :id, '--ioapic', _conf.fetch('vagrant_ioapic', 'on')]

    # Fix for slow external network connections
    v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    v.customize ['modifyvm', :id, '--vrde', 'off']
  end

  # Synced Folders
  _conf.fetch('vagrant_synced_folders', []).each do |folder|
    options = {
      type: folder.fetch('type', 'nfs'),
      create: folder.fetch('create', false),
      mount_options: folder.fetch('mount_options', [])
    }

    destination_folder = folder.fetch('bindfs', true) ? nfs_path(folder['destination']) : folder['destination']

    config.vm.synced_folder folder['local_path'], destination_folder, options

    if folder.fetch('bindfs', true)
      config.bindfs.bind_folder destination_folder, folder['destination'], folder.fetch('bindfs_options', {})
    end
  end

  # Provisioning
  config.vm.provision "ansible_local" do |ansible|
    ansible.version = _conf.fetch('vagrant_ansible_version')
    ansible.compatibility_mode = "2.0"
    ansible.extra_vars = {
      vbb: _conf
    }
    ansible.playbook = "provision/playbook.yml"
  end
end
