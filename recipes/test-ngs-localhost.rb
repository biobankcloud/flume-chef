

flume_test "fastq" do
  owner "#{node[:flume][:dest_project]}_#{node[:flume][:hdfs][:user]}"
  group "#{node[:flume][:dest_project]}_#{node[:flume][:dest_dataset]}"
  dest_dir "/projects/#{node[:flume][:dest_project]}/#{node[:flume][:dest_dataset]}"
  action :local_create
end
