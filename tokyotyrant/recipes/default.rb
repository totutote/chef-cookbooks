# -*- coding: utf-8 -*-
#
# Cookbook Name:: tokyotyrant
# Recipe:: default
#

case node[:platform]
when "debian", "ubuntu"
  package "tokyotyrant"
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

template "/etc/default/tokyotyrant" do
  source "tokyotyrant.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end
