#!/bin/sh

oscap xccdf eval --profile stig-rhel6-server \
	--results /vagrant/`hostname`-ssg-results.xml \
	--report /vagrant/`hostname`-ssg-results.html \
	--cpe /usr/share/xml/scap/ssg/content/ssg-rhel6-cpe-dictionary.xml \
	/usr/share/xml/scap/ssg/content/ssg-rhel6-xccdf.xml

