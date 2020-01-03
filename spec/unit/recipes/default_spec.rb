#
# Cookbook:: node_exporter
# Spec:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'node_exporter::default' do
  {
    'amazon' => PlatformVersions.amazon,
    'centos' => PlatformVersions.centos,
    'ubuntu' => PlatformVersions.ubuntu,
  }.each do |platform, platform_versions|
    platform_versions.each do |version|
      context "When all attributes are default, on #{platform.upcase} #{version}" do
        before do
          Fauxhai.mock(platform: platform, version: version)
          stub_command('systemctl status node_exporter | grep -q "active (running)"').and_return(false)
        end

        let(:chef_run) do
          ChefSpec::SoloRunner.new(platform: platform, version: version).converge(described_recipe)
        end
        let(:cron) { chef_run.cron('yum') }
        let(:remote_file) { chef_run.remote_file('node_exporter') }
        let(:template) { chef_run.template('/etc/systemd/system/node_exporter.service') }

        it 'converges successfully' do
          expect { chef_run }.to_not raise_error
        end

        it 'creates a system user and group for the node exporter service' do
          expect(chef_run).to create_user('node_exporter').with(
            system: true,
            group: 'node_exporter'
          )
          expect(chef_run).to create_group('node_exporter').with(system: true)
        end

        case platform
        when 'centos', 'amazon'
          it 'creates a cron job to update YUM, and updates YUM' do
            expect(chef_run).to create_cron('yum').with(
              command: 'yum update -y'
            )
            expect(cron).to notify('execute[yum]').to(:run).immediately
          end
        else
          it 'updates APT' do
            expect(chef_run).to periodic_apt_update('update')
          end
        end

        it 'downloads and installs the node exporter service' do
          expect(chef_run).to create_remote_file('node_exporter').with(
            owner: 'node_exporter',
            group: 'node_exporter'
          )
          expect(remote_file).to notify('execute[unpack_and_install_node_exporter]').to(:run).immediately
        end

        it 'creates a PID file for the node exporter service' do
          expect(chef_run).to create_file('/var/run/node_exporter.pid').with(
            owner: 'node_exporter',
            group: 'node_exporter',
            mode: '0644'
          )
        end

        it 'creates a daemon file for the node exporter service, and reloads the daemon service' do
          if chef_run.node['init_package'] == 'systemd'
            expect(chef_run).to create_template('/etc/systemd/system/node_exporter.service').with(
              owner: 'node_exporter',
              group: 'node_exporter'
            )
            expect(template).to notify('execute[reload]').to(:run).immediately
          else
            expect(chef_run).to create_template('/etc/rc.d/init.d/node_exporter').with(
              owner: 'node_exporter',
              group: 'node_exporter'
            )
          end
        end

        it 'starts and enables the node exporter service' do
          expect(chef_run).to start_service('node_exporter')
          expect(chef_run).to enable_service('node_exporter')
        end
      end
    end
  end
end
