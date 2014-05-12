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
# Class: appserver
#
# This class installs WSO2 Appserver
#
# Parameters:
# version            => '5.2.0'
# offset             => 1,
# tribes_port        => 4100,
# config_db          => 'as_config',
# maintenance_mode   => 'zero',
# depsync            => false,
# sub_cluster_domain => 'mgt',
# clustering         => true,
# owner              => 'root',
# group              => 'root',
# target             => '/mnt/',
# members            => {'elb2.wso2.com' => 4010, 'elb.wso2.com' => 4010 }
#
# Actions:
#   - Install WSO2 Appserver
#
# Requires:
#
# Sample Usage:
#

class wso2as01w01 (
  $version            = '5.2.1',
  $sub_cluster_domain = 'worker',
  $members            = {'elb01w01.cloud-lbdev.datayes.com' => 4001, 'elb02w01.cloud-lbdev.datayes.com' => 4001 },
  $offset             = 0,
  $tribes_port        = 4000,
  $config_db          = 'appserver',
  $maintenance_mode   = true,
  $depsync            = true,
  $clustering         = true,
  $cloud              = false,
  $owner              = 'root',
  $group              = 'root',
  $target             = '/datayes',
) inherits wso2as01w01::params {

  $deployment_code = 'as'
  $carbon_version  = $version
  $service_code    = 'as'
  $carbon_home     = "${target}/wso2${service_code}-${carbon_version}-${hostname}"
  $template_path = '/etc/puppet/modules/wso2as/templates'

  $service_templates = $sub_cluster_domain ? {
    'mgt'    => [
      'conf/axis2/axis2.xml',
      'conf/carbon.xml',
      'conf/datasources/master-datasources.xml',
      'conf/registry.xml',
      'conf/security/authenticators.xml',
      'conf/tomcat/catalina-server.xml',
      'conf/user-mgt.xml',
      ],
    'worker' => [
      'conf/axis2/axis2.xml',
      'conf/carbon.xml',
      'conf/datasources/master-datasources.xml',
      'conf/registry.xml',
      'conf/security/authenticators.xml',
      'conf/tomcat/catalina-server.xml',
      'conf/user-mgt.xml',
      ],
    default => [
      'conf/axis2/axis2.xml',
      'conf/carbon.xml',
      'conf/datasources/master-datasources.xml',
      'conf/registry.xml',
      'conf/security/authenticators.xml',
      'conf/tomcat/catalina-server.xml',
      'conf/user-mgt.xml',
      ],
  }

  tag('wso2as01w01')


 initialize { $deployment_code:
    repo      => $package_repo,
    version   => $carbon_version,
    service   => $service_code,
    local_dir => $local_package_dir,
    target    => $target,
    mode      => $maintenance_mode,
    owner     => $owner,   
  }


 push_templates {
    $service_templates:
      target    => $carbon_home,
      directory => $template_path,
      require   => Initialize[$deployment_code];
  }

 start { $deployment_code:
    owner   => $owner,
    target  => $carbon_home,
    require => [
        Initialize[$deployment_code],     
        Push_templates[$service_templates],
      ],
  }
}
