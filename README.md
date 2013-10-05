# About

This repo is to create a GitMachines version of State Decoded on CentOS 6.

** Warning this is a work in progress **


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

## ToDo
