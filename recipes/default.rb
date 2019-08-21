#
# Cookbook:: inspec-profile-demo-cookbook
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# This is a demo cookbook for testing InSpec Profiles
# We're installing

case node['hostnamectl']['architecture']
when 'x86-64'
  arch = 'amd64'
else
  arch = '386'
end

node_exporter_version = node['inspec-profile-demo-cookbook']['version']
node_exporter_user = node['inspec-profile-demo-cookbook']['user']
node_exporter_group = node['inspec-profile-demo-cookbook']['group']

group node_exporter_group do
  system true
  only_if { node_exporter_group != 'root' }
end
user node_exporter_user do
  group node_exporter_group
  system true
  only_if { node_exporter_user != 'root' }
end

case node['platform']
when 'ubuntu' 

  apt_update 'update' do
    action :periodic
  end

when 'amazon'

  cron 'yum' do
    minute node['inspec-profile-demo-cookbook']['cron']['minute']
    hour node['inspec-profile-demo-cookbook']['cron']['hour']
    command 'yum update -y'
    notifies :run, 'execute[yum]', :immediately
  end
  execute 'yum' do
    command 'yum update -y'
    action :nothing
  end

end

remote_file 'node_exporter' do
  owner node_exporter_user
  group node_exporter_group
  path "/tmp/node_exporter-#{node_exporter_version}.linux-#{arch}.tar.gz"
  source "https://github.com/prometheus/node_exporter/releases/download/v#{node_exporter_version}/node_exporter-#{node_exporter_version}.linux-#{arch}.tar.gz"
  notifies :run, 'execute[unpack_and_install_node_exporter]', :immediately
  not_if "/usr/bin/node_exporter --version | grep -q #{node_exporter_version}"
end
execute 'unpack_and_install_node_exporter' do
  cwd '/tmp'
  command <<-COMMAND
    tar -xzf node_exporter-#{node_exporter_version}.linux-#{arch}.tar.gz --strip-components=1 &&
      mv /tmp/node_exporter #{node['inspec-profile-demo-cookbook']['path']['bin']}
  COMMAND
  not_if 'systemctl status node_exporter | grep -q "active (running)"'
end

# Create a PID file for the node_exporter daemon
file node['inspec-profile-demo-cookbook']['path']['pid'] do
  owner node_exporter_user
  group node_exporter_group
  mode '0644'
end

# Create a directory and file for logs
directory node['inspec-profile-demo-cookbook']['dir']['logs'] do
  owner node_exporter_user
  group node_exporter_group
  mode '0755'
end
[
  "#{node['inspec-profile-demo-cookbook']['dir']['logs']}/node_exporter.logs",
  "#{node['inspec-profile-demo-cookbook']['dir']['logs']}/node_exporter.error"
].each do |log_file|
  file log_file do
    owner node_exporter_user
    group node_exporter_group
    mode '0644'
  end
end

# Generate the systemd/init.d file for node_exporter
case node['platform_version'] 
when '16.04', '18.04', '2'
  template '/etc/systemd/system/node_exporter.service' do
    owner node_exporter_user
    group node_exporter_group
    source 'node_exporter.service.erb'
    notifies :run, 'execute[reload]', :immediately
  end
  execute 'reload' do
    command 'systemctl daemon-reload'
    action :nothing
  end
else
  template '/etc/rc.d/init.d/node_exporter' do
    owner node_exporter_user
    group node_exporter_group
    source 'node_exporter.init.d.erb'
    notifies :restart, 'service[node_exporter]', :delayed
  end
end

service 'node_exporter' do
  supports :reload => true, :restart => true
  action %i(start enable)
end
