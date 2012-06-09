#
# Cookbook Name:: capistrano
# Recipe:: default
#

gem_package "capistrano"
gem_package "capistrano-ext"
gem_package "capistrano_colors"
gem_package "capistrano_rsync_with_remote_cache"
gem_package "capistrano-ec2group"

deployer = Hash.new

deployer = data_bag_item("capistrano", "deployer")

if node[:apache] and node[:apache][:allowed_openids]
  Array(deployer['openid']).compact.each do |oid|
    node[:apache][:allowed_openids] << oid unless node[:apache][:allowed_openids].include?(oid)
  end
end

home_dir = "/home/#{deployer['id']}"

ruby_block "reset group list" do
  block do
    Etc.endgrent
  end
  action :nothing
end

user deployer['id'] do
  uid deployer['uid']
  gid deployer['gid']
  shell deployer['shell']
  comment deployer['comment']
  supports :manage_home => true
  home home_dir
  notifies :create, "ruby_block[reset group list]", :immediately
end

group "admin" do
  members ['deployer']
  action :modify
end

directory "#{home_dir}/.ssh" do
  owner deployer['id']
  group deployer['gid'] || deployer['id']
  mode "0700"
end

template "#{home_dir}/.ssh/authorized_keys" do
  source "authorized_keys.erb"
  owner deployer['id']
  group deployer['gid'] || deployer['id']
  mode "0600"
  variables :ssh_keys => deployer['ssh_keys']
end

template "#{home_dir}/.ssh/id_rsa" do
  source "id_rsa.erb"
  owner deployer['id']
  group deployer['gid'] || deployer['id']
  mode "0600"
  variables :ssh_private_keys => deployer['ssh_private_keys']
end

directory "#{home_dir}/capistrano" do
  owner deployer['id']
  group deployer['gid'] || deployer['id']
  mode "0755"
end

template "#{home_dir}/capistrano/Capfile" do
  source "Capfile.erb"
  owner deployer['id']
  group deployer['gid'] || deployer['id']
  mode "0755"
  variables :ssh_keys => deployer['ssh_keys']
end

directory "#{home_dir}/capistrano/config" do
  owner deployer['id']
  group deployer['gid'] || deployer['id']
  mode "0755"
end

template "#{home_dir}/capistrano/config/deploy.rb.sample" do
  source "deploy.rb.sample.erb"
  owner deployer['id']
  group deployer['gid'] || deployer['id']
  mode "0755"
end

directory "#{home_dir}/capistrano/config/deploy" do
  owner deployer['id']
  group deployer['gid'] || deployer['id']
  mode "0755"
end

credentials = Hash.new
credentials = data_bag_item("proj_common", "aws")

template "#{home_dir}/capistrano/config/deploy/staging.rb.sample" do
  source "staging.rb.sample.erb"
  owner deployer['id']
  group deployer['gid'] || deployer['id']
  mode "0755"
  variables(
    :aws_access_key_id => credentials["accesskeyid"],
    :aws_secret_access_key => credentials["secretkey"]
  )
end

template "#{home_dir}/capistrano/config/deploy/production.rb.sample" do
  source "production.rb.sample.erb"
  owner deployer['id']
  group deployer['gid'] || deployer['id']
  mode "0755"
  variables(
    :aws_access_key_id => credentials["accesskeyid"],
    :aws_secret_access_key => credentials["secretkey"]
  )
end
