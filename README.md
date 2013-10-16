# About

This repo is to create a GitMachines version of State Decoded on CentOS 6.

Our first goal is a **one-click install of Waldo Jacquith's [Statedecoded](http://www.statedecoded.com/)**.

Our second goal is **basic scans for security auditing** as part of the install.

Our third goal is **transparent documentation to make multi-machine configuration easier.** 

Our final goal is **a Statedecoded GitMachine - fully accreditation-ready, one-click install of Statedecoded on a virtual machine**, ready for easy adoption.


** Warning this is a work in progress - Please check branches for activity**

## How can I contribute?
We are learning as we go and do not yet clear asks to make of others. However, you can:
- Follow along, try things, and submit issues
- Fork, hack, and make pull requests (PLEASE keep these small for now and related to our project goals).

## Why this project?
The current [statedecoded-vagrant](https://github.com/statedecoded/statedecoded-vagrant) is helpful in setting up the environment on vagrant, but is not yet a one-click install. There are also has some gotchas we found in using it.

At GitMachines we are interested in one-click installs to get accreditation-ready builds in order to encourage adoption.

## Status
Follow along our repo, which will probably have many branches as we experiment. We've made this our main technical focus right now.

## Dependencies
  * Latest version of vagrant (vagrantup.com)
  * Latest version Virtualbox (4.2.10 guest additions on our base box)

## Instructions


```
  # Clone this repo locally to your computer and switch to repo directory.
  git clone git@github.com:GitMachines/statedecoded-gm-centos6.git
  cd statedecoded-gm-centos6
  
  # Launch your gitmachine 
  vagrant up
  # Browse the web, b/c this will take a while. 

  # SSH into your gitmachine and run the SCAP test
  vagrant ssh
  /vagrant/tryit.sh
```
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
