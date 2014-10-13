
directory node[:flume][:ngs_dir] do
  owner node[:flume][:user]
  group node[:flume][:group]
  mode "0755"
  recursive true
  action :create
end

template "test-data.sh" do
  path "#{node[:flume][:home]}/bin/test-data.sh"
  source "test-data.sh.erb"
  owner "root"
  group "root"
  mode "0755"
  variables({
              :file_size_kb => 64000,
              :num_files => 10,
            })
end
