# ops-eks-deployer

Deploy an EKS cluster with node group running on private subnets using cloudformation.

Creates a vpc that can be shared with other clusters.

All info gleened/derived from what `eksctl` produces.

## Why?

To understand what an EKS cluster needs so as to mould into my own image of a perfect environment.

## How?

A vpc is given a name which is then referenced by eks cluster component cloudformation stacks. Let's assume you call your vpc `development`.

An eks cluster is given a unique name or identifier. In the examples below, the cluster is called `lebkuchen` which matches the names of parameter files under each component folder. Decide on your cluster name then copy the `(securitygroups|controlplane|nodes)/params/example.yml` parameter files to your chosen `clustername.yml` files under each folder. Then...

* authenticate to aws and set AWS_DEFAULT_REGION appropriately

* create a vpc which can be shared with multiple clusters

  ```
  docker-compose run --rm sh ./bin/deploy-vpc development
  ```

* create an eks cluster

  ```
  docker-compose run --rm sh ./bin/deploy-cluster lebkuchen
  ```

The deploy-cluster script wraps up a number of steps for ease of deployment. Take a look inside if you as it's all pretty straighforward.


More info about eks kubernetes versions, patch releases and admission controllers can be found [here](https://docs.aws.amazon.com/eks/latest/userguide/platform-versions.html)


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
