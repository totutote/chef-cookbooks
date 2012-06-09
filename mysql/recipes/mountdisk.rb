#
# Cookbook Name:: aws-tools
# Recipe:: default
#
# Copyright 2011, trampoline systems ltd
#
# All rights reserved - Do Not Redistribute
#

case node['platform']
when "ubuntu", "debian"
  %w{mdadm}.each do |pkg|
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

%w{"/dev/sdk" "/dev/sdl" "/dev/sdm" "/dev/sdn"}.each do |device|
  bash "mysql_create_data_volume" do
    user "root"
    cwd "/root"
    code <<-EOH
    source /etc/profile
    instance=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
    zone=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
    volume=$(ec2-create-volume -s 50 -z $zone | awk 'BEGIN { FS="\t" }; NR==1 { print $2 }' )
    sleep 10
    ec2-attach-volume $volume -i $instance -d #{device}
    EOH
    not_if "test -e /dev/md0"
  end
end

execute "ebs_mount_wait" do
  command "sleep 60"
  action :run
end

mdadm "/dev/md0" do
  devices [ "/dev/xvdk", "/dev/xvdl", "/dev/xvdm", "/dev/xvdn" ]
  level 0
  chunk 256
  action [ :create, :assemble ]
  not_if "test -e /dev/md0"
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

execute "mysql_data_volume_mkfs_ext4" do
  command "yes | mkfs -t ext4 /dev/md0"
  action :run
end

mount node[:mysql][:data_dir] do
  device "/dev/md0"
  fstype "ext4"
  options "noatime"
  action [:mount, :enable]
end

bash "mysql_create_log_volume" do
  user "root"
  cwd "/root"
  code <<-EOH
  source /etc/profile
  instance=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
  zone=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
  volume=$(ec2-create-volume -s 300 -z $zone | awk 'BEGIN { FS="\t" }; NR==1 { print $2 }' )
  sleep 10
  ec2-attach-volume $volume -i $instance -d /dev/sdo
  EOH
  not_if "test -e /dev/xvdo"
end

execute "ebs_mount_wait" do
  command "sleep 60"
  action :run
end

execute "mysql_log_volume_mkfs_ext4" do
  command "yes | mkfs -t ext4 /dev/xvdo"
  action :run
end

directory node['mysql']['log_dir'] do
  owner "mysql"
  group "mysql"
  mode 0755
  recursive true
end

mount "/ebs/log" do
  device "/dev/xvdo"
  fstype "ext4"
  options "noatime"
  action [:mount, :enable]
end

