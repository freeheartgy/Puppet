class stratos::manager ( $version, 
		   $offset=0, 
		   $tribes_port=4000, 
		   $config_db=governance, 
		   $maintenance_mode=true, 
		   $sub_cluster_domain=mgt,
		   $owner=root,
		   $group=root,
		   $target="/mnt" ) {
	
	$deployment_code	= "manager"

	$stratos_version 	= $version
	$service_code 		= "manager"
	$carbon_home		= "${target}/wso2stratos-${service_code}-${stratos_version}"

	$service_templates 	= ["conf/registry.xml","conf/axis2/axis2.xml","conf/carbon.xml","conf/datasources.properties","conf/security/authenticators.xml",
                              	   "conf/email/email-admin-config.xml",
			      	   "conf/stratos-datasources.xml",			      	   
				   "conf/email/email-registration-complete.xml",
				   "conf/email/email-registration.xml","conf/email/email-update.xml","conf/multitenancy/tenant-reg-agent.xml", 
				   "conf/sso-idp-config.xml", "conf/multitenancy/stratos.xml", "conf/billing-config.xml", 
				   "deployment/server/webapps/STRATOS_ROOT/index.html", "conf/multitenancy/features-dashboard.xml"]
	$common_templates 	= ["conf/etc/cache.xml","conf/multitenancy/cloud-services-desc.xml","conf/datasources/master-datasources.xml","conf/identity.xml","conf/user-mgt.xml","conf/etc/logging-config.xml","conf/log4j.properties"]	

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
		service		=> "stratos-manager",
		local_dir       => $local_package_dir,
		owner		=> $owner,
		target   	=> $target,
		require		=> Stratos::Clean[$deployment_code],
	}

	deploy { $deployment_code:
		service		=> $service_code,
		security	=> "false",
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

