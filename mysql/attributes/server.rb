#
# Cookbook Name:: mysql
# Attributes:: server
#
# Copyright 2008-2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['mysql']['bind_address']               = attribute?('cloud') ? cloud['local_ipv4'] : ipaddress
default['mysql']['data_dir']                   = "/ebs/mysql"
default['mysql']['server_root_password']       = "admin"
default['mysql']['version']                    = "5.5.23" # use to source code compile only
default['mysql']['character']                  = "utf8"
default['mysql']['replication']                = false
default['mysql']['backup']                     = false

case node["platform"]
when "centos", "redhat", "fedora", "suse"
  set['mysql']['conf_dir']                    = '/etc'
  set['mysql']['socket']                      = "/var/lib/mysql/mysql.sock"
  set['mysql']['socket_dir']                  = "/var/lib/mysql"
  set['mysql']['pid_file']                    = "/var/run/mysqld/mysqld.pid"
  set['mysql']['old_passwords']               = 1
  set['mysql']['log_dir']                     = "/ebs/log/mysql/"
else
  set['mysql']['conf_dir']                    = '/etc/mysql'
  set['mysql']['socket']                      = "/var/run/mysqld/mysqld.sock"
  set['mysql']['socket_dir']                  = "/var/run/mysqld"
  set['mysql']['pid_file']                    = "/var/run/mysqld/mysqld.pid"
  set['mysql']['old_passwords']               = 0
  set['mysql']['log_dir']                     = "/ebs/log/mysql/"
end

if attribute?('ec2')
  default['mysql']['ec2_path']    = "/mnt/mysql"
  default['mysql']['ebs_vol_dev'] = "/dev/sdk"
  default['mysql']['ebs_vol_size'] = 100
end

default['mysql']['allow_remote_root']               = false
default['mysql']['tunable']['back_log']             = "1024"
default['mysql']['tunable']['key_buffer']           = "256M"
default['mysql']['tunable']['max_allowed_packet']   = "16M"
default['mysql']['tunable']['max_connections']      = "1000"
default['mysql']['tunable']['max_heap_table_size']  = "32M"
default['mysql']['tunable']['myisam_recover']       = "BACKUP"
default['mysql']['tunable']['net_read_timeout']     = "2"
default['mysql']['tunable']['net_write_timeout']    = "2"
default['mysql']['tunable']['table_cache']          = "128"
default['mysql']['tunable']['table_open_cache']     = "128"
default['mysql']['tunable']['thread_cache']         = "128"
default['mysql']['tunable']['thread_cache_size']    = 8
default['mysql']['tunable']['thread_concurrency']   = 10
default['mysql']['tunable']['thread_stack']         = "256K"
default['mysql']['tunable']['wait_timeout']         = "180"

default['mysql']['tunable']['query_cache_limit']    = "1M"
default['mysql']['tunable']['query_cache_size']     = "16M"

default['mysql']['tunable']['log_slow_queries']     = "/ebs/log/mysql/slow.log"
default['mysql']['tunable']['long_query_time']      = 1

default['mysql']['tunable']['expire_logs_days']     = 10
default['mysql']['tunable']['max_binlog_size']      = "100M"

default['mysql']['tunable']['innodb_buffer_pool_size']  = "256M" # Todo:全体の10/8のサイズを自動的に取得
default['mysql']['tunable']['innodb_lock_wait_timeout'] = "2"
default['mysql']['tunable']['innodb_thread_concurrency'] = "16"

