# terraform-project-webserver
 This project is designed to create an infrastructure for a web server.

step by step of what was done
*Creating bucket s3 for store tfstate remotly in bucket S3
*Creating DynamoDB table to user for locking
*Creating vpc
*Creating an Internet Gateway
*Creating Custom Route Table
*Creating subnet
*Associating subnet with Route Table
*Creating Security Group to allow port 22,80,443
*Creating a network interface with an ip in the subnet that was created
*Assigning an elastic IP to the network interface created
*Creating Ubuntu server and install/enable apache2 with user_data scripts
*Outputs for receive web-server data
