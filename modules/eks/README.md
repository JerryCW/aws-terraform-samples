# Amazon EKS Terraform Module

这个模块创建一个Amazon EKS集群，包含核心服务节点组、自定义Pod网络、常用附加组件和可选的Karpenter自动扩展。

## 功能

- EKS控制平面
- 托管节点组
- 核心EKS插件 (CoreDNS, kube-proxy, vpc-cni, eks-pod-identity-agent)
- 自定义Pod网络 (可选)
- 常用附加组件:
  - AWS Load Balancer Controller
  - Metrics Server
  - AWS EFS CSI Driver (可选)
  - Vertical Pod Autoscaler (可选)
- Karpenter自动扩展 (可选)

## 使用方法

### 基本用法

```hcl
module "eks" {
  source = "../../modules/eks"

  # 集群配置
  cluster_name    = "my-eks-cluster"
  cluster_version = "1.32"
  
  # 网络配置
  vpc_id     = "vpc-12345678"
  subnet_ids = ["subnet-12345678", "subnet-87654321"]

  # 节点组配置
  core_ng_instance_types = ["c7i.large"]
  core_ng_min_size       = 2
  core_ng_max_size       = 3
  core_ng_desired_size   = 2
  core_ng_disk_size      = 50
  
  # 标签
  tags = {
    Environment = "dev"
    Project     = "my-project"
  }
}
```

### 启用自定义Pod网络

```hcl
module "eks" {
  source = "../../modules/eks"

  # 基本配置...
  
  # 启用自定义Pod网络
  enable_custom_networking = true
  pod_subnet_ids           = ["subnet-pod1", "subnet-pod2", "subnet-pod3"]
  
  # 其他配置...
}
```

### 启用附加组件和Karpenter

```hcl
module "eks" {
  source = "../../modules/eks"

  # 基本配置...
  
  # 附加组件配置
  create_addons                       = true
  enable_aws_load_balancer_controller = true
  enable_metrics_server               = true
  enable_aws_efs_csi_driver           = true
  enable_vpa                          = true
  
  # Karpenter配置
  enable_karpenter = true
  
  # 其他配置...
}
```

## 输入变量

### 通用变量
| 名称 | 描述 | 类型 | 默认值 | 必填 |
|------|-------------|------|---------|:--------:|
| tags | 要添加到所有资源的标签 | `map(string)` | `{}` | 否 |

### 集群变量
| 名称 | 描述 | 类型 | 默认值 | 必填 |
|------|-------------|------|---------|:--------:|
| cluster_name | EKS集群名称 | `string` | n/a | 是 |
| cluster_version | Kubernetes版本 | `string` | n/a | 是 |
| vpc_id | VPC ID | `string` | n/a | 是 |
| subnet_ids | 子网ID列表 | `list(string)` | n/a | 是 |
| cluster_endpoint_public_access | 是否启用公共API端点 | `bool` | `true` | 否 |
| enable_cluster_creator_admin_permissions | 是否为集群创建者提供管理员权限 | `bool` | `true` | 否 |
| cluster_enabled_log_types | 要启用的控制平面日志类型 | `list(string)` | `["api", "audit", "authenticator"]` | 否 |
| create_cloudwatch_log_group | 是否为每种启用的日志类型创建CloudWatch日志组 | `bool` | `true` | 否 |

### 自定义网络变量
| 名称 | 描述 | 类型 | 默认值 | 必填 |
|------|-------------|------|---------|:--------:|
| enable_custom_networking | 是否启用自定义Pod网络 | `bool` | `false` | 否 |
| pod_subnet_ids | Pod ENI使用的子网ID列表 | `list(string)` | `[]` | 否 |

### 节点组变量
| 名称 | 描述 | 类型 | 默认值 | 必填 |
|------|-------------|------|---------|:--------:|
| core_ng_instance_types | 核心节点组的实例类型 | `list(string)` | `["c7i.large"]` | 否 |
| core_ng_min_size | 核心节点组的最小节点数 | `number` | `2` | 否 |
| core_ng_max_size | 核心节点组的最大节点数 | `number` | `2` | 否 |
| core_ng_desired_size | 核心节点组的期望节点数 | `number` | `2` | 否 |
| core_ng_disk_size | 核心节点组实例的磁盘大小(GB) | `number` | `20` | 否 |

### 附加组件变量
| 名称 | 描述 | 类型 | 默认值 | 必填 |
|------|-------------|------|---------|:--------:|
| create_addons | 是否创建附加组件 | `bool` | `true` | 否 |
| enable_aws_load_balancer_controller | 启用AWS Load Balancer Controller | `bool` | `true` | 否 |
| enable_metrics_server | 启用Metrics Server | `bool` | `true` | 否 |
| enable_aws_efs_csi_driver | 启用AWS EFS CSI Driver | `bool` | `false` | 否 |
| enable_vpa | 启用Vertical Pod Autoscaler | `bool` | `false` | 否 |

### Karpenter变量
| 名称 | 描述 | 类型 | 默认值 | 必填 |
|------|-------------|------|---------|:--------:|
| enable_karpenter | 启用Karpenter | `bool` | `false` | 否 |
| karpenter_helm_version | Karpenter Helm chart版本 | `string` | `"1.3.2"` | 否 |

## 输出

### 集群输出
| 名称 | 描述 |
|------|-------------|
| cluster_id | EKS集群ID |
| cluster_name | EKS集群名称 |
| cluster_endpoint | Kubernetes API服务器端点 |
| cluster_version | 集群的Kubernetes版本 |
| cluster_certificate_authority_data | 与集群通信所需的Base64编码证书数据 |
| cluster_iam_role_arn | EKS集群的IAM角色ARN |
| oidc_provider | OpenID Connect身份提供商(不含协议的发行者URL) |
| oidc_provider_arn | OIDC提供商的ARN |
| cluster_security_group_id | 集群安全组ID |
| node_security_group_id | 节点共享安全组ID |
| configure_kubectl | 配置kubectl的命令 |

### 自定义网络输出
| 名称 | 描述 |
|------|-------------|
| custom_networking_enabled | 是否启用了自定义网络 |
| eni_configs | 为自定义网络创建的ENI配置 |

### 节点组输出
| 名称 | 描述 |
|------|-------------|
| eks_managed_node_groups | EKS托管节点组 |
| core_node_group_id | 核心节点组ID |
| core_node_group_arn | 核心节点组ARN |
| core_node_group_status | 核心节点组状态 |
| node_group_role_arn | 节点组IAM角色ARN |

### 附加组件输出
| 名称 | 描述 |
|------|-------------|
| aws_load_balancer_controller_enabled | 是否启用了AWS Load Balancer Controller |
| metrics_server_enabled | 是否启用了Metrics Server |
| aws_efs_csi_driver_enabled | 是否启用了AWS EFS CSI Driver |
| vpa_enabled | 是否启用了Vertical Pod Autoscaler |

### Karpenter输出
| 名称 | 描述 |
|------|-------------|
| karpenter_enabled | 是否启用了Karpenter |
| karpenter_irsa_arn | Karpenter IRSA角色ARN |
| karpenter_node_role_arn | Karpenter节点IAM角色ARN |
| karpenter_queue_name | Karpenter SQS队列名称 |

## 注意事项

- 此模块使用官方的terraform-aws-modules/eks/aws模块
- 核心节点组配置了污点，以便将来可以使用Karpenter进行自动扩展
- 附加组件和Karpenter可以单独启用或禁用
- 所有附加组件都配置了容忍度，可以在核心服务节点上运行
- 启用自定义Pod网络需要额外的子网，这些子网应该与工作节点位于相同的可用区
