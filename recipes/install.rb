case node[:platform_family]
when "debian"
#   bash "apt_update_install_build_tools" do
#     user "root"
#     code <<-EOF
#    apt-get update -y
# #   DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
#    apt-get install build-essential -y
#    apt-get install libssl-dev -y
#  EOF
#   end
  package "libssl-dev" do
    action :install
  end

when "rhel"
# gcc, gcc-c++, kernel-devel are the equivalent of "build-essential" from apt.
  package "gcc" do
    action :install
  end
  package "gcc-c++" do
    action :install
  end
  package "kernel-devel" do
    action :install
  end
  package "openssl-devel" do
    action :install
  end
end

node.default['java']['jdk_version'] = 7
node.default['java']['install_flavor'] = "openjdk"
include_recipe "java"

node.default['ark']['apache_mirror'] = node[:flume][:download_url]
node.default['ark']['prefix_root'] = node[:flume][:base_dir]

user node[:flume][:user] do
  supports :manage_home => true
  action :create
  home "/home/#{node[:flume][:user]}"
  system true
  shell "/bin/bash"
  not_if "getent passwd #{node[:flume]['user']}"
end

ark 'flume' do
   url node[:flume][:download_url]
   version node[:flume][:version]
   path node[:flume][:base_dir]
   home_dir node[:flume][:home_dir] 
#   checksum  ''
   append_env_path true
   owner node[:flume][:user]
end


for d in [node[:flume][:conf_dir],node[:flume][:log_dir],node[:flume][:pid_dir],node[:flume][:ngs_dir]]
  directory d do
    owner node[:flume][:user]
    group node[:flume][:user]
    mode "750"
    action :create
    recursive true
  end
end

 template "#{node[:flume][:conf_dir]}/flume-env.sh" do
   source "flume-env.sh.erb"
   owner node[:flume][:user]
   group node[:flume][:user]
   mode 0750
 end


 template "#{node[:flume][:conf_dir]}/log4j.properties" do
   source "log4j.properties.erb"
   owner node[:flume][:user]
   group node[:flume][:user]
   mode 0750
 end


# Create flume home_dir
link node[:flume][:home_dir] do
  owner node[:flume][:user]
  group node[:flume][:group]
  to node[:flume][:version_dir]
end

magic_shell_environment 'HADOOP_HOME' do 
    value node[:hadoop][:home]
end 

magic_shell_environment 'HADOOP_CONF_DIR' do 
    value node[:hadoop][:conf_dir]
end 


magic_shell_environment 'PATH' do 
    value "$PATH:" + node[:hadoop][:home] + '/bin'
end 
