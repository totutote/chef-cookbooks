# update the main channels
template "/etc/sysctl.conf" do
  source "sysctl.conf.erb"
end

sysconf_hash = node[:system][:sysctl][:conf]

sysconf_hash.map do |k, v|

  execute "sysctl" do
    command "sysctl -w #{k}=#{v}"
    action :run
  end

end

