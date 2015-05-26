maintainer       "Jim Dowling"
maintainer_email "jdowling@kth.se"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))
name             "flume"

description      "Flume: reliable decoupled shipment of logs and data to HDFS and other destinations."

depends          "java"
#depends          "thrift"
depends          "ark"
#depends          "kagent"
depends          "hadoop"

recipe           "flume::install",                     "Base configuration for flume"
# recipe           "flume::master",                      "Configures Flume Master, installs and starts service"
# recipe           "flume::make_dirs",                   "Ties directories to available volumes"
# recipe           "flume::install_from_release",        "Install flume using git release"
# recipe           "flume::install_from_package",        "Install flume using package manager"
# recipe           "flume::agent",                       "Configures Flume Agent, installs and starts service"
# recipe           "flume::plugin-hbase_sink",           "Hbase Sink Plugin"
# recipe           "flume::plugin-jruby",                "Jruby Plugin"
# recipe           "flume::test_flow",                   "Test Flow"
# recipe           "flume::test_s3_source",              "Test S3 source"
# recipe           "flume::config_files",                "Finalizes the config, writes out the config files"

%w[ debian ubuntu centos ].each do |os|
  supports os
end

attribute "flume/cluster_name",
          :description           => "The name of the cluster to participate with (masters and zookeepers...)",
          :type => 'string',
          :required => "optional"

attribute "flume/plugins_str",
          :description           => "Hash for plugin configuration. If you have a particular plugin to configure, you can also configure the classpath and the classes to include in the configuration file with attributes in the following forms:\nnode[:flume][:plugin][{plugin_name}][:classes]\nnode[:flume][:plugin][{plugin_name}][:classpath]\nnode[:flume][:plugin][{plugin_name}][:java_opts]",
          :type => 'string',
          :required => "optional"



attribute "flume/classes",
          :description           => "classes to include as plugins",
          :type => 'string',
          :required => "optional"

attribute "flume/classpath",
          :description           => "list of directories and jars to add to the FLUME_CLASSPATH",
          :type => 'string',
          :required => "optional"


attribute "flume/java_opts",
          :description           => "list of command line parameters to add to the jvm",
          :type => 'string',
          :required => "optional"

attribute "flume/collector",
          :description           => "Format of node's logs. output_format -- Controls what format the node writes logs (using collectorSink):\n * avro - Avro Native file format. Default currently is uncompressed.\n * avrodata - Binary encoded data written in the avro binary format.\n * avrojson - JSON encoded data generated by avro.\n * default - a debugging format.\n * json - JSON encoded data.\n * log4j - a log4j pattern similar to that used by CDH output pattern.\n * raw - Event body only. This is most similar to copying a file but does not preserve any uniqifying metadata like host/timestamp/nanos.\n * syslog - a syslog like text output format.\n\ncodec -- Controls what kind of compression the collector will use when writing a file.\nwhether or not collected logs are gzipped before writing\nthem to their final resting place (using collectorSink)\n * GZipCodec\n * BZip2Codec\n",
          :type => 'string',
          :required => "optional"



attribute "flume/data_dir",
          :description           => "Directory for local in-transit files",
          :type => 'string',
          :required => "optional"

attribute "flume/home_dir",
          :description           => "Flume home directory",
          :type => 'string',
          :required => "optional"


attribute "flume/conf_dir",
          :description           => "Flume Configuration directory",
          :type => 'string',
          :required => "optional"

attribute "flume/log_dir",
          :description           => "Flume Logs Directory",
          :type => 'string',
          :required => "optional"

attribute "flume/pid_dir",
          :description           => "Flume Pid file Directory",
          :type => 'string',
          :required => "optional"


attribute "flume/master/external_zookeeper",
          :description           => "False to use flume's zookeeper. True to attach to an external zookeeper. By default, flume installs its own zookeeper instance.  With :external_zookeeper to \"true\", the recipe will work out which machines are in the zookeeper quorum based on cluster membership; modify node[:discovers][:zookeeper_server] to have it use an external cluster",
          :type => 'string',
          :required => "optional"

attribute "flume/master/zookeeper_port",
          :description           => "port to talk to zookeeper on (for external zookeeper)",
          :type => 'string',
          :required => "optional"

attribute "flume/master/run_state",
          :description           => "Master run state (stop)",
          :type => 'string',
          :required => "optional"

attribute "flume/node/run_state",
          :description           => "Run state (start)",
          :type => 'string',
          :required => "optional"

attribute "flume/dest_project",
          :description           => "Name of HopsWorks project to copy flume data into",
          :type => 'string',
          :required => "optional"

attribute "flume/dest_dataset",
          :description           => "Name of HopsWorks dataset to copy flume data into",
          :type => 'string',
          :required => "optional"

attribute "flume/num_test_files",
          :description           => "Number of test files to copy to the HopsWorks project/dataset",
          :type => 'string',
          :required => "optional"

attribute "flume/hdfs/user",
          :description           => "HDFS Username to use when copying to the HopsWorks project/dataset",
          :type => 'string',
          :required => "optional"

