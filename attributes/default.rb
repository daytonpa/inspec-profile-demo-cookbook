

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
  end

  demo['path'].tap do |path|
    path['bin'] = '/usr/bin/node_exporter'
    path['pid'] = '/var/run/node_exporter.pid'
  end

  demo['config'].tap do |conf|
    conf['web.listen-address'] = ':9100'
    conf['web.telemetry-path'] = '/metrics'
    conf['web.max-requests'] = '40'
    conf['log.level'] = 'info'
    conf['log.format'] = 'logger:stderr'
  end
end
