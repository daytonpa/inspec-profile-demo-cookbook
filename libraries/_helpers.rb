def generate_node_exporter_config
  @config = ''
  node['node_exporter']['config']['options'].each do |config_key, config_value|
    @config << "--#{config_key}=#{config_value} " unless config_value.nil? || config_value == /\s+/ || config_value == ''
  end
  node['node_exporter']['config']['collectors'].each do |config_key, config_value|
    @config << "--collector.#{config_key} " if config_value == true
    @config << "--no-collector.#{config_key} " if config_value == false
  end
  @config
end
