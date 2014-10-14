node.default[:flume][:role] = "hdfs"
include_recipe "flume::default"

log_file = "#{node[:flume][:log_dir]}/hdfs/flume-#{node['hostname']}.log"

hdfs_ip = private_recipe_ip('flume', 'hdfs')
nn_ip = private_recipe_ip('hadoop', 'nn')

template "#{node[:flume][:conf_dir]}/flume-hdfs.conf" do
  source "flume-hdfs.conf.erb"
  owner node[:flume][:user]
  group node[:flume][:group]
  mode "0750"
  variables({
              :log_file => :log_file,
              :hdfs_ip => hdfs_ip,
              :nn_addr => "#{nn_ip}:#{node[:hadoop][:nn][:port]}"
            })
end

ngs_ip = private_recipe_ip('flume', 'ngs')
template "#{node[:flume][:home_dir]}/bin/flume-start.sh" do
  source "flume-start.sh.erb"
  owner node[:flume][:user]
  group node[:flume][:group]
  mode "0750"
  variables({
              :log_file => :log_file,
              :conf_file => "#{node[:flume][:conf_dir]}/flume-hdfs.conf",
              :name => node[:flume][:cluster_name],
              :hdfs_ip => hdfs_ip,
              :nn_addr => "#{nn_ip}:#{node[:hadoop][:nn][:port]}"
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


