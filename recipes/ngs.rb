node.default[:flume][:role] = "ngs"
include_recipe "flume::default"

log_file = "#{node[:flume][:log_dir]}/flume-ngs-#{node['hostname']}.log"

hdfs_ip = private_recipe_ip('flume', 'hdfs')
ngs_ip = private_recipe_ip('flume', 'ngs')

num_cpus = node['cpu']['total']
num_cpus = (num_cpus / 2) + 1

template "#{node[:flume][:conf_dir]}/flume-ngs.conf" do
  source "flume-ngs.conf.erb"
  owner node[:flume][:user]
  group node[:flume][:group]
  mode "0750"
  variables({
              :log_file => log_file,
              :hdfs_ip => hdfs_ip,
              :num_cpus => num_cpus,
            })
end

template "#{node[:flume][:home_dir]}/bin/flume-start.sh" do
  source "flume-start.sh.erb"
  owner node[:flume][:user]
  group node[:flume][:group]
  mode "0750"
  variables({
              :conf_file => "#{node[:flume][:conf_dir]}/flume.conf",
              :name => node[:flume][:cluster_name]
            })
end

# template "#{node[:flume][:home_dir]}/bin/flume-start.sh" do
#   source "flume-start.sh.erb"
#   owner node[:flume][:user]
#   group node[:flume][:group]
#   mode "0750"
#   variables({
#               :conf_file => "#{node[:flume][:conf_dir]}/flume-ngs.cnf",
#               :name => node[:flume][:cluster_name]
#             })
# end

