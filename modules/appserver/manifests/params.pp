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

class appserver::params {
  #$domain                     = 'domain.com'
  $as_subdomain               = 'appserver'
  #$adminuser_name            =
  #$adminuser_passwd          =
  #$af_cluster_domain         =
  #$af_identity_provider      =
  #$af_keystore_alias         =
  #$af_keystore_passwd        =
  #$af_registration_link      =
  #$am_subdomain              =
  #$analyzer_subdomain        =
  #$app_creation_delay        =
  #$as_subdomain              =
  #$auto_scaler_epr           =
  #$auto_scaler_task_interval =
  #$esb_subdomain             =
  #$keystore_password         =
  #$management_subdomain      =
  #$max_active                =
  #$max_connections           =
  #$max_wait                  =
  #$mysql_driver_file         =
  #$mysql_port                =
  #$mysql_server_1            =
  #$mysql_server_2            =
  #$redmine_admin_passwd      =
  #$redmine_admin_uname       =
  #$registry_database         =
  #$registry_password         =
  #$registry_user             =
  #$server_startup_delay      =
  #$ss_subdomain              =
  #$depsync_svn_repo          =
  #$svn_user                  =
  #$svn_password              =
}
