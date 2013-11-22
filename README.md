# About

This repo is to create a GitMachines version of State Decoded on CentOS 6.

Our goals:

- [x] First, a **one-click install of Waldo Jacquith's [Statedecoded](http://www.statedecoded.com/)**.
- [*] Second, **basic scans for security auditing** as part of the install.
- [] Third, **transparent documentation to make multi-machine configuration easier.** 
- [] Finally, **a Statedecoded GitMachine - fully accreditation-ready, one-click install of Statedecoded on a virtual machine**, ready for easy adoption.

** Warning this is a work in progress - Please check branches for activity**

## Versions
v0.2 nicer: one-click install to working StateDecoded localhost:8080, tomcat6, solr. Ready to import Virginia laws. Solr not populated. No auto security check."
v0.1 nice: one-click install to working localhost:8080, no xml, no solr

## How can I contribute?
We are learning as we go and do not yet clear asks to make of others. However, you can:
- Follow along, try things, and submit issues
- Fork, hack, and make pull requests (PLEASE keep these small for now and related to our project goals).

## Why this project?
The current [statedecoded-vagrant](https://github.com/statedecoded/statedecoded-vagrant) is helpful in setting up the environment on vagrant, but is not yet a one-click install. There are also has some gotchas we found in using it.

At GitMachines we are interested in one-click installs to get accreditation-ready builds in order to encourage adoption.

## Status
### What our one-click build does..

1. Uses CentOS, which is very very close to RedHat Enterprise
2. Configures CentOS firewall for Apache, Solr, and Tomcat
3. Pulls down statededecoded from its github repo
4. Mounts statedecoded directory on both guest and host machine (so you can access files from host machine, too)
5. Installs PHP 5, Apache, Java (for Solr, Tomcat), Tomcat6 (for running Solr), Solr,
6. Configures statedecoded.dev virtual host
7. Pulls down Virginia state laws
8. Has everything running on completion
9. Has a script to trigger SCAP security scan (not currently part of automation chain)d

### What user needs to do...
1. Clone repo and cd into repo directory
2. Type `vagrant up`
3. Surf web for 12-15 minutes
4. Use localhost:8080 or add statedecoded.dev to their /etc/hosts file
5. Visit statedecoded.dev/admin and set off processing of Virginia laws
6. (Is there a step to do to get laws ingested into Solr?)

## Dependencies
  * Latest version of vagrant (vagrantup.com)
  * Latest version Virtualbox (4.2.10 guest additions on our base box)
  * Do not have service running on ports 8080 or 8081 on host computer.

## Instructions

### One-click build
```
  # Clone this repo locally to your computer and switch to repo directory.
  git clone git@github.com:GitMachines/statedecoded-gm-centos6.git
  cd statedecoded-gm-centos6
  
  # Stop any processes# Launch your gitmachine 
  vagrant up
  # Browse the web, b/c this will take a while. 

  # Your statedecoded GitMachines is running on http://localhost:8080
```

### Install Virginia State Laws
Your statedecoded will look a bit lame without any laws. We've pre-configured everything to use Virginia's laws as a sample.

To finish the import of Virginia's Laws, open web browser and navigate to `http://localhost:8080/admin/` and follow instructions to import.

### Install Laws for a Different State
To use laws of a different state, follow the steps below to modify files and re-import laws to use a different state laws.

1. Adjust config.inc.php settings. See http://statedecoded.github.io/documentation/config.html
2. Rename `statedecoded/includes/class.Virginia.inc` to new state name, example `statedecoded/includes/class.Indiana.inc`.
3. Prepare the laws to the StateDecoded XML format. See http://statedecoded.github.io/documentation/
4. Replace the Virginia XML law files with new state XML formatted laws into `statedecoded/htdocs/admin/import-data/code/`. 
5. Empty the database. (Better instructions to come.)
6. Re-import the laws from the admin page at `http://localhost:8080/admin/`.

### (Optional) Give your GitMachine a domain name of statedecoded.dev
Your GitMachine and Statedecoded website is configured to be accessed by the domain `statedecoded.dev`. To do this, add the following line to the bottome of your host computer's known hosts file (ex: `/etc/hosts` on Linux and Macs).

```
192.168.56.101  statedecoded.dev
```

Note: We do not automate changing your host computer's known hosts file because it is highly risky to do automatically.

### (Optional) SSH into your gitmachine and run the SCAP test
Optionally check the configuration of the CentOS operating system against government baselines with the following command line steps.

``` 
  vagrant ssh
  # Install necessary libraries
  sudo /vagrant/bootstrap.sh
  /vagrant/tryit.sh
  sudo cp /tmp/localhost.localdomain-ssg-results.html /var/www/html/statedecoded/htdocs/ssg-results.html
  sudo cp /tmp/localhost.localdomain-ssg-results.xml /var/www/html/statedecoded/htdocs/ssg-results.xml
```

Your report will not be available at `http://localhost:8080/ssg-results.html` and `http://localhost:8080/ssg-results.xml`

## Security

This is box is being tested for the following security

- http://repos.fedorapeople.org/repos/scap-security-guide/epel-6-scap-security-guide.repo
- http://repos.fedorapeople.org/repos/gitopenscap/openscap/epel-6-openscap.repo

## Why CentOS instead of Ubuntu?
- Bit compatibility with RedHat Enterprise Linux (RHEL) since RHEL is popular with is common/popular among governments and businesses.
- We want cities to adopt Statedecoded and RHEL has government acceptance b/c it is built on SELinux (Security Enhanced Linux) 
- SELinux has elements, like default firewall (/etc/sysconfig/iptables) that Ubuntu does not
- OpenSCAP (Security Content Automation Protocols) and base line control configurations already exist for CentOS but do not yet for Ubuntu (from what we can tell). We need SCAP to produce the scans and audit reports to make Statedecoded accreditation-ready. 

## Why from scratch?
Why not just start from what [statedecoded-vagrant](https://github.com/statedecoded/statedecoded-vagrant) has?
- To learn.
- To deal easier with CentOS's built-in firewall.
- To automate OpenSCAP scanning and reporting.
- To see if we can streamline and further automate the install.
- To rethink how documentation can be managed and even driven from code.
- Because some installations will require the database to be run on a different server from the application and to have other redundancies. We want to understand how to create a path for varying configurations.

## ToDo
See the issues.
