# CentOS just got SCAP'd

## Dependencies
  * Latest version of vagrant (vagrantup.com)
  * Virtualbox with a certain version of guest additions (test this)

## Run this Shiz!

  `git clone git@github.com:GitMachines/gm-centos6.git`
  `vagrant up`
  `vagrant ssh`
  `./vagrant/tryit.sh`

## ToDo

  * Build rpm for (ssg-centos6)[https://github.com/GitMachines/ssg-centos6]
  * modify forked ss-centos6 to work for centos not rhel
  * automatically run scap process
  * set up webserver to display scap results on host machine's localhost
  * make the scap results look better