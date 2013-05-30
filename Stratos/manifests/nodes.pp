stage { 'configure': require => Stage['main'] }
stage { 'deploy': require => Stage['configure'] }

node basenode {
        $package_repo 		= "http://package_repostitory.domain.com"
        $depsync_svn_repo 	= "https://svn.domain.com/repo/"
	$local_package_dir	= "/mnt/packs/"
	$deploy_new_packs	= "true"
}

node confignode inherits basenode  {
	## Service subdomains
	$stratos_domain 	= "domain.com"
	$as_subdomain 		= "appserver"
	$bam_subdomain 		= "monitor"
	$bps_subdomain 		= "process"
	$brs_subdomain 		= "rule"
	$cep_subdomain 		= "cep"
	$dss_subdomain 		= "data"
	$esb_subdomain 		= "esb"
	$gs_subdomain 		= "gadget"
	$cg_subdomain 		= "cloudgateway"
	$ts_subdomain 		= "task"
	$governance_subdomain 	= "governance"
	$is_subdomain 		= "identity"
	$mb_subdomain 		= "messaging"
	$ms_subdomain 		= "mashup"
	$ss_subdomain 		= "storage"
	$am_subdomain 		= "api"
	$management_subdomain 	= "management"

	## MySQL server configuration details
	$mysql_server_1 	= "mysql1.domain.com"	
	$mysql_server_2 	= "mysql2.domain.com"	
	$mysql_port 		= "3306"
	$max_connections 	= "100000"
	$max_active 		= "150"
	$max_wait 		= "360000"
	
	## Deployment Synchronizer
	$repository_type 	= "svn"
	$svn_user 		= "wso2"
	$svn_password 		= "XXXXXXXXXXXX"	

	## Auto-scaler
	$keystore_password 	= "wso2carbon"
	$auto_scaler_epr 	= "http://1.2.3.4/services/AutoscalerService/"	
	$auto_scaler_task_interval = "60000"
	$server_startup_delay 	= "60000"

	## Database detilas
	$registry_user 		= "registry"
	$registry_password 	= "YYYYYYYYYYYYYYYYYY"
	$registry_database 	= "governance"

	$hive_database 		= "metastore_db"
	$rss_database 		= "rss_db"
	$rss_user 		= "rss_db"
	$rss_password 		= "YYYYYYYYYYYYYYYYYY"	
	$rss_instance_user 	= "wso2admin"	
	$rss_instance_password 	= "XXXXXXXXXXXXXXXXXX"	

	$rss_instance0		= "rss0"
	$rss_instance1		= "rss1"
	$rss_instance2 		= "rss2"

	$billing_user 		= "billing"
	$billing_password 	= "YYYYYYYYYYYYYYYYYY"
	$billing_database 	= "billing"
	$billing_datasource 	= "WSO2BillingDS"

	$userstore_user 	= "userstore"
	$userstore_password 	= "YYYYYYYYYYYYYYYYYY"
	$userstore_database 	= "userstore"

	## BPS database for both BPS and GReg
	$bps_user 		= "bps"
	$bps_password 		= "YYYYYYYYYYYYYYYYYY"
	$bps_database 		= "bps"

	## Cassandra details
	$css0_subdomain 	= "node0.cassandra"
	$css1_subdomain 	= "node1.cassandra"
	$css2_subdomain 	= "node2.cassandra"
	$css_cluster_name 	= "Stratos Dev Setup"
	$css_port		= "9160"
	$cassandra_username	= "cassandra"
	$cassandra_password	= "XXXXXXXXXXXXXXXXXXXXYYYYYYYYYYYYYYYYYYY"
	$css_replication_factor = "3"
	$hdfs_url               = "hadoop0"
        $hdfs_port              = "9000"
        $hdfs_job_tracker_port  = "9001"

	## Hadoop details
        $hadoop1_subdomain      = "hadoop1"
        $hadoop2_subdomain      = "hadoop2"
        $dfs_replication        = "1"
        $hadoop_heapsize        = "1024"

	## LOGEVENT configurations
	$receiver_url		= "receiver.domain.com"
	$receiver_port		= "7617"
	$receiver_secure_port	= "7717"
	$receiver_username 	= "cassandra"
	$receiver_password 	= "XXXXXXXXXXXXXXXXXXXXYYYYYYYYYYYYYYYYYYY"

	## BAM Analyzer details
	$analyzer_subdomain     = "analyzer"

	## Server details for billing
	$time_zone		= "GMT-8:00"
}

node 'platform01.domain.com' inherits confignode {
	$server_ip 	= $ipaddress
	
	## Automatic failover
        $virtual_ip     = "192.168.4.250"
        $interface      = "eth0"
        $check_interval = "2"
        $priority       = "100"
        $state          = "MASTER"
	
	include system_config
        

	class {"stratos::elb":
                services           =>  ["identity,*,mgt",
					"esb,*,mgt",
					"dss,*,mgt",
                                        "governance,*,mgt"],
                version            => "2.0.2",
                maintenance_mode   => "true",
                auto_scaler        => "false",
                auto_failover      => "false",
		owner		   => "root",
		group		   => "root",
		target             => "/mnt/${server_ip}",
                stage              => "deploy",
        }

	class {"stratos::esb":
                version            => "4.6.0",
                offset             => 2,
                tribes_port        => 4200,
                config_db          => "esb_config",
                maintenance_mode   => "true",
                depsync            => "true",
                sub_cluster_domain => "worker",
		owner		   => "kurumba",
		group		   => "kurumba",
                target             => "/mnt/${server_ip}",
                stage              => "deploy",
        }

	class {"stratos::dss":
                version            => "3.0.1",
                offset             => 3,
                tribes_port        => 4300,
                config_db          => "dss_config",
                maintenance_mode   => "true",
                depsync            => "true",
                sub_cluster_domain => "worker",
                owner              => "kurumba",
                group              => "kurumba",
                target             => "/mnt/${server_ip}",
                stage              => "deploy",
        }
	
	class {"stratos::identity":
		version            => "4.0.1",
                offset             => 7,
                tribes_port        => 4700,
                config_db          => "identity_config",
                maintenance_mode   => "true",
		owner		   => "kurumba",
		group		   => "kurumba",
                target             => "/mnt/${server_ip}",
                sub_cluster_domain => "mgt",
                stage              => "deploy",
        }
}

node 'platform02.domain.com' inherits confignode {
	$server_ip      = $ipaddress 

        ## Automatic failover
        $virtual_ip     = "192.168.4.250"
        $interface      = "eth0"
        $check_interval = "2"
        $priority       = "100"
        $state          = "MASTER"

        include system_config

        class {"stratos::elb":
                services           =>  ["appserver,*,*",
					"rule,*,*",
                                        "rule,*,*"],
                version            => "2.0.2",
                maintenance_mode   => "true",
                auto_scaler        => "false",
                auto_failover      => "false",
		owner		   => "root",
		group		   => "root",
                target             => "/mnt/${server_ip}",
                stage              => "deploy",
        }
	
	class {"stratos::appserver":
                version            => "5.0.2",
                offset             => 1,
                tribes_port        => 4100,
                config_db          => "appserver_config",
                maintenance_mode   => "false",
                depsync            => "true",
                sub_cluster_domain => "worker",
		owner		   => "kurumba",
		group		   => "kurumba",
                target             => "/mnt/${server_ip}",
                stage              => "deploy",
        }
	
	class {"stratos::brs":
		version            => "2.0.0",
                offset             => 5,
                tribes_port        => 4500,
                config_db          => "brs_config",
                maintenance_mode   => "true",
                depsync            => "true",
                sub_cluster_domain => "mgt",
		owner		   => "kurumba",
		group		   => "kurumba",
                target             => "/mnt/${server_ip}",
                stage              => "deploy",
        }
		
	class {"stratos::greg":
		version            => "4.5.3",
                offset             => 7,
                tribes_port        => 4700,
                config_db          => "governance",
                maintenance_mode   => "true",
                sub_cluster_domain => "mgt",
		owner		   => "kurumba",
		group		   => "kurumba",
                target             => "/mnt/${server_ip}",
                stage              => "deploy",
        }
}

