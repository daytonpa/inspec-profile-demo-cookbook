

default['inspec-profile-demo-cookbook'].tap do |demo|
  demo['user'] = 'node_exporter'
  demo['group'] = 'node_exporter'
  demo['version'] = '0.18.1'

  demo['cron'].tap do |c|
    c['minute'] = '0'
    c['hour'] = '*/12'
  end

  demo['dir'].tap do |d|
    d['logs'] = '/var/log/node_exporter'

  demo['path'].tap do |path|
    path['bin'] = '/usr/bin/node_exporter'
    path['pid'] = '/var/run/node_exporter.pid'
  end
end
