#
# Cookbook Name:: tokyotyrant
# Recipe:: default
#

include_recipe "build-essential"

version = node['tokyotyrant']['version']
configure_options = node['tokyotyrant']['configure_options'].join(" ")

remote_file "#{Chef::Config[:file_cache_path]}/tokyotyrant-#{version}.tar.gz" do
  source "#{node['tokyotyrant']['url']}/tokyotyrant-#{version}.tar.gz"
#  checksum node['tokyotyrant']['checksum']
  mode "0644"
  not_if "which tokyotyrant"
end

bash "build tokyotyrant" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
  tar -zxvf tokyotyrant-#{version}.tar.gz
  (cd tokyotyrant-#{version} && ./configure #{configure_options})
  (cd tokyotyrant-#{version} && make && make install)
  EOF
  not_if "which tokyotyrant"
end

group "tokyotyrant" do
end

user "tokyotyrant" do
  comment "TokyoTyrant server User"
  gid "tokyotyrant"
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

template "/etc/init.d/tokyotyrant" do
  source "tokyotyrant.erb"
  owner "root"
  group "root"
  mode "0755"
end

service "tokyotyrant" do
  supports :start => true, :stop => true ,:restart => true
#  action [ :enable, :restart ]
end

execute "start tokyotyrant" do
  command "/etc/init.d/tokyotyrant start"
end
