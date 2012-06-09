# -*- coding: utf-8 -*-
#
# Cookbook Name:: tokyotyrant
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

case node[:platform]
when "debian", "ubuntu"
  package "tokyotyrant"
else
  package "tokyotyrant" #テストしていない
end

directory "/mnt/tyrant" do
  mode 0775
  owner "tokyotyrant"
  group "tokyotyrant"
  action :create
  recursive true
end

directory "/mnt/tyrant/data" do
  mode 0775
  owner "tokyotyrant"
  group "tokyotyrant"
  action :create
end

directory "/mnt/tyrant/log" do
  mode 0775
  owner "tokyotyrant"
  group "tokyotyrant"
  action :create
end

#execute "mount_ebs" do
#  command "mkfs -t ext4 /dev/xvdk && mount /dev/xvdk /mnt/tyrant"
#  action :run
#  only_if "test -b /dev/xvdk"
#end

template "/etc/default/tokyotyrant" do
  source "tokyotyrant.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end


