#
# Cookbook Name:: sysstat
# Recipe:: default
#

case node[:platform]
when "ubuntu","debian"

  package "sysstat" do
    action :install
  end

  service "sysstat" do
    supports :status => true, :restart => true, :reload => true
    action :nothing
  end

  template "/etc/default/sysstat" do
    source "sysstat.erb"
    notifies :restart, resources(:service => "sysstat"), :immediately
  end

end

