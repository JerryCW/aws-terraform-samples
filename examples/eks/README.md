# EKS Custom Networking Example

这个示例展示了如何使用EKS模块创建一个带有自定义Pod网络的Amazon EKS集群。

## 前提条件

- 已有的VPC和子网
- 为Pod ENI准备的额外子网（与工作节点位于相同的可用区）
- 子网应该已经配置了适当的标签：
  - 私有子网: `kubernetes.io/role/internal-elb=1`
  - 公有子网: `kubernetes.io/role/elb=1`

## 功能

此示例创建的EKS集群包括：

- EKS控制平面（Kubernetes 1.32）
- 托管节点组（c7i.large实例）
- 自定义Pod网络（使用专用子网）
- 核心EKS插件 (CoreDNS, kube-proxy, vpc-cni, eks-pod-identity-agent)
- 常用附加组件:
  - AWS Load Balancer Controller
  - Metrics Server
  - AWS EFS CSI Driver
  - Vertical Pod Autoscaler
- Karpenter自动扩展

## 自定义Pod网络

自定义Pod网络允许您将Pod放置在与工作节点不同的子网中，这有以下好处：

1. **IP地址管理**：可以为Pod分配更大的IP地址范围，避免IP地址耗尽问题
2. **网络隔离**：可以将Pod与工作节点放在不同的子网中，实现更好的网络隔离
3. **安全组控制**：可以为Pod ENI分配特定的安全组，实现更精细的网络安全控制

## 配置

所有配置都在`terraform.tfvars`文件中定义，您需要根据自己的环境修改以下值：

- `vpc_id`: 您的VPC ID
- `subnet_ids`: 您的节点子网ID列表（应该是私有子网）
- `pod_subnet_ids`: 您的Pod子网ID列表（应该与节点子网位于相同的可用区）
- 其他参数可以根据需要调整

## 使用方法

1. 修改`terraform.tfvars`文件，设置正确的VPC和子网ID：

```hcl
vpc_id     = "vpc-0123456789abcdef0"
subnet_ids = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1", "subnet-0123456789abcdef2"]
pod_subnet_ids = ["subnet-pod0123456789abcdef0", "subnet-pod0123456789abcdef1", "subnet-pod0123456789abcdef2"]
```

2. 初始化Terraform：

```bash
terraform init
```

3. 查看执行计划：

```bash
terraform plan
```

4. 应用更改：

```bash
terraform apply
```

5. 配置kubectl：

```bash
aws eks update-kubeconfig --region us-west-2 --name eks-custom-net-demo
```

或者使用Terraform输出的命令：

```bash
$(terraform output -raw configure_kubectl)
```

## 验证自定义网络

部署完成后，您可以验证自定义网络是否正常工作：

1. 检查ENIConfig资源：

```bash
kubectl get eniconfigs
```

2. 部署一个测试Pod并检查其IP地址：

```bash
kubectl run nginx --image=nginx
kubectl get pod nginx -o wide
```

Pod的IP地址应该来自Pod子网的CIDR范围。

## 清理

删除所有资源：

```bash
terraform destroy
```

## 注意事项

- 确保Pod子网与节点子网位于相同的可用区
- Pod子网应该有足够的IP地址空间
- 确保Pod子网的路由表配置正确，以便Pod可以访问互联网和其他AWS服务
- 自定义网络需要VPC CNI插件的特殊配置，这已经在模块中处理
