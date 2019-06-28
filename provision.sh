#!/bin/bash
# Provisioner script for Elastic Stack EC2 instance

#---------- INSTALL DEPENDENCIES ------------
sudo apt update

sudo apt install openjdk-11-jdk -y
#--------------------------------------------


#---------- INSTALL ELASTICSEARCH ----------- 
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.2.0-amd64.deb
sudo dpkg -i elasticsearch-7.2.0-amd64.deb

# Move configuration file and change permissions
sudo mv /tmp/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
sudo chown -R elasticsearch:elasticsearch /usr/share/elasticsearch
sudo chown -R elasticsearch:elasticsearch /etc/elasticsearch

# Enable and start service
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service
#--------------------------------------------


#------------ INSTALL KIBANA ----------------  
wget https://artifacts.elastic.co/downloads/kibana/kibana-7.2.0-amd64.deb
sudo dpkg -i kibana-7.2.0-amd64.deb
sudo sysctl -w vm.max_map_count=262144

sudo mv /tmp/kibana.yml /etc/kibana/kibana.yml

sudo systemctl daemon-reload
sudo systemctl enable kibana.service
sudo systemctl start kibana.service

# install logstash
wget https://artifacts.elastic.co/downloads/logstash/logstash-7.2.0.deb
sudo dpkg -i logstash-7.2.0.deb

sudo mv /tmp/logstash.yml /etc/logstash/logstash.yml

sudo systemctl daemon-reload
sudo systemctl start logstash.service
sudo systemctl enable logstash.service
#--------------------------------------------


#------------ INSTALL FILEBEAT --------------
sudo /usr/share/logstash/bin/logstash-plugin install logstash-input-beats

curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.2.0-amd64.deb
sudo dpkg -i filebeat-7.2.0-amd64.deb

sudo mv /tmp/filebeat.yml /etc/filebeat/filebeat.yml
sudo chown -R root:root /etc/filebeat

sudo systemctl enable filebeat.service
sudo systemctl start filebeat.service
sudo mv /tmp/beats.conf /etc/logstash/conf.d/beats.conf
sudo curl -XPUT 'http://127.0.0.1:9200/_template/filebeat' -d@/etc/filebeat/filebeat.template.json
#--------------------------------------------


#------------------ CLEANUP -----------------
# Remove deb files from home directory
rm ~/*deb
#--------------------------------------------
