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

class wso2bam01w02 (
  $version            = '2.4.0',
  $sub_cluster_domain = 'worker',
  $members            = {'bam01w01.cloud-ctldev.datayes.com' => 4000, 'elb01w03.cloud-lbdev.datayes.com' => 4000 },
  $offset             = 1,
  $tribes_port        = 4000,
  $config_db          = 'bam_db',
  $maintenance_mode   = true,
  $depsync            = true,
  $clustering         = false,
  $cloud              = false,
  $owner              = 'root',
  $group              = 'root',
  $target             = '/datayes',
) inherits wso2bam01w02::params {

  $deployment_code = 'bam'
  $carbon_version  = $version
  $service_code    = 'bam'
  $carbon_home     = "${target}/wso2${service_code}-${carbon_version}-${hostname}"
  $template_path = '/etc/puppet/modules/wso2bam/templates'
  $client_auth = false


  $service_templates = $sub_cluster_domain ? {
     'mgt'    => [
      'conf/advanced/streamdefn.xml',   
      'conf/axis2/axis2.xml',
      'conf/carbon.xml',
      'conf/datasources/master-datasources.xml',
      'conf/etc/cassandra-component.xml',
      'conf/etc/cassandra.yaml',
      'conf/etc/tasks-config.xml',
      'conf/registry.xml',   
      'conf/tomcat/catalina-server.xml',
      'conf/user-mgt.xml',
      ],
    'worker' => [
      'conf/advanced/streamdefn.xml',   
      'conf/axis2/axis2.xml',
      'conf/carbon.xml',
      'conf/datasources/master-datasources.xml',
      'conf/etc/cassandra-component.xml',
      'conf/etc/cassandra.yaml',
      'conf/etc/tasks-config.xml',
      'conf/registry.xml',   
      'conf/tomcat/catalina-server.xml',
      'conf/user-mgt.xml',
      ],
    default => [
      'conf/advanced/streamdefn.xml',   
      'conf/axis2/axis2.xml',
      'conf/carbon.xml',
      'conf/datasources/master-datasources.xml',
      'conf/etc/cassandra-component.xml',
      'conf/etc/cassandra.yaml',
      'conf/etc/tasks-config.xml',
      'conf/registry.xml',   
      'conf/tomcat/catalina-server.xml',
      'conf/user-mgt.xml',
      ],
  }

  tag('wso2bam01w02')


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
