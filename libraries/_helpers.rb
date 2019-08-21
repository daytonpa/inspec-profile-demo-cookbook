
def generate_node_exporter_config()
  @config = ''
  node['inspec-profile-demo-cookbook']['config'].each do |config_key, config_value|
    case config_value
    when '', nil
    else
      @config << "--#{config_key}=#{config_value} "
    end
  end
  @config
end
