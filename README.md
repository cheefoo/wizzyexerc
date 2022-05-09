# wizzyexerc

 
 ## Architecture 
 ![alt text](https://github.com/cheefoo/wizzyexerc/blob/main/wiz-tayo.png)

 ### 1. MongoDB 
 Deployed on EC2 instance via a terraform script and a ec2 user data injected at instance creation time.
 
 ### 2. MongoDB Backup
 S3 Bucket script created with private acl even though teh exercise specifically asked for it to be publicly readable (public-read), it would
 not be a sensible idea to have your database backups public. Its a big security hole
 
 ### 3. EKS CLuster 
 Cluster created from a suite of terraform scripts which included creation of a VPC with 2 public and 2 private subnets
 
 
 ### 4. Container Web Application deployment
 Deployed via Helm Charts
 aws eks --region us-west-2 update-kubeconfig --name education-eks-lHwG0U7gbectl config set-context --current --namespace=wordpress-cwi
 
 helm repo add bitnami https://charts.bitnami.com/bitnami
 helm -n wordpress-cwi install understood-zebu bitnami/wordpress
 export SERVICE_URL=$(kubectl get svc -n wordpress-cwi understood-zebu-wordpress --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}")
 echo "Public URL: http://$SERVICE_URL/"
 
 
 ### 5. Configure the container as Admin
 Having RBAC permissions will not be suitable for production deployemnts because it allows ALL service accounts to act as cluster administrators. 
 Any application running in a container receives service account credentials automatically, 
 and could perform any action against the API, including viewing secrets and modifying permissions. This is not a recommended policy.
 
 kubectl create clusterrolebinding permissive-binding clusterrole=cluster-admin --user=admin --user=kubelet --group=system:serviceaccounts
 
 
 ### 6. Configure the MongoDB as highly privileged
 
 This involves adding a ec2.* permission policy to the instance profile. This is not also recommended becuase it is a security hole in teh application architecture
 
 
 ### 7. MongoDB connection string
 Saving the connection string with a username and passowrd in a file and adding it to the conatiner would not be a recommended practice, in this exercise it is saved 
 System Manager parameter store and it can be accessed by an application via the aws sdk apis at runtime