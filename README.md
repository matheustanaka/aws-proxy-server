# AWS Proxy server with Squid

Creating an Proxy server with Squid and EC2 instance.

# Getting Started

### Clone repository 
```sh
git clone https://github.com/matheustanaka/aws-proxy-server

cd aws-proxy-server

```
### Create terraform vars

```sh
touch terraform.tfvars
```
Create a variable with your own ssh key. You can copy the content below and replace with your own information.
```sh
public_key = "replace with your ssh key content"
```
Then, don't forget to paste it inside the file **terraform.tfvars**

Also, you can replace the information below with your own IAM user and region that you want to launch your instance.

```hcl
public_key = "example"
profile    = "iam user name"
region     = "region name, like us-east-2 for example"
```

Replace with your own information and save.

### Start project

You should run one by one

```sh
# Init terraform 
terraform init
# Plan changes
terraform plan
# Apply change
terraform apply
```

# WARNING

You need to create a IAM user to run the project, you can follow a different approach of how to authenticate on aws and change the file **./providers.tf**.
If you decide to follow with IAM User, you can follow the documentation on this [link](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html)
Remember, without these steps you can't execute the project. You must have a user to login with AWS.

# How to use the Proxy server

When you launch your ec2 instance, you can copy the **public ip address** of ec2 instance and then access your network configuration and select
**HTTPS Proxy**.

Then, you can paste the public ip address there and configure the port to use **3128**, the default port of squid.

That's it, your proxy server is configured and "free to use".
