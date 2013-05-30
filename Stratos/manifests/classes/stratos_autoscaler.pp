class stratos_autoscaler ( $version, $maintenance_mode=true, $syslog=false ) inherits system_config {

	$stratos_version = $version
	$service_code = "autoscaler"
	$service_dir = "wso2$service_code-$stratos_version"	

	$kill_command = "kill -9 `cat /mnt/$server_ip/$service_dir/wso2carbon.pid`"	

	tag ("autoscaler")

	if $syslog == "true" {
                class {"syslog_ng_worker":
                        services => "autoscaler",
                        stage => "configure",
                }
        }
        else {
                notice("No syslog-ng-worker requested")
        }


	file { "/mnt/$server_ip/$service_dir/repository/conf/carbon.xml":
                owner   => root,
                group   => root,
                mode    => 755,
                content => template("autoscaler/carbon.xml.erb"),
                ensure  => present,
        	require => File["/mnt/$server_ip/$service_dir/"],
	}

	file { "/mnt/$server_ip/$service_dir/password":
                owner   => root,
                group   => root,
                mode    => 755,
                content => template("autoscaler/password.erb"),
                ensure  => present,
        	require => File["/mnt/$server_ip/$service_dir/"],
	}


        file { "/opt/bin/init.sh":
                ensure  => present,
                owner   => root,
                group   => root,
                mode    => 0755,
                content => template("init.sh.erb"),
                require => Exec["install_java"],
        }

	file { "/mnt/$server_ip/$service_dir/":
                owner   => root,
                group   => root,
                source  => ["puppet:///stratos_commons/patches/",
                	    "puppet:///stratos_commons/configs/",
			    "puppet:///stratos_${service_code}/patches/",
			    "puppet:///stratos_${service_code}/configs/"],
		sourceselect => all,
                ensure  => present,
		recurse	=> true,
                require => Exec["init_autoscaler"],
        }		

	file { "/mnt/$server_ip/$service_dir/bin/wso2server.sh":
                owner   => root,
                group   => root,
                mode    => 755,
                content => template("autoscaler/wso2server.sh.erb"),
                ensure  => present,
                require => File["/mnt/$server_ip/$service_dir/"],
        }

	exec { "remove_autoscaler_poop":
                path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/java/bin/",
                unless  => "test ! -d /mnt/$server_ip/$service_dir/repository",
                command => $maintenance_mode ? {
			   	"true" => "$kill_command ; /bin/echo Killed",
			   	"false" => "$kill_command ; rm -rf /mnt/$server_ip/$service_dir",
			   },
                require => File["/opt/bin/init.sh"],
        }

	exec { "init_autoscaler":
                command => $maintenance_mode ? {
				"true" => "/bin/echo In maintenance mode",
				"false" => "/opt/bin/init.sh $service_code",
			   },
		timeout	=> 0,
                require => Exec["remove_autoscaler_poop"],
        }

	exec { "start_$service_code":
                path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/java/bin/",
                command => "/mnt/$server_ip/$service_dir/bin/wso2server.sh > /dev/null &2>1",
                creates => "/mnt/$server_ip/$service_dir/repository/wso2carbon.log",
                require => File["/mnt/$server_ip/$service_dir/"],
        }
}

