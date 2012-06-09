#
# Cookbook Name:: tokyocabinet
# Attribute:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

case node["platform"]
when "centos", "redhat", "fedora"
  default['tokyocabinet']['conf_dir']      = '/etc'
  default['tokyocabinet']['ext_conf_dir']  = '/etc/php.d'
  default['tokyocabinet']['fpm_user']      = 'nobody'
  default['tokyocabinet']['fpm_group']     = 'nobody'
  default['tokyocabinet']['ext_dir']       = "/usr/#{lib_dir}/php/modules"
when "debian", "ubuntu"
  default['tokyocabinet']['apache_conf_dir']      = '/etc/php5/apache2'
  default['tokyocabinet']['conf_dir']      = '/etc/php5/cli'
  default['tokyocabinet']['ext_conf_dir']  = '/etc/php5/conf.d'
  default['tokyocabinet']['fpm_user']      = 'www-data'
  default['tokyocabinet']['fpm_group']     = 'www-data'
else
  default['tokyocabinet']['conf_dir']      = '/etc/php5/cli'
  default['tokyocabinet']['ext_conf_dir']  = '/etc/php5/conf.d'
  default['tokyocabinet']['fpm_user']      = 'www-data'
  default['tokyocabinet']['fpm_group']     = 'www-data'
end

default['tokyocabinet']['url'] = 'http://fallabs.com/tokyocabinet'
default['tokyocabinet']['version'] = '1.4.47'
default['tokyocabinet']['prefix_dir'] = '/usr/local'

default['tokyocabinet']['configure_options'] = %W{--prefix=#{tokyocabinet['prefix_dir']}
                                          }
