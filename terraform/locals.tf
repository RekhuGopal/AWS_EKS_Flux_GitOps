locals {
  # AWS Provider
  aws_region  = "us-west-2"  # Update with aws region
  aws_profile = "bsisandbox" # Update with aws profile

  # Account ID
  account_id = data.aws_caller_identity.current.account_id

  # Tags
  owner       = "Dallin Rasmuson" # Update with owner name
  environment = "Sandbox"
  project     = "AWS EKS and FluxCD Lab"

  # VPC Configuration
  vpc_name = "eks-fluxcd-lab-vpc"
  vpc_cidr = "10.220.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  # ECR Configuration
  ecr_repo_name     = "eks-fluxcd-lab-react-app"

  # EKS Configuration
  eks_cluster_name                            = "eks-fluxcd-lab"
  eks_cluster_version                         = "1.28"
  eks_iam_role_prefix                         = "sa-eks-fluxcd-lab"
  eks_alb_service_account_name                = "sa-aws-load-balancer-controller"
  eks_external_dns_service_account_name       = "sa-external-dns"
  eks_cluster_autoscaler_service_account_name = "sa-cluster-autoscaler"

  # ACM and Route53 Configuration
  public_domain            = "dallin.brewsentry.com"              # Update with your root domain
  react_app_domain_name    = "react-app.dallin.brewsentry.com"    # Update with your custom domain name
  weave_gitops_domain_name = "weave-gitops.dallin.brewsentry.com" # Update with your custom domain name
  podinfo_domain_name      = "podinfo.dallin.brewsentry.com"      # Update with your custom domain name
  route53_zone_id          = data.aws_route53_zone.public_domain.zone_id
}
