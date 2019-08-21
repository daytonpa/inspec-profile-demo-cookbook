name 'inspec-profile-demo-cookbook'
maintainer 'Patrick Dayton'
maintainer_email 'myemailis@notforyou.toobad'
license 'All Rights Reserved'
description 'Installs/Configures inspec-profile-demo-cookbook'
long_description 'Installs/Configures inspec-profile-demo-cookbook'
version '1.0.1'
chef_version '>= 14.0'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
issues_url 'https://github.com/daytonpa/inspec-profile-demo-cookbook/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
source_url 'https://github.com/daytonpa/inspec-profile-demo-cookbook'

{
  'ubuntu' => ['16.04', '18.04'],
  'amazon' => ['2017.09', '2']
}.each do |platform, platform_versions|
  platform_versions.each do |version|
    supports platform, version
  end
end
