action :local_create do
  Chef::Log.info "Copying data into hdfs using flume from: #{@new_resource.source_dir}"

  directory "#{new_resource.source_dir}" do
    owner node[:flume][:user]
    group node[:flume][:group]
    mode "0755"
    recursive true
    action :create
  end



  #
  # Flume spooling directory expects an immutable file to be added to the spooling directory
  # Here we create the file in the /tmp dir, and then mv it to the spooling directory.
  #
  bash "mk-dir-#{new_resource.source_dir}" do
    user node[:flume][:user]
    group node[:flume][:group]
    code <<-EOF
     set -e
  for i in {1..#{new_resource.num_test_files}}; do 
   if [ ! -f #{new_resource.source_dir}/ngs$i.fastq ] ; then
    touch /tmp/bin$i.fastq
   # generates files using random number generator in linux
    dd if=/dev/urandom bs=1024 count=#{new_resource.test_file_size_mb} of=#{new_resource.source_dir}/bin$i.fastq
    base64 < /tmp/bin$i.fastq > #{new_resource.source_dir}/ngs$i.fastq
   fi
  done

  EOF
  end

end

action :remote_create do

end
