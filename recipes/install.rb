case node[:platform_family]
when "debian"
  bash "apt_update_install_build_tools" do
    user "root"
    code <<-EOF
   apt-get update -y
#   DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
   apt-get install build-essential -y
   apt-get install libssl-dev -y
 EOF
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

include_recipe "java"

node.default['ark']['apache_mirror'] = node[:flume][:download_url]
node.default['ark']['prefix_root'] = node[:flume][:base_dir]

user node[:flume][:user] do
  action :create
  system true
  shell "/bin/bash"
end

ark 'flume' do
   url node[:flume][:download_url]
   version node[:flume][:version]
   path "/usr/local/"
   home_dir node[:flume][:home_dir] 
#   checksum  ''
   append_env_path true
   owner node[:flume][:user]
end

directory node[:flume][:conf_dir] do
  owner node[:flume][:user]
  group node[:flume][:user]
  mode "750"
  action :create
  recursive true
end


template "#{node[:flume][:conf_dir]}/flume-env.sh" do
  source "flume-env.sh.erb"
  owner "root"
  group "root"
  mode 0755
end

 template "/etc/default/flume-ng-agent" do
   source "flume-ng-agent.erb"
   owner "root"
   group "root"
   mode 0755
 end


# Create flume home_dir
link node[:flume][:home_dir] do
  owner node[:flume][:user]
  group node[:flume][:group]
  to node[:flume][:version_dir]
end

