#
# Cookbook Name:: CloudWatch
# Definition:: app_name
#

define :awstool_install, :env => "CLOUDWATCH", :dl_uri => "http://ec2-downloads.s3.amazonaws.com", :dl_file => "CloudWatch-2010-08-01.zip", :file_name => "CloudWatch-1.0.12.1" do

  directory "/opt/aws/" do
    owner "root"
    group "root"
    mode "0755"
    action :create
  end

  remote_file "/tmp/#{params[:dl_file]}" do
    source "#{params[:dl_url]}/#{params[:dl_file]}"
    not_if "test -f /tmp/#{params[:dl_file]}"
  end

  execute "unzip #{params[:dl_file]}" do
    cwd "/tmp"
    command "unzip -o -d /opt/aws /tmp/#{params[:dl_file]}"
  end

  link "/opt/aws/#{params[:name]}" do
    to "/opt/aws/#{params[:file_name]}"
  end

  template "/etc/profile.d/#{params[:name]}_awstoolhome.sh" do
    source "environment.sh.erb"
    owner "root"
    group "root"
    mode "755"
    variables(
      :env_name => params[:env],
      :bin_path => "/opt/aws/#{params[:name]}"
    )
    action :create
  end

end
