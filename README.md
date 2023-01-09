# terraform-project-webserver
 This project is designed to create an infrastructure for a web server.

Step by Step of what was done  
*Created Bucket S3 for store tfstate remotly in cloud  
*Created DynamoDB table to user for locking  
*Created VPC  
*Creating an Internet Gateway  
*Created Custom Route Table  
*Created Subnet  
*Associating Subnet with Route Table  
*Created Security Group to allow port 22,80,443  
*Created a Network Interface with an ip in the Subnet that was created  
*Assigning an Elastic IP to the Network Interface created  
*Created Ubuntu Server and install/enable apache2 with user_data scripts  
*Outputs for receive web-server data  
