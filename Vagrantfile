# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

mongos = JSON.parse(IO.read('vagrant_boxes/mongos.json'))
mongod = JSON.parse(IO.read('vagrant_boxes/mongod.json'))
mongoc = JSON.parse(IO.read('vagrant_boxes/mongoc.json'))

boxes = {
  'mongos' => mongos,
  'mongod' => mongod,
  'mongoc' => mongoc
}

# define servers
servers = [
  { hostname: 'c0', type: 'mongoc', primary: false },
  { hostname: 'c1', type: 'mongoc', primary: false },
  { hostname: 'c2', type: 'mongoc', primary: false },
  { hostname: 'd0', type: 'mongod', primary: false },
  { hostname: 'd1', type: 'mongod', primary: false },
  { hostname: 'd2', type: 'mongod', primary: false },
  { hostname: 's0', type: 'mongos', primary: false }
]

# cookbook path
cookbooks_path = 'berks_cookbooks'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.omnibus.chef_version = :latest

  # Setup hostmanager config to update the host files
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true
  config.vm.provision :hostmanager

  # Forward our SSH Keys into the VM
  config.ssh.forward_agent = true

  # Loop through all servers and configure them
  servers.each do |server|
    config.vm.define server[:hostname], primary: server[:primary] do |node_config|
      node_config.vm.box = boxes[server[:type]]['box']
      node_config.vm.box_url = boxes[server[:type]]['boxurl']
      node_config.vm.hostname = server[:hostname]
      node_config.vm.network :private_network, auto_network: true
      node_config.hostmanager.aliases = server[:hostname]

      node_config.vm.provision :chef_solo do |chef|
        chef.data_bags_path = './data_bags'
        chef.json = boxes[server[:type]]['json']

        boxes[server[:type]]['recipes'].each do |recipe|
          chef.add_recipe recipe
        end
      end
    end
  end

  # vagrant trigger to get cookbooks and install them in
  # cookbook path
  [:up, :provision].each do |cmd|
    if (File.exist?("#{cookbooks_path}/Berksfile.lock") == false) || (File.exist?("#{cookbooks_path}/Berksfile.lock") == true && FileUtils.compare_file('Berksfile.lock', "#{cookbooks_path}/Berksfile.lock") == false)
      config.trigger.before cmd, stdout: true do
        info 'Cleaning cookbook directory'
        run "rm -rf #{cookbooks_path}"
        info 'Installing cookbook dependencies with berkshelf'
        run "berks vendor #{cookbooks_path}"
      end
    end
  end

end
