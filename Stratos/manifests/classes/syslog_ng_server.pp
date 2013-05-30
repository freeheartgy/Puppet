class syslog_ng_server ( $log_node, $log_port=5140 ) {
	
	package { "syslog-ng":
                ensure => installed,
        }

        service { "syslog-ng":
                ensure    => running,
                enable    => true,
                subscribe => File["/etc/syslog-ng/syslog-ng.conf"],
                require   => Package["syslog-ng"],
        }

        file { "/etc/syslog-ng/syslog-ng.conf":
                ensure  => present,
                content => template("syslog_ng/syslog_ng_server.conf.erb"),
                require => Package["syslog-ng"],
                notify  => Service["syslog-ng"],
        }
	
	exec { "$log_dir":
		path	=> ['/bin', '/usr/bin'],
		command	=> "mkdir -p $log_dir",
		unless	=> "test -d $log_dir",
	}
	
	exec { "$access_log_dir":
		path	=> ['/bin', '/usr/bin'],
		command	=> "mkdir -p $access_log_dir",
		unless	=> "test -d $access_log_dir",
	}
}
