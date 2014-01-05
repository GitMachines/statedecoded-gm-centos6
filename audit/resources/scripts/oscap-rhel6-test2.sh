#!/bin/sh

echo "--profile test"

oscap xccdf eval --profile test \
	--results /vagrant/audit/reports/results-test-micro.xml \
	--report /vagrant/audit/reports/results-test-micro.html \
	--cpe /vagrant/audit/resources/ssg/content/ssg-rhel6-cpe-dictionary.xml \
	/vagrant/audit/resources/ssg/content/ssg-rhel6-test2-xccdf.xml

