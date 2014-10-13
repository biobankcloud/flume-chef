node.default[:flume][:role] = "ngs-agent"
include_recipe "default"

log_file = "#{node[:flume][:log_dir]}/#{role}/flume-#{node['hostname']}.log"

hdfs_ip = private_recipe_ip('flume', 'hdfs')
ngs_ip = private_recipe_ip('flume', 'ngs')

num_cpus = node['cpu']['total']
num_cpus = (num_cpus / 2) + 1

template "#{node[:flume][:conf_dir]}/flume-ngs.conf" do
  source "flume-ngs.conf.erb"
  owner "root"
  group "root"
  mode 0755
  variables({
              :log_file => :log_file,
              :hdfs_ip => hdfs_ip,
              :ngs_ip => ngs_ip,
              :num_cpus => num_cpus,
            })
end

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
            })
end
