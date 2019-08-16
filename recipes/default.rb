#
# Cookbook:: inspec-profile-demo-cookbook
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# This is a demo cookbook for testing InSpec Profiles
# We're installing

node_exporter_version = node['inspec-profile-demo-cookbook']['version']
node_exporter_user = node['inspec-profile-demo-cookbook']['user']
node_exporter_group = node['inspec-profile-demo-cookbook']['group']

group node_exporter_group do unless node_exporter_group == 'root'
  system true
end
user node_exporter_user do unless node_exporter_user == 'root'
  manage_home false
  group node_exporter_group
  system true
end

case node['platform']
when 'ubuntu' 

  apt_update 'update' do
    action :periodic
  end

  remote_file 'node_exporter' do
    owner node_exporter_user
    group node_exporter_group
    path "/tmp/node_exporter-#{node_exporter_version}.linux-amd64.tar.gz"
    source "https://github.com/prometheus/node_exporter/releases/download/v#{node_exporter_version}/node_exporter-#{node_exporter_version}.linux-amd64.tar.gz"
    notifies :run, 'execute[unpack_and_install_node_exporter]', :immediately
    not_if "/usr/bin/node_exporter --version | grep -q #{node_exporter_version}"
  end
  execute 'unpack_and_install_node_exportnode_exporter_versionnode_exporter_versionnode_exporter_versionnode_exporter_versioner' do
    cwd '/tmp'
    command <<-COMMAND
      tar -xzf node_exporter-#{node_exporter_version}.linux-amd64.tar.gz --strip-components=1 &&
        mv /tmp/node_exporter #{node['inspec-profile-demo-cookbook']['path']['bin']}
    COMMAND
    not_if 'systemctl status node_exporter | grep -q "active (running)"'
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

  case node['platform_version']
  when '2017.09'

  when '2'

  end
end

# Create a PID file for the node_exporter daemon
file node['inspec-profile-demo-cookbook']['path']['pid'] do
  owner node_exporter_user
  group node_exporter_group
end

# Create a directory and file for logs
directory '/var/log/node_exporter' do
  owner node_exporter_user
  group node_exporter_group
  mode '0700'
end


# Generate the systemd file for node_exporter
if node['platform_version'] == ('16.04', '18.04', '2')
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
