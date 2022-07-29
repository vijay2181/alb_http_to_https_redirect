# ALB http to https redirect, and SSL Certificate(ACM) in AWS with Terraform




![image](https://user-images.githubusercontent.com/66196388/181831914-edaf041b-7140-47c9-9bbf-17488a249ec2.png)



- fill all the required values in terraform.tfvars file

- enter "key-pair name" of aws

- configure profile in .aws/config file

- We need a public hosted zone on AWS Route 53, if we want to use AWS Certificate Manager to create and manage our SSL certificates.

- Go to the Route 53 console and create a new Public Hosted Zone with public domain(example.com), transfer the name servers into aws route 53 if your doamin is managed by other provider

- And update provider’s DNS records (this step can vary based on your DNS provider). Depending on our DNS provider, the change will take a few minutes to hours. After that, we will be able to manage our domain from AWS Route 53

- terraform init

- terraform plan and terraform apply

- we need to get into the instance and goto /tmp/configure directory, all the local files(Dockerfile,haproxy.cfg,docker-compose.yml) which are need to be pushed will be present on remote server

- chmod 755 /tmp/configure/*

- run "sudo docker-compose up -d" to build the go language app service container and reverse proxy container

- sudo docker ps

- check whether both containers are running

- goto the target group and check whether it is healthy or not

![image](https://user-images.githubusercontent.com/66196388/181834521-312650cc-3a16-4b81-9fed-f393a13a74f5.png)




- goto load balancer and check rules

- access the url with http://app.example.com and https://app.example.com both should redirect to https only

![image](https://user-images.githubusercontent.com/66196388/181833789-e8da079c-d02c-4c37-baba-20a1c1eb7c02.png)
