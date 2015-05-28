actions :local_create, :remote_create

attribute :name, :kind_of => String, :name_attribute => true

attribute :source_dir, :kind_of => String, :default => "/tmp/ngs"

attribute :owner, :kind_of => String, :default => "hdfs"

attribute :group, :kind_of => String, :default => "hadoop"

attribute :dest_dir, :kind_of => String, :default => "/projects/test/ds"

attribute :num_test_files, :kind_of => Integer, :default => 1

attribute :test_file_size_mb, :kind_of => Integer, :default => 1

default_action :local_create
