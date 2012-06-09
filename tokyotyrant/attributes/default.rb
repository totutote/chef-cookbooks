#
# Cookbook Name:: tokyotyrant
# Attribute:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

case node["platform"]
when "centos", "redhat", "fedora"
  default['tokyotyrant']['conf_dir']      = '/etc'
  default['tokyotyrant']['ext_conf_dir']  = '/etc/php.d'
  default['tokyotyrant']['fpm_user']      = 'nobody'
  default['tokyotyrant']['fpm_group']     = 'nobody'
  default['tokyotyrant']['ext_dir']       = "/usr/#{lib_dir}/php/modules"
when "debian", "ubuntu"
  default['tokyotyrant']['apache_conf_dir']      = '/etc/php5/apache2'
  default['tokyotyrant']['conf_dir']      = '/etc/php5/cli'
  default['tokyotyrant']['ext_conf_dir']  = '/etc/php5/conf.d'
  default['tokyotyrant']['fpm_user']      = 'www-data'
  default['tokyotyrant']['fpm_group']     = 'www-data'
else
  default['tokyotyrant']['conf_dir']      = '/etc/php5/cli'
  default['tokyotyrant']['ext_conf_dir']  = '/etc/php5/conf.d'
  default['tokyotyrant']['fpm_user']      = 'www-data'
  default['tokyotyrant']['fpm_group']     = 'www-data'
end

default['tokyotyrant']['url'] = 'http://fallabs.com/tokyotyrant'
default['tokyotyrant']['version'] = '1.1.41'
default['tokyotyrant']['prefix_dir'] = '/usr/local'

default['tokyotyrant']['configure_options'] = %W{--prefix=#{tokyotyrant['prefix_dir']}}
