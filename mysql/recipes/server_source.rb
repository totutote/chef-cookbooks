#
# Cookbook Name:: mysql
# Recipe:: default
#
#

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

include_recipe "build-essential"
#include_recipe "mysql::client"

# generate all passwords
node.set_unless['mysql']['server_debian_password'] = secure_password
node.set_unless['mysql']['server_root_password']   = secure_password
node.set_unless['mysql']['server_app_password']    = secure_password
node.set_unless['mysql']['server_repl_password']   = secure_password
node.set_unless['mysql']['server_read_password']   = secure_password

if platform?(%w{debian ubuntu})

  directory "/etc/mysql" do
    owner "root"
    group "root"
    mode 0755
  end

  directory "/etc/mysql/conf.d" do
    owner "root"
    group "root"
    mode 0755
  end

  template "#{node['mysql']['conf_dir']}/debian.cnf" do
    source "debian.cnf.erb"
    owner "root"
    group "root"
    mode "0600"
  end

end

#package "mysql-server" do
#  action :install
#end

case node['platform']
when "ubuntu","debian"
  %w{libncurses5-dev}.each do |pkg|
    package pkg do
      action :install
    end
  end
when "centos","redhat","fedora"
  %w{ncurses-devel}.each do |pkg|
    package pkg do
      action :install
    end
  end
end

remote_file "/var/tmp/mysql-#{node['mysql']['version']}.tar.gz" do
  source "http://dev.mysql.com/get/Downloads/MySQL-5.5/mysql-#{node['mysql']['version']}.tar.gz/from/http://ftp.iij.ad.jp/pub/db/mysql/"
end

script "install_mysql" do
  interpreter "bash"
  user "root"
  cwd "/var/tmp"
  code <<-EOH
  tar -zxf mysql-#{node['mysql']['version']}.tar.gz
  cd mysql-#{node['mysql']['version']}
  cmake . -DCMAKE_INSTALL_PREFIX=/usr
  make install
  cp support-files/mysql.server /etc/init.d/mysql
  chmod 755 /etc/init.d/mysql
  EOH
end

user 'mysql' do
  shell '/bin/bash'
  uid "3001"
  comment 'mysqlserver user'
  supports :manage_home => false
end

directory node['mysql']['data_dir'] do
  owner "mysql"
  group "mysql"
  mode 0755
  recursive true
end

directory node['mysql']['log_dir'] do
  owner "mysql"
  group "mysql"
  mode 0755
  recursive true
end

directory node['mysql']['socket_dir'] do
  owner "mysql"
  group "mysql"
  mode 0755
  recursive true
end

template "#{node['mysql']['conf_dir']}/my.cnf" do
  source "my.cnf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables :data_dir => node['mysql']['data_dir']
end

service "mysql" do
  service_name value_for_platform([ "centos", "redhat", "suse", "fedora" ] => {"default" => "mysqld"}, "default" => "mysql")
#  if (platform?("ubuntu") && node.platform_version.to_f >= 10.04)
#    restart_command "restart mysql"
#    stop_command "stop mysql"
#    start_command "start mysql"
#  end
  supports :status => true, :restart => true, :reload => true
  action :nothing
end

execute "install-mysql-data_dir" do
  command "/usr/scripts/mysql_install_db --user mysql"
  cwd "/usr"
  action :run
  notifies :restart, resources(:service => "mysql"), :immediately
  not_if "test -d #{node['mysql']['data_dir']}/mysql"
end

unless Chef::Config[:solo]
  ruby_block "save node data" do
    block do
      node.save
    end
    action :create
  end
end

if node['mysql']['replication'] == false

  execute "assign-root-password" do
    command "/usr/bin/mysqladmin -u root password \"#{node['mysql']['server_root_password']}\""
    action :run
    only_if "/usr/bin/mysql -u root -e 'show databases;'"
  end

  #variables :skip_federated => skip_federated

  grants_path = "#{node['mysql']['conf_dir']}/mysql_grants.sql"

  application = Hash.new
  application = data_bag_item("proj_common", "application")

  begin
    t = resources("template[#{grants_path}]")
  rescue
    Chef::Log.info("Could not find previously defined grants.sql resource")
    t = template grants_path do
      source "grants.sql.erb"
      owner "root"
      group "root"
      mode "0600"
      action :create
      variables(
        :app_name => application["name"]
      )
    end
  end

  execute "mysql-install-privileges" do
    command "/usr/bin/mysql -u root #{node['mysql']['server_root_password'].empty? ? '' : '-p' }#{node['mysql']['server_root_password']} < #{grants_path}"
    action :nothing
    subscribes :run, resources("template[#{grants_path}]"), :immediately
  end

end

credentials = Hash.new
credentials = data_bag_item("proj_common", "aws")

if node['mysql']['replication'] == true

  template "/root/replication_check.sh" do
    source "replication_check.sh"
    owner "root"
    group "root"
    mode 0755
    variables(
      :cert => credentials['x509_cert_name'],
      :pk => credentials['x509_pk_name']
    )
  end

  cron "replication_check" do
    command "sh /root/replication_check.sh"
    minute "*/10"
  end

end

if node['mysql']['backup'] == true

  template "/root/snapshot.sh" do
    source "snapshot.sh.erb"
    owner "root"
    group "root"
    mode 0755
    variables(
      :cert=> credentials['x509_cert_name'],
      :pk => credentials['x509_pk_name']
    )
  end

  cron "snapshot.sh" do
    command "sh /root/snapshot.sh"
    minute "20"
    hour "4"
  end

end

