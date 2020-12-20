# Jhub (JupyterHub on Kubernetes)

1. Create a jupyter namespace

    ```bash
    kubectl create ns jupyter
    ```
    
2. Create Service account and cluster role binding for Spark

    ```bash
    kubectl -n jupyter create serviceaccount spark
    kubectl -n jupyter create clusterrolebinding spark-role --clusterrole=edit --serviceaccount=jupyter:spark
    ```
# Only use if you have a image in docker hub
3. Create K8s secret to pull images from Dockerhub (https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/)

    ```bash
    kubectl -n jupyter create secret docker-registry dockerlogin \
    --docker-server=https://index.docker.io/v1/ \
    --docker-username=<username> \
    --docker-password=<password> \
    --docker-email=<email>
    ```

4. Install Helm Chart for JupyterHub

    ```bash
    make init
    make deploy-minimal
    make deploy-ingress
    ```

5. Access Jhub service

    ```bash
    kubectl port-forward --namespace jupyter service/proxy-public 8080:80
    ```

6. Access Spark UI 

    ```bash
    kubectl -n jupyter port-forward jupyter-prateek 4040:4040
    ```

# Deploy EKS Cluster Autoscaler 

https://docs.aws.amazon.com/eks/latest/userguide/cluster-autoscaler.html

# EKS Cluster Access 

https://aws.amazon.com/premiumsupport/knowledge-center/amazon-eks-cluster-access/
https://aws.amazon.com/premiumsupport/knowledge-center/eks-api-server-unauthorized-error/

# IAM Roles for Service Accounts 

https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html

# Spark on EKS with IRSA 

https://medium.com/@tunguyen9889/how-to-perform-a-spark-submit-to-amazon-eks-cluster-with-irsa-50af9b26cae

# Steps
virens-MBP:aws-resources virenkhandelwal$ rm -rf .terraform/
virens-MBP:aws-resources virenkhandelwal$ terraform init
virens-MBP:aws-resources virenkhandelwal$ terraform apply
virens-MBP:aws-resources virenkhandelwal$ aws eks --region us-east-1 update-kubeconfig --name billerxchange_ml
virens-MBP:aws-resources virenkhandelwal$ kubectl create ns jupyter
virens-MBP:aws-resources virenkhandelwal$ kubectl get ns
virens-MBP:aws-resources virenkhandelwal$ kubectl get nodes

# Using helm chart deploy Jupyter Hub
virens-MBP:terraform_eks virenkhandelwal$ cd notebook-hub/
virens-MBP:notebook-hub virenkhandelwal$ make init
virens-MBP:notebook-hub virenkhandelwal$ make deploy-minimal
# Using helm chart deploy Ingress
virens-MBP:notebook-hub virenkhandelwal$ make deploy-ingress

virens-MBP:notebook-hub virenkhandelwal$ kubectl port-forward --namespace jupyter service/proxy-public 8080:80
virens-MBP:notebook-hub virenkhandelwal$ kubectl -n jupyter get pods

# 
virens-MBP:notebook-hub virenkhandelwal$ kubectl create ns ingress-controller
virens-MBP:notebook-hub virenkhandelwal$ kubectl get service -n ingress-controller

