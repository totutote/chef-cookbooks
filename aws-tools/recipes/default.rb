#
# Cookbook Name:: aws-tools
# Recipe:: default
#

package "unzip" do
  action :install
end

# ec2 Command
awstool_install "ec2" do
  env "EC2_HOME"
  dl_url node[:aws_tools][:ec2][:dl_uri]
  dl_file node[:aws_tools][:ec2][:dl_file]
  file_name node[:aws_tools][:ec2][:file_name]
end

# SNS Command
awstool_install "sns" do
  env "AWS_SNS_HOME"
  dl_url node[:aws_tools][:sns][:dl_uri]
  dl_file node[:aws_tools][:sns][:dl_file]
  file_name node[:aws_tools][:sns][:file_name]
end

# Auto Scaling Command
awstool_install "as" do
  env "AWS_AUTO_SCALING_HOME"
  dl_url node[:aws_tools][:as][:dl_uri]
  dl_file node[:aws_tools][:as][:dl_file]
  file_name node[:aws_tools][:as][:file_name]
end

# Cloud Watch Command
awstool_install "mon" do
  env "AWS_CLOUDWATCH_HOME"
  dl_url node[:aws_tools][:mon][:dl_uri]
  dl_file node[:aws_tools][:mon][:dl_file]
  file_name node[:aws_tools][:mon][:file_name]
end 

# Simple queue service Command
awstool_install "elasticache" do
  env "AWS_ELASTICACHE_HOME"
  dl_url node[:aws_tools][:elasticache][:dl_uri]
  dl_file node[:aws_tools][:elasticache][:dl_file]
  file_name node[:aws_tools][:elasticache][:file_name]
end

# CloudFormtion Command
awstool_install "cfn" do
  env "AWS_CLOUDFORMATION_HOME"
  dl_url node[:aws_tools][:cfn][:dl_uri]
  dl_file node[:aws_tools][:cfn][:dl_file]
  file_name node[:aws_tools][:cfn][:file_name]
end

# ELB Command
awstool_install "elb" do
  env "AWS_ELB_HOME"
  dl_url node[:aws_tools][:elb][:dl_uri]
  dl_file node[:aws_tools][:elb][:dl_file]
  file_name node[:aws_tools][:elb][:file_name]
end

credentials = Hash.new
credentials = data_bag_item("proj_common", "aws")

template "/etc/profile.d/aws-product-common.sh" do
  source "aws-product-common.sh.erb"
  owner "root"
  group "root"
  mode "0755"
  variables(
    :java_home => "/usr/lib/jvm/default-java/jre",
    :cert_name => credentials["x509_cert_name"],
    :private_key_name => credentials["x509_pk_name"]
  )
end

include_recipe "java::openjdk"

directory "/etc/aws" do
  owner "root"
  group "root"
  mode "755"
  action :create
end

template "/etc/aws/credentials.txt" do
  source "credentials.txt.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :accesskeyid => credentials["accesskeyid"],
    :secretkey => credentials["secretkey"]
  )
end

template "/etc/aws/#{credentials["x509_cert_name"]}" do
  source "cert-key.pem.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :cert_key => credentials["x509_cert_key"]
  )
end

template "/etc/aws/#{credentials["x509_pk_name"]}" do
  source "pk-key.pem.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :pk_key => credentials["x509_pk_key"]
  )
end

