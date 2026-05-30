# DevOps Final Project - Multi-Node Private DNS Automation

## Team Members
* Ifrat
* Syrym
* Nursayat

## Project Description
Initially we planned to use AWS Academy and GitLab for this project. However, our AWS Academy student course ended and got locked, so we could not connect external tools. To complete the final project on time, we moved our deployment to a personal AWS Free Tier account and automated the workflow using GitHub Actions. The pipeline logic is exactly identical to the required task.

## Infrastructure and Zero Cost Design (Option C)
To ensure we do not get charged on a personal AWS account, we chose Option C (Offline/Proxy configuration) instead of a paid NAT Gateway:

* 5 EC2 Instances: All nodes (bastion, ns1, ns2, host1, host2) use the t2.micro size, keeping everything 100% inside the AWS Free Tier limits.
* Network Setup: Only the bastion host has a public IP address to access the cluster. The rest of the nodes (ns1, ns2, host1, host2) are isolated inside fully private subnets with no public internet route.
* Tinyproxy via Bastion: To let the private instances install BIND9 without a NAT Gateway, we installed Tinyproxy on port 8888 on the Bastion host. The private nodes route their package updates through this internal proxy.

## Automated CI/CD Pipeline Workflow
Our deploy.yml workflow executes the following steps automatically on every push:
1. Terraform Validate & Plan: Checks the configuration files for infrastructure correctness.
2. Terraform Apply: Deploys the custom VPC, subnets, security groups, and boots up all 5 servers.
3. Dynamic Inventory Generation: Takes the fresh private IPs from Terraform outputs and creates the inventory.ini file for Ansible.
4. Ansible Playbook Execution: Connects using an SSH ProxyJump through the Bastion host to install and configure BIND9 (Primary DNS on ns1, Secondary DNS on ns2).
5. Automated Verification: Runs automated dig and nslookup tests directly from the client hosts to prove the private DNS zones resolve accurately.

## Project Teardown
Once the project is graded and reviewed, we can manually trigger our destroy.yml workflow to run terraform destroy. This ensures all AWS cloud resources are completely wiped out to prevent any background resource leaks.
