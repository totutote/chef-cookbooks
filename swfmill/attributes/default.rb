#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: swfmill
# Attribute:: default
#
# Copyright 2011, Opscode, Inc.
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

lib_dir = kernel['machine'] =~ /x86_64/ ? 'lib64' : 'lib'

default['swfmill']['install_method'] = 'package'

default['swfmill']['url'] = 'http://swfmill.org/releases/'
default['swfmill']['version'] = '0.3.2'
#default['swfmill']['checksum'] = ''
default['swfmill']['prefix_dir'] = '/usr/local'

default['swfmill']['configure_options'] = %W{--prefix=#{swfmill['prefix_dir']}}
