# terraform-project-webserver
 This project is designed to create an infrastructure for a web server.

Step by Step of what was done  
*Created bucket s3 for store tfstate remotly in bucket S3  
*Created DynamoDB table to user for locking  
*Created vpc  
*Creating an Internet Gateway  
*Created Custom Route Table  
*Created subnet  
*Associating subnet with Route Table  
*Created Security Group to allow port 22,80,443  
*Created a network interface with an ip in the subnet that was created  
*Assigning an elastic IP to the network interface created  
*Created Ubuntu server and install/enable apache2 with user_data scripts  
*Outputs for receive web-server data  
