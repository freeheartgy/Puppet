#!/usr/bin/env python

from subprocess import STDOUT, check_call
import re

# Set the hostname. 
def set_host_name(domain,hostname):
    # set hostname
    fqdn = hostname + "." + domain
    hostname_file = open("/etc/hostname","w")
    hostname_file.write(fqdn + "\n")
    hostname_file.close()
    try:
        check_call(['hostname', fqdn ], stderr=STDOUT) 
    except Exception as hostnamec_e:
        print "Error while setting the hostname via command : ", fqdn
        print "More details : " , hostnamec_e
    print("Add hostname : " + fqdn)


# add entries to /etc/hosts
def add_etc_hosts(master_ip, domain, file_path='/etc/hosts'):

    try: 
        config = open(file_path,'w')
        config.write("# Added by the puppet installation script.\n")
        config.write("127.0.0.1 localhost\n")
        config.write(master_ip + " puppetmaster." + domain +" \n")
        config.close()
        print "Configured the /etc/hosts."
    except Exception as hosts_e:
        print "Error while configuring /etc/hosts."
        print "More details : " , hosts_e 


# Create /mnp/puppet directory
def make_mnt_puppet_dir(domain,path='/mnt/puppet'):
    
    full_path=path + "/" + domain 
    try:
        check_call(['mkdir', '-p', full_path ], stderr=STDOUT) 
    except Exception as file_e:
        print "Error while creating directory : ", path
        print "More details : " , file_e



# Configure 'puppetmaster-default'
def config_puppetmaster_default(file_path='/etc/default/puppetmaster', daemon_opts="", servertype='webrick', masters='1', port='8140'):

    try: 
        config = open(file_path,'w')
        config.write("# Added by the puppet installation script.\n")
        config.write("START=yes\n")
        config.write("DAEMON_OPTS=\"" + daemon_opts + "\"\n")
        config.write("SERVERTYPE=" + servertype + "\n")
        config.write("PUPPETMASTERS=" + masters + "\n")
        config.write("PORT=" + port + "\n")
        config.close()
        print "Configured the puppet master default settings."
    except Exception as master_config_e:
        print "Error while configuring puppet master defaults."
        print "More details : " , master_config_e


# Configure 'puppet.conf'
def config_puppet_conf(domain, file_path='/etc/puppet/puppet.conf'):

    try: 
        config = open(file_path,'w')
        config.write("""# Added by the puppet installation script.
[main]
logdir=/var/log/puppet
vardir=/var/lib/puppet
ssldir=/var/lib/puppet/ssl
rundir=/var/run/puppet
factpath=$vardir/lib/facter
templatedir=/etc/puppet/templates/
modulepath=/etc/puppet/modules/
report=false

""")
        config.write("[" + re.sub("\.","_",domain) + "]\n")
        config.write("modulepath=/mnt/puppet/" + domain + "/modules/\n")
        config.write("templatedir=/mnt/puppet/" + domain + "/templates/\n")
        config.write("manifest=/mnt/puppet/" + domain + "/manifests/site.pp\n")
        config.write("manifestdir=/mnt/puppet/" + domain + "/manifests/\n")
        config.write("report=false\n")
        config.close()
        print "Configured the puppet.conf settings."
    except Exception as master_config_e:
        print "Error while configuring puppet.conf."
        print "More details : " , master_config_e


def config_fileserver_conf(domain, file_path='/etc/puppet/fileserver.conf'):

    try: 
        config = open(file_path,'w')
        config.write("""[file]
path /etc/puppet/
allow *

[plugins]
allow *

""")
        config.write("[" + re.sub("\.","_",domain) + "]\n")
        config.write("path /mnt/puppet/" + domain +"/\n")
        config.write("allow *\n")
        config.write("\n")
        config.close()
        print "Configured the fileserver.conf settings."
    except Exception as fileserver_config_e:
        print "Error while configuring fileserver.conf."
        print "More details : " , fileserver_config_e



def config_auth_conf(domain, file_path='/etc/puppet/auth.conf'):

    try: 
        config = open(file_path,'w')
        config.write("""path ~ ^/catalog/([^/]+)$
method find
allow $1

path /certificate_revocation_list/ca
method find
allow *

path /report
method save
allow *

path /file
allow *

path /file_metadata
auth any
method find
allow *

path /certificate/ca
auth no
method find
allow *

path /certificate/
auth no
method find
allow *

path /certificate_request
auth no
method find, save
allow *

path /
""")
        config.write("environment " + re.sub("\.","_",domain) + "\n")
        config.write("allow * \n")
        config.close()
        print "Configured the auth.conf settings."
    except Exception as auth_config_e:
        print "Error while configuring auth.conf."
        print "More details : " , auth_config_e


def config_autosign_conf(domain,path='/etc/puppet/autosign.conf'):
    
    try:
        config = open(path,'w')
        config.write('* \n')
        print "Configured the autosign.conf settings."
        config.close()
    except Exception as autosign_config_e:
        print "Error while  configuring autosign.conf"
        print "More details : " , autosign_config_e


