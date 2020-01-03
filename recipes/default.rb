#
# Cookbook:: node_exporter
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

arch = if node['kernel']['machine'] == 'x86_64'
         'amd64'
       else
         '386'
       end
node_exporter_version = node['node_exporter']['version']

group node['node_exporter']['group'] do
  system true
  only_if { node['node_exporter']['group'] != 'root' }
end

user node['node_exporter']['user'] do
  group node['node_exporter']['group']
  system true
  only_if { node['node_exporter']['user'] != 'root' }
end

case node['platform']
when 'ubuntu'
  apt_update 'update' do
    action :periodic
  end

when 'amazon', 'centos'
  cron 'yum' do
    minute node['node_exporter']['cron']['minute']
    hour node['node_exporter']['cron']['hour']
    command 'yum update -y'
    notifies :run, 'execute[yum]', :immediately
  end

  execute 'yum' do
    command 'yum update -y'
    action :nothing
  end
end

remote_file 'node_exporter' do
  owner node['node_exporter']['user']
  group node['node_exporter']['group']
  path "#{Chef::Config[:file_cache_path]}/node_exporter-#{node_exporter_version}.linux-#{arch}.tar.gz"
  source "https://github.com/prometheus/node_exporter/releases/download/v#{node_exporter_version}/node_exporter-#{node_exporter_version}.linux-#{arch}.tar.gz"
  notifies :run, 'execute[unpack_and_install_node_exporter]', :immediately
end

execute 'unpack_and_install_node_exporter' do
  cwd Chef::Config[:file_cache_path]
  command <<-COMMAND
    tar -xzf node_exporter-#{node_exporter_version}.linux-#{arch}.tar.gz \
      --strip-components=1 && \
      mv #{Chef::Config[:file_cache_path]}/node_exporter #{node['node_exporter']['path']['bin']}
  COMMAND
  not_if 'systemctl status node_exporter | grep -q "active (running)"'
end

# Create a PID file for the node_exporter daemon
file node['node_exporter']['path']['pid'] do
  owner node['node_exporter']['user']
  group node['node_exporter']['group']
  mode '0644'
end

# Generate the systemd/init.d file for node_exporter
case node['init_package']
when 'systemd'
  template '/etc/systemd/system/node_exporter.service' do
    owner node['node_exporter']['user']
    group node['node_exporter']['group']
    source 'node_exporter.service.erb'
    notifies :run, 'execute[reload]', :immediately
  end
  execute 'reload' do
    command 'systemctl daemon-reload'
    action :nothing
  end
else
  template '/etc/rc.d/init.d/node_exporter' do
    owner node['node_exporter']['user']
    group node['node_exporter']['group']
    source 'node_exporter.init.d.erb'
    notifies :restart, 'service[node_exporter]', :delayed
  end
end

service 'node_exporter' do
  supports reload: true, restart: true
  action %i(start enable)
end
