role = node[:flume][:role]

# service "flume-#{role}" do
#     provider Chef::Provider::Service::Upstart
#     supports :status => true, :start => true, :stop => true
# end


template "/etc/init.d/flume-#{role}" do
  source "flume-init.erb"
  owner node[:flume][:user]
  group node[:flume][:user]
  mode "0751"
  variables({
              :role => role
            })
#  notifies :enable, "service[flume-#{role}]"
#  notifies :start, "service[flume-#{role}]"
end


template "/etc/init/flume-#{role}.conf" do
  source "flume-upstart.conf.erb"
  owner node[:flume][:user]
  group node[:flume][:user]
  mode "0751"
  variables({
              :role => role
            })
#  notifies :enable, "service[flume-#{role}]"
#  notifies :start, "service[flume-#{role}]"
end

template "#{node[:flume][:home_dir]}/bin/flume-collectd.py" do
  source "flume-collectd.py.erb"
  owner node[:flume][:user]
  group node[:flume][:group]
  mode 0751
end

log_file = "#{node[:flume][:logs_dir]}/flume-#{node[:flume][:user]}-#{role}-#{node['hostname']}.log"

if node[:kagent][:enabled].eql? "true"
  kagent_config "flume-#{role}" do
    service "node[:flume][:cluster_name]"
    start_script "#{node[:flume][:home]}/bin/root-start-flume-#{role}.sh"
    stop_script "#{node[:flume][:home]}/bin/root-stop-flume-#{role}.sh"
    init_script ""
    config_file "#{node[:flume][:conf_dir]}/flume-#{role}.cnf"
    log_file log_file
    pid_file "#{node[:flume][:logs_dir]}/flume-#{node[:flume][:user]}-#{role}.pid"
    web_port node[:flume][:http_port]
  end
end


template "#{node[:flume][:home_dir]}/bin/root-start-flume-#{role}.sh" do
  source "root-start-flume-#{role}.sh.erb"
  owner "root"
  mode "0751"
end

template "#{node[:flume][:home_dir]}/bin/root-stop-flume-#{role}.sh" do
  source "root-start-flume-#{role}.sh.erb"
  owner "root"
  mode "0751"
end
