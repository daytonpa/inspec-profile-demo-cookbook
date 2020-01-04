# node_exporter

### Author(s)
- Patrick Dayton <daytonpa@gmail.com>

***

## About

The cookbook installs/configures the [Prometheus Node Exporter](https://github.com/prometheus/node_exporter) metrics collection service.

***

## Usage

Simply add this cookbook within your run list, and have the `chef-client` run the default recipe.  The default configuration for this cookbook will install Node Exporter v0.18.1 without overriding the default collectors.  To update the desired metrics Collectors, go to the Attributes section of this README.

***

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

***

## Linting/Testing

Linting is performed with both [Foodcritic](https://github.com/Foodcritic/foodcritic) and [Cookstyle](https://github.com/chef/cookstyle).  Both are bundled within the ChefDK, and can be executed with the following commands:

**Foodcritic**
```bash
$ chef exec foodcritic .
```

**Cookstyle**
```bash
$ chef exec cookstyle -D .
```

Unit tests are performed with ChefSpec, and integration tests are performed via InSpec.  Unit tests are stored within this cookbook, and the corresponding InSpec tests are saved within the [node_exporter_inspec_profile](https://github.com/daytonpa/node_exporter_inspec_profile) repository.

When performing automated checks via [GitHub Actions](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/about-github-actions), the only supported CI processes at this time are Lint checks and Unit tests.  Lint checks are performed for every Push action for this repository, and both Lint and Unit tests are performed for every Pull Request.

- The Action files can be found inside the [.github/workflows](./.github/workflows/) directory.
