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
  owner "#{node[:flume][:project]}_#{node[:flume][:hdfs][:user]}"
  group "#{node[:flume][:project]}_#{node[:flume][:dataset]}"
  dest_dir "/projects/#{node[:flume][:project]}/#{node[:flume][:dataset]}"
  action :local_create
end

d="/projects/#{node[:flume][:project]}/#{node[:flume][:dataset]}"
   hadoop_hdfs_directory "#{d}" do
    action :create_as_superuser
    owner node[:flume][:ngs_user]
    group 
    mode "1777"
    not_if ". #{node[:hadoop][:home]}/sbin/set-env.sh && #{node[:hadoop][:home]}/bin/hdfs dfs -test -d #{d}"
   end
