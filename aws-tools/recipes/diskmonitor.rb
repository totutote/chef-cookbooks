#
# Cookbook Name:: aws-tools
# Recipe:: default
#

case node['platform']
when "ubuntu", "debian"
  %w{unzip libwww-perl libcrypt-ssleay-perl}.each do |pkg|
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

bash "install_script" do
  user "root"
  cwd "/opt"
  code <<-EOH
  cd
  mkdir aws-scripts-mon
  cd aws-scripts-mon
  wget http://ec2-downloads.s3.amazonaws.com/cloudwatch-samples/CloudWatchMonitoringScripts.zip
  unzip CloudWatchMonitoringScripts.zip
  rm CloudWatchMonitoringScripts.zip
  EOH
end

cron "put_instance_data" do
  minute "*/5"
  command "/opt/aws-scripts-mon/mon-put-instance-data.pl --mem-util #{node[:aws_tools][:mon][:check_disk]} --aws-credential-file=/etc/aws/credentials.txt --from-cron"
end

if node[:aws_tools][:mon][:check_metrics] == true

  bash "set alarm" do
    user "root"
    cwd "/opt"
    code <<-EOH
    instance=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
    mon-put-metric-alarm --alarm-name disk-use-alarm --alarm-description "disk use alarm" --metric-name CPUUtilization --namespace System/Linux --statistic Average --period 300 --threshold 80 --comparison-operator GreaterThanThreshold  --dimensions InstanceId=${instance} --evaluation-periods 2 --unit Percent --alarm-actions 
    EOH
  end

end

