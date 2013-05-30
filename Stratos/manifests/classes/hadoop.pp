class hadoop($namenode = 0,$first_run = 0){

	$target = "/mnt"

	# root directory of hadoop_data and hadoop_tmp
	$hadoop_base = "/mnt"
	$hadoop_package = "hadoop-1.0.4"
	$hadoop_home = "${hadoop_base}/${hadoop_package}"
	$hadoop_user = "kurumba"
	$hadoop_group = "kurumba"
	$hadoop_heapsize = "1024"
	$dfs_replication = "1"
	
	exec {  "creating_target_for_${name}":
		path            => ["/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"],
		command         => "mkdir -p ${target}";

		"creating_local_package_repo_for_${name}":
		path            => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/java/bin/",
		unless          => "test -d ${local_package_dir}",
		command         => "mkdir -p ${local_package_dir}";

		"downloading_${hadoop_package}.tar.gz_for_${name}":
		path            => ["/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"],
		cwd             => $local_package_dir,
		unless          => "test -f ${local_package_dir}/${hadoop_package}.tar.gz",
		command         => "wget -q ${package_repo}/${hadoop_package}.tar.gz",
		logoutput       => "on_failure",
		creates         => "${local_package_dir}/${hadoop_package}.tar.gz",
		timeout         => 0,
		require         => Exec["creating_local_package_repo_for_${name}",
					"creating_target_for_${name}"];

		"extracting_${hadoop_package}_for_${name}":
		path            => ["/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"],
		cwd             => $target,
		unless          => "test -d ${target}/${hadoop_package}.tar.gz",
		command         => "tar xvfz ${local_package_dir}/${hadoop_package}.tar.gz",
		logoutput       => "on_failure",
		creates         => "${target}/${hadoop_package}/conf",
		timeout         => 0,
		require         => Exec["downloading_${hadoop_package}.tar.gz_for_${name}"];

		"changing_ownership_${hadoop_package}_${name}":
		path            => ["/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"],
		command         => "chown -R ${hadoop_user}:${hadoop_group} ${hadoop_home}",
		require         => Exec["extracting_${hadoop_package}_for_${name}"];
	}

	file {  "${target}/hadoop":
		ensure => "link",
		target => "/mnt/${hadoop_package}",
		require         => Exec["extracting_${hadoop_package}_for_${name}"];

		"${target}/hadoop_tmp":
		ensure => "directory",
		owner => "${hadoop_user}",
		group => "${hadoop_group}";

		"${target}/hadoop_data":
		ensure => "directory",
		owner => "${hadoop_user}",
		group => "${hadoop_group}";

		"${target}/hadoop_data/dfs":
		ensure => "directory",
		owner => "${hadoop_user}",
		group => "${hadoop_group}";

		"/home/${hadoop_user}/.ssh/authorized_keys":
		ensure => present,
		source => "puppet:///hadoop_ssh/authorized_keys";
		
		"${hadoop_home}/conf/core-site.xml":
		content => template("hadoop/conf/core-site.xml.erb"),
		ensure  => present,
		require => Exec["extracting_${hadoop_package}_for_${name}"],
		owner => "${hadoop_user}",
		group => "${hadoop_group}";
		
		"${hadoop_home}/conf/hadoop-env.sh":
		content => template("hadoop/conf/hadoop-env.sh.erb"),
		ensure  => present,
		require => Exec["extracting_${hadoop_package}_for_${name}"],
		owner => "${hadoop_user}",
		group => "${hadoop_group}";
		
		"${hadoop_home}/conf/hadoop-policy.xml":
		content => template("hadoop/conf/hadoop-policy.xml.erb"),
		ensure  => present,
		require => Exec["extracting_${hadoop_package}_for_${name}"],
		owner => "${hadoop_user}",
		group => "${hadoop_group}";
		
		"${hadoop_home}/conf/hdfs-site.xml":
		content => template("hadoop/conf/hdfs-site.xml.erb"),
		ensure  => present,
		require => Exec["extracting_${hadoop_package}_for_${name}"],
		owner => "${hadoop_user}",
		group => "${hadoop_group}";

		"${hadoop_home}/conf/mapred-site.xml":
		content => template("hadoop/conf/mapred-site.xml.erb"),
		ensure  => present,
		require => Exec["extracting_${hadoop_package}_for_${name}"],
		owner => "${hadoop_user}",
		group => "${hadoop_group}";
	}

	# Namenode & Datanode master,slave files	
	if $namenode == '1'{
		file {
		"${hadoop_home}/conf/masters":
                content => template("hadoop/conf/masters.nn.erb"),
                ensure  => present,
		require => Exec["extracting_${hadoop_package}_for_${name}"],
		owner => "${hadoop_user}",
		group => "${hadoop_group}";

                "${hadoop_home}/conf/slaves":
                content => template("hadoop/conf/slaves.nn.erb"),
		ensure => present,
		require => Exec["extracting_${hadoop_package}_for_${name}"],
		owner => "${hadoop_user}",
		group => "${hadoop_group}";
		}

		#Format the namenode if this is the first run
		if $first_run == '1'{
			exec { "formating_${name}_namenode":
				user            => $hadoop_user,
				path            => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/java/bin/",
				command         => "${hadoop_home}/bin/hadoop namenode -format";

#				"strating_${name}_namenode":
#				user            => $hadoop_user,
#				path            => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/java/bin/",
#				command         => "${hadoop_home}/bin/start-all.sh";
#				require		=> Exec["formating_${name}_namenode"];
			}
		}
	}
	else {

		file {
		"${hadoop_home}/conf/masters":
                content => template("hadoop/conf/masters.s.erb"),
                ensure  => present,
		require => Exec["extracting_${hadoop_package}_for_${name}"],
		owner => "${hadoop_user}",
		group => "${hadoop_group}";

                "${hadoop_home}/conf/slaves":
                content => template("hadoop/conf/slaves.s.erb"),
		ensure => present,
		require => Exec["extracting_${hadoop_package}_for_${name}"],
		owner => "${hadoop_user}",
		group => "${hadoop_group}";
		}
	}


#	#Starting Hadoop
#	if $namenode == '1'{
#		exec { "strating_${name}_namenode":
#			user            => $hadoop_user,
#			path            => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/java/bin/",
#			command         => "${hadoop_home}/bin/start-all.sh";
#		}
#	}
#	else {
#		exec { "strating_${name}_datanode":
#			user            => $hadoop_user,
#			path            => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/java/bin/",
#			command         => "${hadoop_home}/bin/hadoop datanode";
#	
#			"strating_${name}_tasktracker":
#			user            => $hadoop_user,
#			path            => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/java/bin/",
#			command         => "${hadoop_home}/bin/hadoop tasktracker";
#		}
#	}



}
