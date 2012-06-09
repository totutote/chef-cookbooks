#
# Cookbook Name:: swfmill
# Attribute:: default
#

configure_options = node['swfmill']['configure_options'].join(" ")

include_recipe "build-essential"
include_recipe "xml"

pkgs = value_for_platform(
    ["centos","redhat","fedora"] =>
        {"default" => %w{ bzip2-devel libc-client-devel curl-devel freetype-devel gmp-devel libjpeg-devel krb5-devel libmcrypt-devel libpng-devel openssl-devel t1lib-devel libxslt-devel xsltproc }},
    [ "debian", "ubuntu" ] =>
        {"default" => %w{ libbz2-dev libc-client2007e-dev libcurl4-gnutls-dev libfreetype6-dev libgmp3-dev libjpeg62-dev libkrb5-dev libmcrypt-dev libpng12-dev libssl-dev libt1-dev libxslt1-dev xsltproc }},
    "default" => %w{ libbz2-dev libc-client2007e-dev libcurl4-gnutls-dev libfreetype6-dev libgmp3-dev libjpeg62-dev libkrb5-dev libmcrypt-dev libpng12-dev libssl-dev libt1-dev libxslt1-dev xsltproc }
  )

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

version = node['swfmill']['version']

remote_file "#{Chef::Config[:file_cache_path]}/swfmill-#{version}.tar.gz" do
  source "#{node['swfmill']['url']}/swfmill-#{version}.tar.gz"
#  checksum node['swfmill']['checksum']
  mode "0644"
  not_if "which swfmill"
end

bash "build swfmill" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
  tar -zxvf swfmill-#{version}.tar.gz
  (cd swfmill-#{version} && ./configure #{configure_options})
  (cd swfmill-#{version} && make && make install)
  EOF
  not_if "which swfmill"
end

# if 0.3.1
#  (cd swfmill-#{version}/src/xslt && wget http://bazaar.launchpad.net/~djcsdy/swfmill/trunk/download/head:/srcxsltxslt.h-20090609152137-53i91h057e1vr5oe-125/xslt.h)

