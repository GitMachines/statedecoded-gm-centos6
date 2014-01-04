#!/bin/sh

oscap xccdf eval --profile test \
	--results /vagrant/audit/reports/ssg-results-test2.xml \
	--report /vagrant/ssg-results-test2.html \
	--cpe /vagrant/resources/ssg/content/ssg-rhel6-cpe-dictionary.xml \
	/vagrant/resources/ssg/content/ssg-rhel6-test2-xccdf.xml

