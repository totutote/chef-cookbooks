#
# Cookbook Name:: platform
# Recipe:: default
#

directory "/etc/rc.local.d" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end



