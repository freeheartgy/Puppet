class nrpe {

	file { "/etc/nagios/nrpe.cfg":
        	owner   => root,
        	group   => root,
        	mode    => 644,
        	source	=> "puppet:///nrpe/nrpe.cfg",
    	}

	exec { "restarting_nagios_nrpe":
		command	=> "/etc/init.d/nagios-nrpe-server restart",
		require	=> File["/etc/nagios/nrpe.cfg"];
	}
}
