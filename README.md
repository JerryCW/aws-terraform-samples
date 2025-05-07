# AWS Terraform 示例

这个仓库包含了使用Terraform在AWS上部署基础设施的示例代码。

## 项目结构

```
.
├── README.md                 # 项目说明文档
├── environments              # 不同环境的配置
│   ├── dev                   # 开发环境配置
│   ├── prod                  # 生产环境配置
│   └── staging               # 测试环境配置
├── main.tf                   # 主Terraform配置文件
├── modules                   # 可重用的Terraform模块
│   └── networking            # 网络相关模块
│       └── vpc               # VPC模块（子网、路由表、网关等）
├── outputs.tf                # 输出变量定义
├── providers.tf              # 提供商配置
├── variables.tf              # 变量定义
└── version.tf                # Terraform版本要求
```

## 使用方法

1. 初始化Terraform：
```bash
terraform init
```

2. 选择环境并应用配置：
```bash
terraform apply -var-file=environments/dev/terraform.tfvars
```

3. 销毁资源：
```bash
terraform destroy -var-file=environments/dev/terraform.tfvars
```

## 模块

### 网络模块 (networking/vpc)

包含VPC、子网、路由表、网关等网络资源的配置。

## 环境配置

### 开发环境 (dev)
- VPC CIDR: 10.0.0.0/16
- 次要CIDR: 100.64.0.0/16
- 单一NAT网关

### 测试环境 (staging)
- VPC CIDR: 10.1.0.0/16
- 次要CIDR: 100.65.0.0/16
- 单一NAT网关

### 生产环境 (prod)
- VPC CIDR: 10.2.0.0/16
- 次要CIDR: 100.66.0.0/16
- 每个可用区独立NAT网关
