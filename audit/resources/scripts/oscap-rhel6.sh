#!/bin/sh

echo "oscap xccdf eval --profile test"

oscap xccdf eval --profile test \
	--results /vagrant/audit/reports/results-test.xml \
	--report /vagrant/audit/reports/report-test.html \
	--cpe /usr/share/xml/scap/ssg/content/ssg-rhel6-cpe-dictionary.xml \
	/usr/share/xml/scap/ssg/content/ssg-rhel6-xccdf.xml

echo "oscap xccdf eval --profile stig-rhel6-server"

oscap xccdf eval --profile stig-rhel6-server \
	--results /vagrant/audit/reports/results-stig-rhel6-server.xml \
	--report /vagrant/audit/reports/report-stig-rhel6-server.html \
	--cpe /usr/share/xml/scap/ssg/content/ssg-rhel6-cpe-dictionary.xml \
	/usr/share/xml/scap/ssg/content/ssg-rhel6-xccdf.xml

