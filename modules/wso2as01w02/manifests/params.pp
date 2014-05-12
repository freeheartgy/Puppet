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

class wso2as01w02::params {
  $package_repo         = 'http://puppetmaster01.datayes.com'
  $depsync_svn_repo     = 'svn://svn01.cloud-ctldev.datayes.com/appserver'
  $local_package_dir    = '/datayes'

  # Service subdomains
  $domain               = 'datayes.com'
  $as_subdomain         = 'cloud-as'
  $product_type = 'as'
  
  $governance_subdomain = 'cloud-greg'
  $management_subdomain = 'mgt'
  $env_type = "-dev"
  $usermagt = false
  $saml2sso_disable = false  
  $servcie_provide_id = "appServer"
  $is_sso_url = "https://cloud-is-dev.datayes.com/samlsso"
  
  $http_proxy_port = '80'
  $https_proxy_port = '443'  
  

  $admin_username       = 'admin'
  $admin_password       = 'admin'

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
