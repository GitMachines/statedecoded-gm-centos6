#!/bin/sh

oscap xccdf eval --profile test \
	--results /vagrant/`hostname`-ssg-test2-results.xml \
	--report /vagrant/`hostname`-ssg-test2-results.html \
	--cpe /vagrant/ssg/content/ssg-rhel6-cpe-dictionary.xml \
	/vagrant/ssg/content/ssg-rhel6-test2-xccdf.xml

