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
# Class elb::params
#
# This class manages elb parameters
#
# Parameters:
#
# Usage: Uncomment the variable and assign a value to override the wso2.pp value
#
#

class wso2elb::params {
  $package_repo         = 'http://puppetmaster01.datayes.com'
  $local_package_dir    = '/datayes'

  # Service subdomains
  $domain               = 'datayes.com'
  $management_subdomain = 'mgt'

  $admin_username       = 'admin'
  $admin_password       = 'admin'
  
  $env_type = "-dev"

  $local_member_host = 'elb01w01.cloud-lbdev.datayes.com'
  
  $http_port = '80'
  $https_port = '443'  

  
}
