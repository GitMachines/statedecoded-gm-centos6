# Status

| Date         | Status | Time to Build |
|--------------|-------------|-------------|
| Feb 09, 2014 Updated| VM OK. Statedecoded OK. Search import failed two attempts. Re-running importing laws worked. SCAP Scan ran OK.|real 32m15.545s; user 0m18.449s; sys 0m14.330s|
| Feb 08, 2014 Updated| VM OK. Statedecoded OK. Search OK. SCAP Scan ran OK.|real 31m10.238s; user 0m18.278s; sys 0m14.017s|
| Feb 06, 2014 Updated| VM OK. Statedecoded OK. Search OK. SCAP Scan ran OK.|real 35m1.503s; user 0m18.239s; sys 0m13.442s|
| Feb 04, 2014 Updated| VM OK. Statedecoded OK. Search OK. SCAP Scan ran OK.|real 32m0.920s; user 0m17.539s; sys 0m13.440s |


For previous status tests see [STATUS.md](STATUS.md)

# About

This repo is to create a GitMachines version of State Decoded on CentOS 6.

Our goals:

- [x] First, a **one-click install of Waldo Jacquith's [Statedecoded](http://www.statedecoded.com/)**.
- [X] Second, **basic scans for security auditing** as part of the install. (in progress as of 01.04.2014)
- [] Third, **transparent documentation to make multi-machine configuration easier.** 
- [] Finally, **a Statedecoded GitMachine - fully accreditation-ready, one-click install of Statedecoded on a virtual machine**, ready for easy adoption.

** Warning this is a work in progress - Please check branches for activity**

# Versions

## 
| Version | Description |
|---------|-------------|
| v0.4.0  | Fully automatic build of State Decoded including configuring of Solr, loading sample laws, and running SCAP scan to generate reports.|
| v0.3.0 audit-stub | One-click build of StateDecoded from a released version on localhost:8080 (including Solr running with Tomcat6). Subset of Virginia imported from project warehouse for reliability. Import tested. Laws import. Bulk exports prepared. Laws indexed in Solr. Links to text and xml versions of law work. Bulk dowload works. Added audit folder and simpler test profile to run scap easier. |
| v0.2.3 nicer++.1 | One-click build of StateDecoded on localhost:8080 (including Solr running with Tomcat6). Virginia laws prepared for import. Import tested. Laws import. Bulk exports prepared. Laws indexed in Solr. Links to text and xml versions of law work. Bulk dowload works. Separate script to run SCAP report. OS not yet locked down. |
| v0.2 nicer | one-click install to working StateDecoded localhost:8080, tomcat6, solr. Ready to import Virginia laws. Solr not populated. No auto security check. | 
| v0.1 nice | one-click install to working localhost:8080, no xml, no solr. |

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
8. Automatically runs SCAP security scan using oscap and produces report
9. Automatically imports subset sample of Virginia laws


### What user needs to do...
1. Open terminal
2. Clone repo `git clone git@github.com:GitMachines/statedecoded-gm-centos6.git`
3. Change directory into `statedecoded-gm-centos6`
2. Type `vagrant up` 
3. Surf web for ~20 minutes (may vary with speed of connection)
4. Wait ~10 minutes while sample laws automatically imported, bulk exports prepared, and laws get indexed by Solr
5. Type `open audit/home.html` to open your GitMachines control page

## Dependencies
  * Latest version of vagrant (vagrantup.com)
  * Latest version Virtualbox (4.2.10 guest additions on our base box)
  * Do not have service running on ports 8080 or 8081 on host computer.

## Instructions

### One-click build and (simple) audit run
```
  # Clone this repo locally to your computer and switch to repo directory.
  git clone git@github.com:GitMachines/statedecoded-gm-centos6.git
  cd statedecoded-gm-centos6
  
  # Stop any running virtual machines that might conflict on ports 8080 and 8081.
  # Launch your gitmachine 
  vagrant up
  # Browse the web, b/c this will take ~ 30 minutes or more. 

  # Your statedecoded GitMachines is running on http://localhost:8080
  # Sample laws have been imported
  # Openscap has been installed and a very (very) simple scan is run 

  # Check out your GitMachine!
  # If a browser does not open on its own, enter the below line on command line
  open audit/home.html

```

### (Optional) SSH into your gitmachine and run the SCAP test manually
You can run your own audit checks using installed openscap `oscap` from the command line steps.

``` 
  vagrant ssh
  
  # Re-run sample scap script
  /vagrant/resources/scripts/oscap-rhel6.sh

  # Reports are available in audit/reports directory.

  # Want to run your own scan, here is the command format from oscap-rhel6.sh

oscap xccdf eval --profile stig-rhel6-server \
  --results /vagrant/audit/reports/results-stig-rhel6-server.xml \
  --report /vagrant/audit/reports/report-stig-rhel6-server.html \
  --cpe /usr/share/xml/scap/ssg/content/ssg-rhel6-cpe-dictionary.xml \
  /usr/share/xml/scap/ssg/content/ssg-rhel6-xccdf.xml

```


### Adding Laws
Your statedecoded will look a bit lame without any laws. We've pre-configured everything to use Virginia's laws as a sample.

To change the laws you will need to follow the below steps.

### (Optional) Install Laws for a Different State
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
