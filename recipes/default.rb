#
# Cookbook:: inspec-profile-demo-cookbook
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# This is a demo cookbook for testing InSpec Profiles
# We're installing

node_exporter_version = '0.18.1'

case node['platform']
when 'ubuntu' 

  apt_update 'update' do
    action :periodic
  end

  remote_file 'node_exporter' do
    path "/tmp/node_exporter-#{node_exporter_version}.linux-amd64.tar.gz"
    source "https://github.com/prometheus/node_exporter/releases/download/v#{node_exporter_version}/node_exporter-#{node_exporter_version}.linux-amd64.tar.gz"
    notifies :run, 'execute[unpack_and_install_node_exporter]', :immediately
    not_if "/usr/bin/node_exporter --version | grep -q #{node_exporter_version}"
  end
  execute 'unpack_and_install_node_exportnode_exporter_versionnode_exporter_versionnode_exporter_versionnode_exporter_versioner' do
    cwd '/tmp'
    command <<-COMMAND
      tar -xzf node_exporter-#{node_exporter_version}.linux-amd64.tar.gz --strip-components=1 &&
        mv /tmp/node_exporter /usr/bin/node_exporter
    COMMAND
    not_if 'systemctl status node_exporter | grep -q "active (running)"'
  end

  when 'amazon'

  cron 'yum' do
    minute '0'
    hour '*/12'
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
file '/var/run/node_exporter.pid'

# Generate the systemd file for node_exporter
if node['platform_version'] == ('16.04', '18.04', '2')
  file '/etc/systemd/system/node_exporter.service' do
    content <<-CONTENT
[Unit]
Description=Node Exporter #{node_exporter_version}

[Service]
PIDFile=/var/run/node_exporter.pid
ExecStart=/usr/bin/node_exporter
Restart=on-failure

[Install]
WantedBy=multi-user.target
    CONTENT
    notifies :run, 'execute[reload]', :immediately
  end

  execute 'reload' do
    command 'systemctl daemon-reload'
    action :nothing
  end

end

service 'node_exporter' do
  supports :reload => true, :restart => true
  action %i(start enable)
end