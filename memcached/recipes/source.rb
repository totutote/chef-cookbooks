#
# Cookbook Name:: memcached
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "build-essential"

package "memcached" do
  action :purge
end

case node['platform']
when "ubuntu","debian"
  %w{libevent-2.0-5 libevent-dev}.each do |pkg|
    package pkg do
      action :install
    end
  end
when "centos","redhat","fedora"
  %w{}.each do |pkg|
    package pkg do
      action :install
    end
  end
end

remote_file "/var/tmp/memcached-#{node['memcached']['version']}.tar.gz" do
  source "http://memcached.googlecode.com/files/memcached-#{node['memcached']['version']}.tar.gz"
end

script "install_memcache" do
  interpreter "bash"
  user "root"
  cwd "/var/tmp"
  code <<-EOH
  tar -zxf memcached-#{node['memcached']['version']}.tar.gz
  cd memcached-#{node['memcached']['version']}
  ./configure --prefix=/usr/
  make
  make install
  cp scripts/memcached-init /etc/init.d/memcached
  chmod 755 /etc/init.d/memcached
  mkdir -p /usr/share/memcached/scripts/
  cp scripts/start-memcached /usr/share/memcached/scripts/
  chmod 755 /usr/share/memcached/scripts/start-memcached
  EOH
end

service "memcached" do
  action :nothing
  supports :status => true, :start => true, :stop => true, :restart => true
end

template "/etc/memcached.conf" do
  source "memcached.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :listen => node[:memcached][:listen],
    :user => node[:memcached][:user],
    :port => node[:memcached][:port],
    :memory => node[:memcached][:memory],
    :threads => node[:memcached][:threads]
  )
  notifies :restart, resources(:service => "memcached"), :immediately
end

case node[:lsb][:codename]
when "karmic"
  template "/etc/default/memcached" do
    source "memcached.default.erb"
    owner "root"
    group "root"
    mode "0644"
    notifies :restart, resources(:service => "memcached"), :immediately
  end
end
