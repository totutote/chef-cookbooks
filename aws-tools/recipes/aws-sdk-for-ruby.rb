#
# Cookbook Name:: aws-tools
# Recipe:: default
#

directory "/etc/aws" do
  owner "root"
  group "root"
  mode "755"
  action :create
end

pkgs = value_for_platform(
    ["centos","redhat","fedora"] =>
        {"default" => %w{ }},
    [ "debian", "ubuntu" ] =>
        {"default" => %w{ ruby-dev libxslt-dev libxml2-dev rubygems}},
    "default" => %w{ }
  )

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

gem_package "aws-sdk"

credentials = Hash.new
credentials = data_bag_item("proj_common", "aws")

template "/etc/aws/aws.yml" do
  source "aws.yml.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :accesskeyid => credentials['accesskeyid'],
    :secretkey => credentials['secretkey']
  )
end

