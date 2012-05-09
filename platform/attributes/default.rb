default[:system][:sysctl][:conf]['net.ipv4.tcp_tw_reuse'] = '1'
default[:system][:sysctl][:conf]['net.ipv4.tcp_fin_timeout'] = '15'
default[:system][:sysctl][:conf]['net.ipv4.tcp_keepalive_time'] = '20'
default[:system][:sysctl][:conf]['net.ipv4.tcp_keepalive_probes'] = '4'
default[:system][:sysctl][:conf]['net.ipv4.tcp_keepalive_intvl'] = '5'
default[:system][:sysctl][:conf]['net.core.somaxconn'] = '2048'

