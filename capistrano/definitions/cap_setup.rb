#
# Cookbook Name:: capistrano
# Definition:: cap_setup
#

define :cap_setup, :path => "/var/www", :owner => "root", :group => "root", :appowner => "nobody" do

  directory params[:path] do
    owner params[:owner]
    group params[:group]
    mode "0755"
  end

  execute "deploydir_cleanup" do
    command "rm -rf ./*"
    cwd params[:path]
    action :run
    not_if "test -d #{params[:path]}/shared"
  end

  %w{ releases shared }.each do |dir|
    directory "#{params[:path]}/#{dir}" do
      owner params[:owner]
      group params[:group]
      mode "0775"
    end
  end

  %w{ log system }.each do |dir|
    directory "#{params[:path]}/shared/#{dir}" do
      owner params[:appowner]
      group params[:group]
      mode "0775"
    end
  end

end
