#
# Cookbook Name:: tokyotyrant
# Recipe:: tokyotyrant
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

if (node.attribute?('ec2') && ! FileTest.directory?(node['mysql']['ec2_path']))

  service "mysql" do
    action :stop
  end

  execute "install-mysql" do
    command "mv #{node['mysql']['data_dir']} #{node['mysql']['ec2_path']}"
    not_if do FileTest.directory?(node['mysql']['ec2_path']) end
  end

  directory node['mysql']['ec2_path'] do
    owner "mysql"
    group "mysql"
  end

  mount node['mysql']['data_dir'] do
    device node['mysql']['ec2_path']
    fstype "none"
    options "bind,rw"
    action :mount
  end

  service "mysql" do
    action :start
  end

end

execute mount_ebs do
  command "mkfs -t ext4 /dev/xvdk && mkdir -p /tyrantdata && mount /dev/xvdk /tyrantdata"
  action :run
end

template "/etc/default/tokyotyrant" do
  source "tokyotyrant.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end

