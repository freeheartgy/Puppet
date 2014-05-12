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
#----------------------------------------------------------------------------
#
# Initializing the deployment

define wso2greg::initialize ($repo, $version, $service, $local_dir, $target, $mode, $owner,) {
  file { "/datayes/wso2${service}-${version}.zip":
    ensure  => present,
    mode    => 0755,
    replace => false,
    source  => "puppet:///modules/wso2${service}/wso2${service}-${version}.zip",
    require => Exec["creating_local_package_repo_for_${name}", "creating_target_for_${name}"],
  }
  
  file { "${target}/wso2${service}-${version}-${hostname}/repository/conf/solr/conf/elevate.xml":
    ensure  => present,
    mode    => 0755,
    replace => false,
    source  => "puppet:///modules/wso2${service}/solr/elevate.xml",
    require => Exec["creating_local_solr_for_${name}"],
  }
  
  file { "${target}/wso2${service}-${version}-${hostname}/repository/conf/solr/conf/protwords.txt":
    ensure  => present,
    mode    => 0755,
    replace => false,
    source  => "puppet:///modules/wso2${service}/solr/protwords.txt",
    require => Exec["creating_local_solr_for_${name}"],
  }
  
  file { "${target}/wso2${service}-${version}-${hostname}/repository/conf/solr/conf/schema.xml":
    ensure  => present,
    mode    => 0755,
    replace => false,
    source  => "puppet:///modules/wso2${service}/solr/schema.xml",
    require => Exec["creating_local_solr_for_${name}"],
  }
  
  file { "${target}/wso2${service}-${version}-${hostname}/repository/conf/solr/conf/scripts.conf":
    ensure  => present,
    mode    => 0755,
    replace => false,
    source  => "puppet:///modules/wso2${service}/solr/scripts.conf",
    require => Exec["creating_local_solr_for_${name}"],
  }
  
  file { "${target}/wso2${service}-${version}-${hostname}/repository/conf/solr/conf/solrconfig.xml":
    ensure  => present,
    mode    => 0755,
    replace => false,
    source  => "puppet:///modules/wso2${service}/solr/solrconfig.xml",
    require => Exec["creating_local_solr_for_${name}"],
  }
  
  file { "${target}/wso2${service}-${version}-${hostname}/repository/conf/solr/conf/spellings.txt":
    ensure  => present,
    mode    => 0755,
    replace => false,
    source  => "puppet:///modules/wso2${service}/solr/spellings.txt",
    require => Exec["creating_local_solr_for_${name}"],
  }
  
  file { "${target}/wso2${service}-${version}-${hostname}/repository/conf/solr/conf/stopwords.txt":
    ensure  => present,
    mode    => 0755,
    replace => false,
    source  => "puppet:///modules/wso2${service}/solr/stopwords.txt",
    require => Exec["creating_local_solr_for_${name}"],
  }
  
  file { "${target}/wso2${service}-${version}-${hostname}/repository/conf/solr/conf/synonyms.txt":
    ensure  => present,
    mode    => 0755,
    replace => false,
    source  => "puppet:///modules/wso2${service}/solr/synonyms.txt",
    require => Exec["creating_local_solr_for_${name}"],
  }

  exec {
    "creating_target_for_${name}":
      path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      command => "mkdir -p ${target}";

    "creating_local_package_repo_for_${name}":
      path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/java/bin/',
      unless  => "test -d ${local_dir}",
      command => "mkdir -p ${local_dir}";    

    "extracting_wso2${service}-${version}.zip_for_${name}":
      path      => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      cwd       => $target,
      unless    => "test -d ${target}/wso2${service}-${version}/repository",
      command   => "unzip ${local_dir}/wso2${service}-${version}.zip",
      logoutput => 'on_failure',
      creates   => "${target}/wso2${service}-${version}/repository",
      timeout   => 0,
      require   => File["/datayes/wso2${service}-${version}.zip"];      
 

    "setting_permission_for_${name}":
      path      => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      cwd       => $target,
      command   =>  "mv ${target}/wso2${service}-${version} ${target}/wso2${service}-${version}-${hostname}; 
                      chown -R ${owner}:${owner} ${target}/wso2${service}-${version}-${hostname} ;
                      chmod -R 755 ${target}/wso2${service}-${version}-${hostname}",
      logoutput => 'on_failure',
      timeout   => 0,
      require   => Exec["extracting_wso2${service}-${version}.zip_for_${name}"];
      
     "creating_local_solr_for_${name}":
      path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/java/bin/',
      unless  => "test -d ${local_dir}/wso2${service}-${version}-${hostname}/repository/conf/solr/conf",
      command => "mkdir -p ${local_dir}/wso2${service}-${version}-${hostname}/repository/conf/solr/conf",
      require   => Exec["setting_permission_for_${name}"]; 
      
  }

}
