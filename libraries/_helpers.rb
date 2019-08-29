
def generate_node_exporter_config()
  @config = ''
  node['node_exporter']['config']['options'].each do |config_key, config_value|
    case config_value
    when '', nil
    else
      @config << "--#{config_key}=#{config_value} "
    end
  end
  node['node_exporter']['config']['collectors'].each do |config_key, config_value|
    case config_value
    when true
      @config << "--collector.#{config_key} "
    else
      @config << "--no-collector.#{config_key} "
    end
  end
  @config
end
