

flume_test "fastq" do
  owner "#{node[:flume][:project]}_#{node[:flume][:hdfs][:user]}"
  group "#{node[:flume][:project]}_#{node[:flume][:dataset]}"
  dest_dir "/projects/#{node[:flume][:project]}/#{node[:flume][:dataset]}"
  action :local_create
end
