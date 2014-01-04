#!/bin/sh

oscap xccdf eval --profile test \
	--results /vagrant/audit/reports/ssg-results-test2.xml \
	--report /vagrant/audit/reports/ssg-results-test2.html \
	--cpe /vagrant/audit/resources/ssg/content/ssg-rhel6-cpe-dictionary.xml \
	/vagrant/audit/resources/ssg/content/ssg-rhel6-test2-xccdf.xml

