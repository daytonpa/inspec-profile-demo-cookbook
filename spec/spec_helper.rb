require 'chefspec'
require 'chefspec/policyfile'

module PlatformVersions
  @amazon = %w( 2017.09 2 )
  @centos = %w( 6.10 7.7.1908 )
  @ubuntu = %w( 16.04 18.04 )

  def self.amazon
    @amazon
  end

  def self.centos
    @centos
  end

  def self.ubuntu
    @ubuntu
  end
end
