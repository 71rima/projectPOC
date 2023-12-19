#!/bin/bash
sudo su
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
EC2AZ=$(TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` && curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/placement/availability-zone)
sed "s/AZID/$EC2AZ/" /var/www/html/index.txt > /var/www/html/index.html
EC2ID=$(TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` && curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/placement/instance-id)
sed "s/EC2ID/$EC2ID/" /var/www/html/index.txt > /var/www/html/index.html
echo '<center><h1>This Amazon EC2 instance (ID: EC2ID) is located in Availability Zone: AZID </h1></center>' > /var/www/html/index.txt