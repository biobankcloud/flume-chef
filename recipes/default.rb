role = node[:flume][:role]

if node[:hopagent][:enabled].eql? "true"
  hopagent_config "flume-#{role}" do
    service "node[:flume][:cluster_name]"
    start_script "#{node[:flume][:home]}/sbin/root-start-#{role}.sh"
    stop_script "#{node[:flume][:home]}/sbin/stop-#{role}.sh"
    init_script ""
    config_file "#{node[:flume][:conf_dir]}/flume-#{role}.cnf"
    log_file "#{node[:flume][:logs_dir]}/flume-#{node[:flume][:user]}-#{role}-#{node['hostname']}.log"
    pid_file "#{node[:flume][:logs_dir]}/flume-#{node[:flume][:user]}-#{role}.pid"
    web_port node[:flume][:http_port]
  end
end

service "flume" do
    provider Chef::Provider::Service::Upstart
    supports :status => true, :restart => true
    action [:enable, :start]
end

template "flume.conf" do
  path "/etc/init/flume.conf"
  source "flume-init.conf.erb"
  owner "root"
  group "root"
  mode "0755"
  variables({
              :role => role
            })
  notifies :enable, "service[flume]"
  notifies :start, "service[flume]"
end

template "#{node[:flume][:home_dir]}/bin/flume-collectd.py" do
  source "flume-collectd.py.erb"
  owner node[:flume][:user]
  group node[:flume][:group]
  mode 0755
end
