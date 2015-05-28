node.default[:flume][:role] = "localhost"
include_recipe "flume::default"

log_file = "#{node[:flume][:log_dir]}/flume-ngs-localhost.log"

num_cpus = node['cpu']['total']
num_cpus = (num_cpus / 2) + 1

template "#{node[:flume][:conf_dir]}/flume-localhost.conf" do
  source "flume-localhost.conf.erb"
  owner node[:flume][:user]
  group node[:flume][:group]
  mode "0750"
  variables({
              :log_file => log_file,
              :num_cpus => num_cpus,
              :name => node[:flume][:cluster_name]
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

flume_test "fastq" do
  owner "#{node[:flume][:dest_project]}_#{node[:flume][:hdfs][:user]}"
  group "#{node[:flume][:dest_project]}_#{node[:flume][:dest_dataset]}"
  dest_dir "/projects/#{node[:flume][:dest_project]}/#{node[:flume][:dest_dataset]}"
  action :local_create
end
