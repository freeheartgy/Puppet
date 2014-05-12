# ----------------------------------------------------------------------------
#  Copyright 2005-2013 WSO2, Inc. http://www.wso2.org
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
# ----------------------------------------------------------------------------
#
# Class appserver::params
#
# This class manages appserver parameters
#
# Parameters:
#
# Usage: Uncomment the variable and assign a value to override the wso2.pp value
#
#

class wso2bam01w02::params {
  $package_repo         = 'http://puppetmaster01.datayes.com'
  $local_package_dir    = '/datayes'

  # Service subdomains
  $domain               = 'datayes.com'
  $am_subdomain         = 'cloud-bam'
  $product_type = 'bam'
  $full_host_name = 'bam01w02.cloud-ctldev.datayes.com'
  
  $governance_subdomain = 'cloud-greg'
  $management_subdomain = 'mgt'
  $env_type = "-dev"
  $usermagt = false
  
  #task-config
  $task_server_count = '1'
  
  #cassandra
  $initial_token = '56713727820156410577229101238628035242'
  $rpc_port = '9161'
  $css_default_port = '9161'
  $css_nodes = 'bam01w01.cloud-ctldev.datayes.com:9161,bam01w02.cloud-ctldev.datayes.com:9161,bam01w03.cloud-ctldev.datayes.com:9161'
  
  #streamdefn
  $replication_num = '3'
  
  #axis2
  $axis2_http_port = '9763'
  $axis2_https_port = '9443'

  #tomcat-catalina
  $proxy_enable = false
  $http_proxy_port = '80'
  $https_proxy_port = '443' 
  $http_port = '80'
  $https_port = '443' 
  
  #api-manager
  $billing_enable = true
  $user_track_enable = true
  $bam_server_url = 'tcp://bam01w01.cloud-ctldev.datayes.com:7612/,tcp://bam01w02.cloud-ctldev.datayes.com:7612/,tcp://bam01w03.cloud-ctldev.datayes.com:7612/'
  $bam_username = 'admin'
  $bam_password = 'admin'
  $self_sign_up_enable = true
  $access_control_allow_origin = 'https://cloud-api-dev.datayes.com,http://cloud-api-dev.datayes.com'
  
  #user-mgt
  $admin_username       = 'admin'
  $admin_password       = 'admin'
  
  #datasource
  $am_db = 'apimgtdb'
  $am_stats_db = 'am_status_db'
  $cassandra_datasource_url = 'jdbc:cassandra://bam01w01.cloud-ctldev.datayes.com:9161/EVENT_KS,jdbc:cassandra://bam01w02.cloud-ctldev.datayes.com:9161/EVENT_KS,jdbc:cassandra://bam01w03.cloud-ctldev.datayes.com:9161/EVENT_KS'
  $bamutil_datasource_url = 'jdbc:cassandra://bam01w01.cloud-ctldev.datayes.com:9161/BAM_UTIL_KS'

  # MySQL server configuration details
  $mysql_server         = 'mysql02w01.cloud-ctldev.datayes.com'
  $mysql_port           = '3306'
  $max_connections      = '100000'
  $max_active           = '150'
  $max_wait             = '360000'

  # Database details
  $registry_user        = 'paas'
  $registry_password    = 'paas@123'
  $registry_database    = 'registry'

  $userstore_user       = 'paas'
  $userstore_password   = 'paas@123'
  $userstore_database   = 'user'

  # Depsync settings
  $svn_user             = 'paas'
  $svn_password         = 'wso2dev'
 
}
