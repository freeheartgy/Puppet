class stratos::bam ( $version, 
		   $offset=0, 
		   $tribes_port=4000, 
		   $config_db=governance, 
		   $maintenance_mode=true, 
		   $depsync=false, 
		   $instance_type=analyzer, 
		   $sub_cluster_domain=mgt,
		   $owner=root,
		   $group=root,
		   $target="/mnt" ) {
	
	$deployment_code	= "monitor"

	$stratos_version 	= $version
	$service_code 		= "bam"
	$carbon_home		= "${target}/wso2${service_code}-${stratos_version}"

        $service_templates      =  $instance_type ? {
                                        "analyzer" =>    ["conf/registry.xml","conf/axis2/axis2.xml","conf/carbon.xml","conf/security/authenticators.xml",
				   			  "conf/etc/rss-config.xml","conf/etc/cassandra-component.xml",
							  "deployment/server/webapps/STRATOS_ROOT/index.html","conf/advanced/hive-site.xml",
							  "conf/etc/summarizer-config.xml", "conf/etc/tasks-config.xml", 
							  "conf/advanced/streamdefn.xml", "conf/etc/cassandra-auth.xml","conf/advanced/hive-rss-config.xml"],
                                        "receiver" =>    ["conf/registry.xml","conf/carbon.xml","conf/etc/rss-config.xml",
				   		          "conf/advanced/hive-site.xml","conf/etc/cassandra-auth.xml","conf/advanced/streamdefn.xml",
							  "conf/etc/cassandra-component.xml",],
                                  }

        $common_templates 	= ["conf/etc/cache.xml","conf/multitenancy/cloud-services-desc.xml","conf/datasources/master-datasources.xml",
				   "conf/identity.xml","conf/multitenancy/stratos.xml","conf/user-mgt.xml"]

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
		service		=> $service_code,
		local_dir       => $local_package_dir,
                owner           => $owner,
		target   	=> $target,
		require		=> Stratos::Clean[$deployment_code],
	}

	deploy { $deployment_code:
		service		=> $service_code,	
		security	=> "true",
                owner           => $owner,
                group           => $group,
		target		=> $carbon_home,
		require		=> Stratos::Initialize[$deployment_code],
	}
	
	file {	"${deployment_code}_deployment":
		path		=> "${carbon_home}/repository/deployment/", 
		ensure		=> present,
		owner		=> $owner,
		group		=> $group,
		source		=> $instance_type ? {
					"analyzer" => [ "puppet:///bam/analyzer/deployment" ],
				   	"receiver" => [ "puppet:///bam/receiver/deployment" ],
				   },
		sourceselect	=> all,
		recurse		=> true,
		ignore		=> ".svn",
		require		=> Stratos::Deploy[$deployment_code];

		"${deployment_code}_components":
		path		=> "${carbon_home}/repository/components/", 
		ensure		=> present,
		owner		=> $owner,
		group		=> $group,
		source		=> $instance_type ? {
					"analyzer" => [ "puppet:///bam/analyzer/components" ],
				   	"receiver" => [ "puppet:///bam/receiver/components" ],
				   },
		sourceselect	=> all,
		recurse		=> true,
		ignore		=> ".svn",
		require		=> Stratos::Deploy[$deployment_code],
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
	
	exec { "editing_bundles.info":
		path		=> ["/bin/","/usr/bin/"],
		onlyif		=> "/usr/bin/find ${carbon_home} -type f -name bundles.info",
		command		=> $instance_type ? {
					"receiver" => "find ${carbon_home} -type f -name bundles.info -exec sed -i '/org.wso2.carbon.bam.toolbox/d' {} \;
						       find ${carbon_home} -type f -name bundles.info -exec sed -i '/org.wso2.carbon.hive.data.source.access/d' {} \;
						       find ${carbon_home} -type f -name bundles.info -exec sed -i '/org.wso2.carbon.analytics.hive/d' {} \;",
					"analyzer" => "true",
				   },
		require		=> Stratos::Deploy[$deployment_code],
	}

	start { $deployment_code:
                owner           => $owner,
                target          => $carbon_home,
		require		=> [ Stratos::Initialize[$deployment_code],
				     Stratos::Deploy[$deployment_code],
				     Push_templates[$service_templates],
				     Push_templates[$common_templates], 
				     Exec["editing_bundles.info"],
				     File["${deployment_code}_components"],
				     File["${deployment_code}_deployment"],
				   ],
	}
}

