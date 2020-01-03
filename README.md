# node_exporter

### Author(s)
- Patrick Dayton <daytonpa@gmail.com>

## About

The cookbook installs/configures the [Prometheus Node Exporter](https://github.com/prometheus/node_exporter) metrics collection service.

## Usage

Simply add this cookbook within your run list, and have the `chef-client` run the default recipe.

## Attributes

The primary attributes to focus on are the following:
- `default['node_exporter']['version']`: The desired version of the Node Exporter to install
  - Default is `0.18.1`
- `default['node_exporter']['user']`: The system user to run the Node Exporter service
  - Default is `node_exporter`
- `default['node_exporter']['group']`: The system group to run the NodeExporter service
  - Default is `node_exporter`

There are additional attributes that can override the default settings for the Node Exporter service, as well as which Collectors to use for the service.

To modify the desired Node Exporter Collectors, modify the attribtues within `default['node_exporter']['config']['collectors']`.
- Additional information about the various collectors can be found on the [Prometheus Node Exporter GitHub Page](https://github.com/prometheus/node_exporter#enabled-by-default)

## Testing

Unit tests are performed with ChefSpec, and integration tests are performed via InSpec.  Unit tests are stored within this cookbook, and the corresponding InSpec tests are saved within the [node_exporter_inspec_profile](https://github.com/daytonpa/node_exporter_inspec_profile) repository.
