class ganglia {

	file { "/etc/ganglia/gmond.conf":
        	owner   => root,
        	group   => root,
        	mode    => 644,
        	source	=> "puppet:///ganglia/gmond.conf",
    	}

	exec { "restarting_ganglia_gmond":
		command	=> "/etc/init.d/ganglia-monitor restart",
		require	=> File["/etc/ganglia/gmond.conf"],
	}
}
