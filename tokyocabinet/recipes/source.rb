#
# Cookbook Name:: tokyocabinet
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "build-essential"
include_recipe "zlib"

package "libbz2-dev" do
  action :install
end

version = node['tokyocabinet']['version']
configure_options = node['tokyocabinet']['configure_options'].join(" ")

remote_file "#{Chef::Config[:file_cache_path]}/tokyocabinet-#{version}.tar.gz" do
  source "#{node['tokyocabinet']['url']}/tokyocabinet-#{version}.tar.gz"
#  checksum node['tokyocabinet']['checksum']
  mode "0644"
  not_if "which tokyocabinet"
end

bash "build tokyocabinet" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
  tar -zxvf tokyocabinet-#{version}.tar.gz
  (cd tokyocabinet-#{version} && ./configure #{configure_options})
  (cd tokyocabinet-#{version} && make && make install)
  EOF
  not_if "which tokyocabinet"
end

#execute "mount_ebs" do
#  command "mkfs -t ext4 /dev/xvdk && mount /dev/xvdk /mnt/tyrant"
#  action :run
#  only_if "test -b /dev/xvdk"
#end

