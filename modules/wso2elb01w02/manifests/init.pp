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
# Class: elb
#
# This class installs WSO2 ELB
#
# Parameters:
#   services         => [['appserver','*','mgt','4010','appserver.wso2.com:4100'],['esb','*','mgt','4010','appserver.wso2.com:4100']],
#   version          => '2.1.0',
#   maintenance_mode => 'zero',
#   auto_scaler      => 'false',
#   auto_failover    => false,
#   cloud            => true,
#   owner            => 'root',
#   group            => 'root',
#   target           => '/mnt',
#   stage            => deploy,
#   members          => {'elb2.wso2.com' =>4010 };
#
# Actions:
#   - Install WSO2 ELB
#
#

class wso2elb01w02 (
  $version            = '2.1.0',
  $services           = [['as','*','worker','4001','elb01w01.cloud-lbdev.datayes.com:4001','*'],['is','*','worker','4002','elb01w01.cloud-lbdev.datayes.com:4002','*']],
  $members            = {'elb01w01.cloud-lbdev.datayes.com' =>4000,'elb02w01.cloud-lbdev.datayes.com'=>4000 },
  $maintenance_mode   = true,
  $cloud              = false,
  $owner              = 'root',
  $group              = 'root',
  $target             = '/datayes',
) inherits wso2elb01w02::params {

  $deployment_code  = 'elb'
  $carbon_version  = $version
  $service_code     = 'elb'
  $template_path = '/etc/puppet/modules/wso2elb/templates'
  $carbon_home      = "${target}/wso2${service_code}-${carbon_version}"

  $service_templates  = [
    'conf/axis2/axis2.xml',
#    'conf/carbon.xml',
#    'conf/datasources/master-datasources.xml',
    'conf/loadbalancer.conf',
#    'conf/user-mgt.xml',
  ]

  tag ('wso2elb01w02')

 

  initialize {
    $deployment_code:
      repo      => $package_repo,
      version   => $carbon_version,
      mode      => $maintenance_mode,
      service   => $service_code,
      local_dir => $local_package_dir,
      owner     => $owner,
      target    => $target,
  }


#  deploy { $deployment_code:
#    security => true,
#    owner    => $owner,
#    group    => $group,
#    target   => $carbon_home,
#    require  => Initialize[$deployment_code],
#  }


  push_templates {
    $service_templates:
      target     => $carbon_home,
      directory  => $template_path,
      require    => Initialize[$deployment_code];
  }

  start {
    $deployment_code:
      owner   => $owner,
      target  => $carbon_home,
      require => [  Initialize[$deployment_code],
                    Push_templates[$service_templates],],
        }
}
