# ops-eks-deployer

Deploy an EKS cluster with node group running on private subnets using cloudformation.

Creates a vpc that can be shared with other clusters.

All info gleened/derived from what `eksctl` produces.

## How?

* authenticate to aws and set AWS_DEFAULT_REGION

* create a vpc which can be shared with multiple clusters

  ```
  ./bin/deploy-vpc development
  ```

* create a bastion asg for use within the vpc

  ```
  ./bin/deploy bastion development
  ```

* create security groups for a cluster

  ```
  ./bin/deploy securitygroups lebkuchen
  ```

* tag subnets and vpc for a cluster

  ```
  ./bin/tag-resources development lebkuchen
  ```

* create the controlplane for a cluster

  ```
  ./bin/deploy controlplane lebkuchen
  ```

* generate kubernetes config

  ```
  aws eks update-kubeconfig --name lebkuchen
  ```

* get arn for node role from controlplane stack exports
* update aws-auth-cm.yaml with node instance role arn (todo script this)
* apply cm yaml
  ```
  kubectl apply -f aws-auth-cm.yaml
  ```

* create the nodes for a cluster
  ```
  ./bin/deploy nodes lebkuchen
  ```

Info about eks kubernetes veersions, patch releases and admission controllers can be found [here](https://docs.aws.amazon.com/eks/latest/userguide/platform-versions.html)


### eksctl example

An example of eksctl that produces a similar result

```
% eksctl create cluster --name=diablo --version=1.11 --auto-kubeconfig --nodes-min=1 --nodes-max=4 --node-type=t2.large --ssh-access --ssh-public-key=~/.ssh/kluster.pub --region=ap-southeast-2 --node-private-networking
[ℹ]  using region ap-southeast-2
[ℹ]  setting availability zones to [ap-southeast-2a ap-southeast-2b ap-southeast-2c]
[ℹ]  subnets for ap-southeast-2a - public:192.168.0.0/19 private:192.168.96.0/19
[ℹ]  subnets for ap-southeast-2b - public:192.168.32.0/19 private:192.168.128.0/19
[ℹ]  subnets for ap-southeast-2c - public:192.168.64.0/19 private:192.168.160.0/19
[ℹ]  nodegroup "ng-83542ece" will use "ami-06ade0abbd8eca425" [AmazonLinux2/1.11]
[ℹ]  importing SSH public key "/Users/ians/.ssh/infrastructure-sharedservices.pub" as "eksctl-diablo-nodegroup-ng-83542ece-03:a5:f6:81:61:7c:c7:a2:fa:6d:9f:81:88:1f:85:67"
[ℹ]  creating EKS cluster "diablo" in "ap-southeast-2" region
[ℹ]  will create 2 separate CloudFormation stacks for cluster itself and the initial nodegroup
[ℹ]  if you encounter any issues, check CloudFormation console or try 'eksctl utils describe-stacks --region=ap-southeast-2 --name=diablo'
[ℹ]  creating cluster stack "eksctl-diablo-cluster"
[ℹ]  creating nodegroup stack "eksctl-diablo-nodegroup-ng-83542ece"
[ℹ]  as --nodes-min=1 and --nodes-max=4 were given, default value of --nodes=2 was kept as it is within the set range
[✔]  all EKS cluster resource for "diablo" had been created
[✔]  saved kubeconfig as "/Users/ians/.kube/eksctl/clusters/diablo"
[ℹ]  nodegroup "ng-83542ece" has 0 node(s)
[ℹ]  waiting for at least 1 node(s) to become ready in "ng-83542ece"
[ℹ]  nodegroup "ng-83542ece" has 2 node(s)
[ℹ]  node "ip-192-168-152-48.ap-southeast-2.compute.internal" is ready
[ℹ]  node "ip-192-168-175-176.ap-southeast-2.compute.internal" is not ready
[ℹ]  kubectl command should work with "/Users/ians/.kube/eksctl/clusters/diablo", try 'kubectl --kubeconfig=/Users/ians/.kube/eksctl/clusters/diablo get nodes'
[✔]  EKS cluster "diablo" in "ap-southeast-2" region is ready

```
