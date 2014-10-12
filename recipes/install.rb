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


template "/etc/flume/conf/flume-env.sh" do
  source "flume-env.sh.erb"
  owner "root"
  group "root"
  mode 0755
end

# template "/etc/default/flume-ng-agent" do
#   source "flume-ng-agent.erb"
#   owner "root"
#   group "root"
#   mode 0755
# end

# template "/etc/flume/conf/flume.conf" do
#   source "flume.conf.erb"
#   owner "root"
#   group "root"
#   mode 0755
# end

script "Setting up environment" do
  interpreter "bash"
  user "root"
  code <<-EOH
  sudo -u hdfs hadoop fs -mkdir /user/flume
  sudo -u hdfs hadoop fs -chown flume:flume /user/flume
  sudo -u hdfs hadoop fs -chmod -R 770 /user/flume
  EOH
  not_if { "hadoop dfs -ls /user | egrep flume" }
end

template "flume" do
  path "/etc/init/flume.conf"
  source "flume-init.conf.erb"
  owner "root"
  group "root"
  mode "0755"
  notifies :enable, "service[flume]"
  notifies :start, "service[flume]"
end

template "start-flume.sh" do
  path "/usr/local/bin/start-flume.sh"
  source "flume-start.sh.erb"
  owner "root"
  group "root"
  mode "0755"
end

service "flume" do
    provider Chef::Provider::Service::Upstart
    supports :status => true, :restart => true
    action [:enable, :start]
end

# Create flume home_dir
link node[:flume][:home_dir] do
  owner node[:flume][:user]
  group node[:flume][:group]
  to node[:flume][:version_dir]
end
