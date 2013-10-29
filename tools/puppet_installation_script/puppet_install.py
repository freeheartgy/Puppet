#!/usr/bin/env python

try:
    import sys
    import textwrap
    import system 
    import argparse

except Exception as e :
    print "Error : ", e


def get_confirmation(master_ip, domain, hostname, os):
    
    print "====================================================================="
    print ""
    print "Puppet Masters IP address : ", master_ip
    print "Domain of the deployment  : ", domain
    print "FQDN of this node         :  " + hostname + "." + domain
    print "Operating system          : ", os
    print ""
    print "Please check your input and confirm by pressing [Enter] to continue."
    print "or press [Ctrl] + [c] to stop the installationan exit."
    print "====================================================================="
    try:
        print raw_input()
    except KeyboardInterrupt as e:
        print "Pressed [Ctrl] + [c]."
        print "Script will now exit ..."
        sys.exit(0) 


def get_user_input():
    
    print "To install,"
    print "1.) Puppet Master."
    print "2.) Puppet Agent."
    try:
        agent = raw_input("Select only 1 or 2 or press [Ctrl] + [c] exit. : ").strip()
    except KeyboardInterrupt as e:
        print "\nPressed [Ctrl] + [c]."
        print "Script will now exit ..."
        sys.exit(0) 

    if agent == "1":
        print ""
        print "You select option 1 to install puppet master."
        print ""
        master_ip = raw_input("Give the IP address of puppet master : ")
        if not master_ip:
            sys.exit(1)
        domain =  raw_input("Give the domain of the deployment [apps.wso2.com] : ")
        if not domain:
            domain="apps.wso2.com"
        os = raw_input("Give the operating system {ubuntu/debian/centos/redhat/sues} [ubuntu] : ")
        if not os:
            os="ubuntu"
        return 'master', master_ip.strip(), domain.strip(), "puppetmaster", os.strip()
    elif agent == "2":
        print ""
        print "You select option 2 to install puppet agent."
        print ""
        master_ip = raw_input("Give the IP address of puppet master : ")
        if not master_ip:
            sys.exit(1)
        domain =  raw_input("Give the domain of the deployment [apps.wso2.com] : ")
        if not domain:
            domain="apps.wso2.com"
        hostname = raw_input("Give the hostname of the node [node1] : ")
        if not hostname:
            hostname="node1"
        os = raw_input("Give the operating system {ubuntu/debian/centos/redhat/sues} [ubuntu] : ")
        if not os:
            os="ubuntu"
        return 'agent', master_ip.strip(), domain.strip(), hostname.strip(), os.strip()
    else:
        print "The option you select is incorrect."
        get_user_input()




if __name__ == '__main__':

    parser = argparse.ArgumentParser(
        description='This is a puppet installation script which can be used to install puppet master and puppet agent.',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=textwrap.dedent('''
Usage options:

Install in interactive mode :
    sudo python puppet_install.py
Install puppet agent : 
    sudo python puppet_install.py --master \\
        --domain apps.wso2.com --master-ip 10.1.1.1 --os ubuntu
Install puppet agent : 
    sudo python puppet_install.py --agent \\
        --domain apps.wso2.com --master-ip 10.1.1.1 --hostname node001 --os ubuntu
                '''))
    parser.add_argument('--agent', action='store_true')
    parser.add_argument('--master', action='store_true')
    parser.add_argument('--domain', help="Give the domain name of the diployment. \n eg : apps.wso1.com")
    parser.add_argument('--master-ip', dest='masterip', help='IP address of the puppetmaster node. Eg: 10.1.1.1')
    parser.add_argument('--hostname', help='Give the hostname of the system. On master node it is \'puppetmaster\' by default. Eg: node001 ')
    parser.add_argument('--os', choices={'debian','ubuntu','centos','redhat','sues'}, help='Give the operating system as ubuntu/centos/redhat/sues.')
    args = parser.parse_args()

    if system.check_user():
        print "This is a puppet installation script."
        print ""

        if  len(sys.argv) < 2:
            print "Starting with the interactive mode."
            agent, master_ip, domain, hostname, os = get_user_input()
        elif args.agent == True and args.master == False:
            print "Going to setup a puppet agent."
            if (args.domain != None and args.masterip != None and args.hostname != None and args.os != None):
                domain = args.domain
                master_ip = args.masterip
                hostname = args.hostname
                os = args.os 
                agent = 'agent'
            else:
                print "To setup an agent it is required to set all following values."
                print "Usage: sudo python puppet_install.py --agent --domain apps.wso2.com --master-ip 10.1.1.1 --hostname node01 --os ubuntu"
                exit(1)
        elif args.agent == False and args.master == True:
            print "Going to setup a puppet master."
            if (args.domain != None and args.masterip != None and args.os != None):
                domain = args.domain
                master_ip = args.masterip 
                hostname = 'puppetmaster'
                os = args.os 
                agent = 'master'
            else:
                print "To setup a master it is required to set all following values."
                print "Usage: sudo python puppet_install.py --master --domain apps.wso2.com --master-ip 10.1.1.1 --os ubuntu"
                exit(1)
        else:
            print "Error : Use --master or --agent to setup puppet master or puppet agent accordingly."
            print "Usage: sudo python puppet_install.py --master --domain apps.wso2.com --master-ip 10.1.1.1 --os ubuntu"
            print "Usage: sudo python puppet_install.py --agent --domain apps.wso2.com --master-ip 10.1.1.1 --hostname node01 --os ubuntu"
            exit(1)

        if os:
            get_confirmation(master_ip, domain, hostname, os)
            system.install_puppet(system.get_package_manager(os), master_ip, domain, hostname, '8140', agent)
        else:
            print "Unidentified package manager."
            exit(1)
    else:
        print "Need root access."	
        print "Run the script as \'root\' or with \'sudo\' permissions. "

