#!/usr/bin/env python

try:
    import platform
    import os
    from subprocess import STDOUT, check_call
    import puppet_master_conf as pmc
    import puppet_agent_conf as pac

except Exception as e :
    print "Error : ", e


def apt_update():
    try:
        check_call(['apt-get', 'update'], stderr=STDOUT)
        print "Update apt repository."
    except Exception as apt_update_e:
        print "Error while updating the repository."
        print "More details : " , apt_update_e
    

def apt_install_master():
    try:
        check_call(['apt-get', 'install', 'puppetmaster' ,'-y'], stderr=STDOUT) 
        print "Installed puppet master via apt"
    except Exception as master_install_e:
        print "Error while installing puppet master via apt."
        print "More details : " , master_install_e

def apt_install_agent():
    try:
        check_call(['apt-get', 'install', 'puppet', '-y'], stderr=STDOUT)
        print "Installed puppet agent via apt"
    except Exception as agent_install_e:
        print "Error while installing puppet agent via apt."
        print "More details : " , agent_install_e


def restart_master():
    try:
        print "Restarting puppet master ... "
        check_call(['service', 'puppetmaster', 'restart'], stderr=STDOUT)
    except Exception as master_restart_e:
        print "Error while restarting puppet master."
        print "More details : " , master_restart_e

def restart_agent():
    try:
        print "Restarting puppet agent ... "
        check_call(['service', 'puppet', 'restart'], stderr=STDOUT)
    except Exception as agent_restart_e:
        print "Error while restarting puppet agent."
        print "More details : " , agent_restart_e


def configure_puppet_master(master_ip,domain,port,agent):
    pmc.set_host_name(domain=domain, hostname='puppetmaster')
    pmc.add_etc_hosts(domain=domain, master_ip=master_ip)
    pmc.make_mnt_puppet_dir(domain=domain)
    apt_update()
    apt_install_master()
    pmc.config_puppetmaster_default(port=port, daemon_opts="--ssl_client_header=HTTP_X_SSL_SUBJECT")
    pmc.config_puppet_conf(domain=domain)
    pmc.config_fileserver_conf(domain=domain)
    pmc.config_auth_conf(domain=domain)
    pmc.config_autosign_conf(domain=domain)
    restart_master()

def configure_puppet_agent(master_ip,domain,hostname,port,agent='agent'):
    pac.set_host_name(domain=domain,hostname=hostname)
    pac.add_etc_hosts(master_ip=master_ip,domain=domain)
    apt_update()
    apt_install_agent()
    pac.config_puppetagent_default()
    pac.config_puppet_conf(domain=domain)
    restart_agent()
