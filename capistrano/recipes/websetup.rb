#
# Cookbook Name:: capistrano
# Recipe:: websetup
#


include_recipe "capistrano"

cap_setup node["capistrano"]["app_name"] do
  path node["capistrano"]["path"]
  owner "deployer"
  group "deployer"
  appowner "www-data"
end

group "deployer" do
  members ['www-data']
  append true
  action :modify
end

template "/etc/rc.local.d/capistrano-dir.sh" do
  source "capistrano-dir.sh.erb"
  mode '0755'
  owner 'root'
end

