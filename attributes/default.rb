

default['node_exporter'].tap do |demo|
  demo['user'] = 'node_exporter'
  demo['group'] = 'node_exporter'
  demo['version'] = '0.18.1'

  demo['cron'].tap do |c|
    c['minute'] = '0'
    c['hour'] = '*/12'
  end

  demo['path'].tap do |path|
    path['bin'] = '/usr/bin/node_exporter'
    path['logs'] = '/var/log/node_exporter/node_exporter.logs'
    path['pid'] = '/var/run/node_exporter.pid'
  end

  demo['config']['options'].tap do |opt|
    opt['web.listen-address'] = ':9100'
    opt['web.telemetry-path'] = '/metrics'
    opt['web.max-requests'] = '40'
    opt['log.level'] = 'info'
    opt['log.format'] = 'logger:stderr'
  end
  demo['config']['collectors'].tap do |collect|
    collect['arp'] = nil
    collect['bcache'] = nil
    collect['bonding'] = nil
    collect['buddyinfo'] = nil
    collect['conntrack'] = nil
    collect['cpu'] = nil
    collect['cpufreq'] = nil
    collect['diskstats'] = nil
    collect['drbd'] = nil
    collect['edac'] = nil
    collect['entropy'] = nil
    collect['filefd'] = nil
    collect['filesystem'] = nil
    collect['hwmon'] = nil
    collect['infiniband'] = nil
    collect['interrupts'] = nil
    collect['ipvs'] = nil
    collect['ksmd'] = nil
    collect['loadavg'] = nil
    collect['logind'] = nil
    collect['mdadm'] = nil
    collect['meminfo'] = nil
    collect['meminfo_numa'] = nil
    collect['mountstats'] = nil
    collect['netclass'] = nil
    collect['netdev'] = nil
    collect['netstat'] = nil
    collect['nfs'] = nil
    collect['nfsd'] = nil
    collect['ntp'] = nil
    collect['perf'] = nil
    collect['pressure'] = nil
    collect['processes'] = nil
    collect['qdisc'] = nil
    collect['runit'] = nil
    collect['sockstat'] = nil
    collect['stat'] = nil
    collect['supervisord'] = nil
    collect['systemd'] = nil
    collect['tcpstat'] = nil
    collect['textfile'] = nil
    collect['time'] = nil
    collect['timex'] = nil
    collect['uname'] = nil
    collect['vmstat'] = nil
    collect['wifi'] = nil
    collect['xfs'] = nil
    collect['zfs'] = nil
  end
end
