node.default[:flume][:role] = "hdfs-agent"
include_recipe "default"

log_file = "#{node[:flume][:log_dir]}/#{role}/flume-#{node['hostname']}.log"

nn_ip = private_recipe_ip('hadoop', 'nn')
template "#{node[:flume][:conf_dir]}/flume.conf" do
  source "flume.conf.erb"
  owner "root"
  group "root"
  mode 0755
  variables({
              :log_file => :log_file,
              :nn_addr => "#{nn_ip}:#{node[:hadoop][:nn][:port]}"
            })
end

ngs_ip = private_recipe_ip('flume', 'ngs')
template "flume-start.sh" do
  path "#{node[:flume][:home]}/bin/flume-start.sh"
  source "flume-start.sh.erb"
  owner "root"
  group "root"
  mode "0755"
  variables({
              :log_file => :log_file,
              :conf_file => "#{node[:flume][:conf_dir]}/#{role}.cnf",
              :name => node[:flume][:cluster_name],
              :ngs_ip => ngs_ip,
            })
end


script "Setting up environment" do
  interpreter "bash"
#  user node[:hdfs][:user]
  user "root"
  code <<-EOH
#  sudo -u hdfs hadoop fs -mkdir /user/node[:flume_hdfs][:user]
#  sudo -u hdfs hadoop fs -chown node[:flume_hdfs][:user]:node[:flume_hdfs][:user] /user/node[:flume_hdfs][:user]
#  sudo -u hdfs hadoop fs -chmod -R 770 /user/node[:flume_hdfs][:user]
  EOH
#  not_if { "hadoop dfs -ls /user | egrep node[:flume_hdfs][:user]" }
end
