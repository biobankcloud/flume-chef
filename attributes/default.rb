
#By default, flume plays as a part of the cluster the machine
#belongs to.
default[:flume][:cluster_name]        = "hops"

default[:flume][:version]             = "1.5.2"
default[:flume][:user]                = "flume"
default[:flume][:group]               = "flume"

default[:flume][:ngs_user]            = "flume"
default[:flume][:ngs_project]         = "flume"
default[:flume][:ngs_dir]             = "/var/ngs"

default[:flume][:download_url]        = "http://apache.mirrors.spacedump.net/flume/#{node[:flume][:version]}/apache-flume-#{node[:flume][:version]}-bin.tar.gz"

# Locations
#
default[:flume][:base_dir]            = "/usr/local"
default[:flume][:version_dir]         = "/usr/local/flume-#{node[:flume][:version]}"
default[:flume][:home_dir]            = "/usr/local/flume"
default[:flume][:conf_dir]            = "/etc/flume"
default[:flume][:pid_dir]             = "/var/run/flume"
default[:flume][:log_dir]             = "/var/log/flume"
default[:flume][:data_dir]            = "/var/lib/flume/db/flume"

default[:flume][:agent ][:file_limit] = 65536
default[:flume][:master][:file_limit] = 65536

default[:flume][:zk]                  = Mash.new
default[:flume][:collector]           = Mash.new

# these are set by the recipes
default[:flume][:exported_jars ]      = []
default[:flume][:exported_confs]      = []

# install_from_release
#default[:flume][:release_url]         = "https://github.com/downloads/biobankcloud/flume-chef/flume-chef-distribution-#{node[:flume][:version]}-SNAPSHOT-bin.tar.gz"

#
# Services
#

default[:flume][:master][:run_state]   = :stop
default[:flume][:agent ][:run_state]   = :start

default[:flume][:multi_agent][:count]  = 2
default[:flume][:multi_agent][:log_dir_prefix] = "/var/log/flume"

#
# Tunables
#

# By default, flume installs its own zookeeper instance.  With
# :external_zookeeper to "true", the recipe will work out which machines are in
# the zookeeper quorum based on cluster membership; modify
# node[:discovers][:zookeeper_server] to have it use an external cluster



default[:flume][:num_log_rotations]           = 5

default[:flume][:master][:external_zookeeper] = false
default[:flume][:master][:zookeeper_port]     = 2181

# If flume is not using the external_zookeeper, its internal zookeeper opens this port
default[:flume][:zookeeper][:port]            = 3181

default[:flume][:uopts]                       = ""

default[:flume][:plugins]                     = {}
default[:flume][:plugins_str]                 = ""

default[:flume][:jars][:jruby_jar_version]    = "1.0.0"

default[:flume][:ics_extensions_version]      = "0.0.2"

# classes to include as plugins
default[:flume][:classes]                     = []

# jars and dirs to put on FLUME_CLASSPATH
default[:flume][:classpath]                   = []

# pass in extra options to the java virtual machine
default[:flume][:java_opts]                   = []

# The maximum size (in bytes) allowed for an event.  Will not be set
# (Flume will use its default value) if set to nil here.
default[:flume][:max_event_size]              = nil

# Writes formatted data compressed in specified codec to
# dfs. Value are None, GzipCodec, DefaultCodec (deflate), BZip2Codec,
# or any other Codec Hadoop is aware of
default[:flume][:hdfs_output]                 = "None"

default[:flume][:http_port]                   = 3181

default[:flume][:hdfs_port]                   = 51091
default[:flume][:ngs_port]                    = 51090

# Possible values: ngs, hdfs, localhost
default[:flume][:role]                        = "ngs" 

default[:flume][:ngs_delete_policy]           = "immediate"


#
# Params for copying data to HopsWorks
#
default[:flume][:dest_project]                = ""

default[:flume][:dest_dataset]                = ""

default[:flume][:hdfs][:user]                 = "hdfs"

default[:flume][:num_test_files]              = 1000

default[:flume][:test_file_size_mb]           = 64

default[:kagent][:enabled]                    = "false"
