
directory node[:flume][:ngs_dir] do
  owner node[:flume][:user]
  group node[:flume][:group]
  mode "0755"
  recursive true
  action :create
end

template "#{node[:flume][:home_dir]}/bin/test-data.sh" do
  source "test-data.sh.erb"
  owner node[:flume][:user]
  group node[:flume][:group]
  mode "0755"
  variables({
              :file_size_kb => 64000,
              :num_files => 10,
            })
end
