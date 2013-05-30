class keepalived {

	package { "curl":
                ensure => installed,
		require => Class ["apt"],
        }	
	
	package { "keepalived":
                ensure => installed,
		require => Class ["apt"],
        }	
	
	service { "keepalived":
                ensure    => running,
                enable    => true,
                subscribe => File["/etc/keepalived/keepalived.conf"],
                require   => Package["keepalived"],
        }

	file { "/opt/bin/check_load_balancer.sh":
		owner => root,
		group => root,
		mode => 755,
		source => "puppet:///keepalived/bin/check_load_balancer.sh",
		require => [ Package["keepalived"], Package["curl"] ],
	}

	file { "/etc/keepalived/keepalived.conf":
		owner => root,
		group => root,
		content => template("keepalived/keepalived.conf.erb"),
		ensure	=> present,
		notify => [ Service["keepalived"], File["/opt/bin/check_load_balancer.sh"] ],
	}
}
