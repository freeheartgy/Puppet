class syslog_ng_worker ( $services ) {
	
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
    		content => template("syslog_ng/syslog_ng_worker.conf.erb"),
    		require => Package["syslog-ng"],
    		notify  => Service["syslog-ng"],
  	}
}
