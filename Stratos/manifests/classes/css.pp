class stratos::css ( $version, 
		   $offset=0, 
		   $tribes_port=4000, 
		   $config_db=governance, 
		   $maintenance_mode=true, 
		   $sub_cluster_domain=mgt,
		   $css_id=node0,
		   $owner=root,
		   $group=root,
		   $target="/mnt" ) {
	
	$deployment_code	= "css"

	$stratos_version 	= $version
	$service_code 		= "css"
	$carbon_home		= "${target}/wso2${service_code}-${stratos_version}"

        $service_templates      = ["conf/registry.xml","conf/carbon.xml", "conf/etc/cassandra-component.xml","conf/etc/cassandra-auth.xml",
				   "conf/log4j.properties","conf/etc/cassandra.yaml","conf/etc/cluster-monitor-config.xml"]
        $common_templates       = ["conf/datasources/master-datasources.xml","conf/identity.xml","conf/user-mgt.xml"]



	tag ($service_code)

        define push_templates ( $directory, $target ) {
        
                file { "${target}/repository/${name}":
                        owner   => $owner,
                        group   => $group,
                        mode    => 755,
                        content => template("${directory}/${name}.erb"),
                        ensure  => present,
                }
        }

	clean { $deployment_code:
		mode		=> $maintenance_mode,
                target          => $carbon_home,
	}

	initialize { $deployment_code:
		repo		=> $package_repo,
		version         => $stratos_version,
		mode		=> $maintenance_mode,
		service		=> "css",
		local_dir       => $local_package_dir,
		owner		=> $owner,
		target   	=> $target,
		require		=> Stratos::Clean[$deployment_code],
	}

	deploy { $deployment_code:
		service		=> $service_code,
		security	=> "true",
		owner		=> $owner,
		group		=> $group,
		target		=> $carbon_home,
		require		=> Stratos::Initialize[$deployment_code],
	}

	push_templates { 
		$service_templates: 
		target		=> $carbon_home,
		directory 	=> $service_code,
		require 	=> Stratos::Deploy[$deployment_code];

		$common_templates:
		target          => $carbon_home,
                directory       => "commons",
		require 	=> Stratos::Deploy[$deployment_code],
	}
	
#	if $sub_cluster_domain == "worker" {
#               create_worker { $deployment_code:
#                       target  => $carbon_home,
#                       require => Stratos::Deploy[$deployment_code],
#               }
#	}

	start { $deployment_code:
		owner		=> $owner,
                target          => $carbon_home,
		require		=> [ Stratos::Initialize[$deployment_code],
				     Stratos::Deploy[$deployment_code],
				     Push_templates[$service_templates],
				     Push_templates[$common_templates], 
				   ],
	}
}

