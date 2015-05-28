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

for d in %w{ /projects/#{node[:flume][:dest_project]}_#{node[:flume][:dest_dataset]} }
   Chef::Log.info "Creating hdfs directory: #{d}"
   hadoop_hdfs_directory d do
    action :create_as_superuser
    owner node[:flume][:ngs_user]
    group 
    mode "1777"
    not_if ". #{node[:hadoop][:home]}/sbin/set-env.sh && #{node[:hadoop][:home]}/bin/hdfs dfs -test -d #{d}"
   end
end



