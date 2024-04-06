#!/usr/bin/env bash

function replace_in_file() {
    if [ "$(uname)" == "Darwin" ]; then
        # Do something under Mac OS X platform
        sed -i '' -e "$1" "$2"
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        sed -i -e "$1" "$2"
    fi
}

echo "Gathering AWS Resources and Names necessary to run the Kubernetes Applications and Services deployed by Flux from Terraform Output..."
echo "Hang on..."
echo "This can take between 30 to 90 seconds..."

cd ../terraform
AWS_REGION=$(terraform output -raw aws_region)
EKS_CLUSTER_NAME=$(terraform output -raw eks_cluster_name)
EXTERNAL_DNS_DOMAIN_FILTER=$(terraform output -raw domain_filter)
SA_ALB_NAME=$(terraform output -raw eks_sa_alb_name)
SA_ALB_IAM_ROLE_ARN=$(terraform output -raw eks_sa_alb_iam_role_arn)
SA_EXTERNAL_DNS_NAME=$(terraform output -raw eks_sa_external_dns_name)
SA_EXTERNAL_DNS_IAM_ROLE_ARN=$(terraform output -raw eks_sa_external_dns_iam_role_arn)
SA_CLUSTER_AUTOSCALER_NAME=$(terraform output -raw eks_sa_cluster_autoscaler_name)
SA_CLUSTER_AUTOSCALER_IAM_ROLE_ARN=$(terraform output -raw eks_sa_cluster_autoscaler_iam_role_arn)
AWS_WEAVE_GITOPS_DOMAIN_NAME=$(terraform output -raw weave_gitops_domain_name)
AWS_ACM_WEAVE_GITOPS_ARN=$(terraform output -raw weave_gitops_acm_certificate_arn)
AWS_PODINFO_DOMAIN_NAME=$(terraform output -raw podinfo_domain_name)
AWS_ACM_PODINFO_ARN=$(terraform output -raw podinfo_acm_certificate_arn)
AWS_REACT_APP_DOMAIN_NAME=$(terraform output -raw react_app_domain_name)
AWS_ACM_REACT_APP_ARN=$(terraform output -raw react_app_acm_certificate_arn)
REACT_APP_GITHUB_URL="https://github.com/junglekid/aws-eks-fluxcd-lab"
ECR_REPO=$(terraform output -raw ecr_repo_url)

echo ""
echo "Configuring Apps managed by FluxCD..."
echo ""

cd ..
cp -f ./k8s/templates/apps/base/podinfo.yaml ./k8s/apps/base/podinfo.yaml
replace_in_file 's|AWS_PODINFO_DOMAIN_NAME|'"$AWS_PODINFO_DOMAIN_NAME"'|g' ./k8s/apps/base/podinfo.yaml
replace_in_file 's|AWS_ACM_PODINFO_ARN|'"$AWS_ACM_PODINFO_ARN"'|g' ./k8s/apps/base/podinfo.yaml

cp -f ./k8s/templates/apps/base/weave-gitops.yaml ./k8s/apps/base/weave-gitops.yaml
replace_in_file 's|AWS_WEAVE_GITOPS_DOMAIN_NAME|'"$AWS_WEAVE_GITOPS_DOMAIN_NAME"'|g' ./k8s/apps/base/weave-gitops.yaml
replace_in_file 's|AWS_ACM_WEAVE_GITOPS_ARN|'"$AWS_ACM_WEAVE_GITOPS_ARN"'|g' ./k8s/apps/base/weave-gitops.yaml

cp -f ./k8s/templates/apps/base/react-app.yaml ./k8s/apps/base/react-app.yaml
replace_in_file 's|AWS_REACT_APP_DOMAIN_NAME|'"$AWS_REACT_APP_DOMAIN_NAME"'|g' ./k8s/apps/base/react-app.yaml
replace_in_file 's|AWS_ACM_REACT_APP_ARN|'"$AWS_ACM_REACT_APP_ARN"'|g' ./k8s/apps/base/react-app.yaml
replace_in_file 's|ECR_REPO|'"$ECR_REPO"'|g' ./k8s/apps/base/react-app.yaml

cp -f ./k8s/templates/apps/sources/react-app.yaml ./k8s/apps/sources/react-app.yaml
replace_in_file 's|REACT_APP_GITHUB_URL|'"$REACT_APP_GITHUB_URL"'|g' ./k8s/apps/sources/react-app.yaml

cp -f ./k8s/templates/infrastructure/addons/aws-load-balancer-controller.yaml ./k8s/infrastructure/addons/aws-load-balancer-controller.yaml
replace_in_file 's|SA_ALB_NAME|'"$SA_ALB_NAME"'|g' ./k8s/infrastructure/addons/aws-load-balancer-controller.yaml
replace_in_file 's|SA_ALB_IAM_ROLE_ARN|'"$SA_ALB_IAM_ROLE_ARN"'|g' ./k8s/infrastructure/addons/aws-load-balancer-controller.yaml
replace_in_file 's|AWS_REGION|'"$AWS_REGION"'|g' ./k8s/infrastructure/addons/aws-load-balancer-controller.yaml
replace_in_file 's|EKS_CLUSTER_NAME|'"$EKS_CLUSTER_NAME"'|g' ./k8s/infrastructure/addons/aws-load-balancer-controller.yaml

cp -f ./k8s/templates/infrastructure/addons/external-dns.yaml ./k8s/infrastructure/addons/external-dns.yaml
replace_in_file 's|EXTERNAL_DNS_DOMAIN_FILTER|'"$EXTERNAL_DNS_DOMAIN_FILTER"'|g' ./k8s/infrastructure/addons/external-dns.yaml
replace_in_file 's|SA_EXTERNAL_DNS_NAME|'"$SA_EXTERNAL_DNS_NAME"'|g' ./k8s/infrastructure/addons/external-dns.yaml
replace_in_file 's|SA_EXTERNAL_DNS_IAM_ROLE_ARN|'"$SA_EXTERNAL_DNS_IAM_ROLE_ARN"'|g' ./k8s/infrastructure/addons/external-dns.yaml
replace_in_file 's|AWS_REGION|'"$AWS_REGION"'|g' ./k8s/infrastructure/addons/external-dns.yaml
replace_in_file 's|EKS_CLUSTER_NAME|'"$EKS_CLUSTER_NAME"'|g' ./k8s/infrastructure/addons/external-dns.yaml

cp -f ./k8s/templates/infrastructure/addons/cluster-autoscaler.yaml ./k8s/infrastructure/addons/cluster-autoscaler.yaml
replace_in_file 's|SA_CLUSTER_AUTOSCALER_NAME|'"$SA_CLUSTER_AUTOSCALER_NAME"'|g' ./k8s/infrastructure/addons/cluster-autoscaler.yaml
replace_in_file 's|SA_CLUSTER_AUTOSCALER_IAM_ROLE_ARN|'"$SA_CLUSTER_AUTOSCALER_IAM_ROLE_ARN"'|g' ./k8s/infrastructure/addons/cluster-autoscaler.yaml
replace_in_file 's|AWS_REGION|'"$AWS_REGION"'|g' ./k8s/infrastructure/addons/cluster-autoscaler.yaml
replace_in_file 's|EKS_CLUSTER_NAME|'"$EKS_CLUSTER_NAME"'|g' ./k8s/infrastructure/addons/cluster-autoscaler.yaml

echo ""
echo "Pushing changes to Git repository..."
echo ""

git add ./k8s/apps/base/podinfo.yaml
git add ./k8s/apps/base/weave-gitops.yaml
git add ./k8s/apps/base/react-app.yaml
git add ./k8s/apps/sources/react-app.yaml
git add ./k8s/infrastructure/addons/aws-load-balancer-controller.yaml
git add ./k8s/infrastructure/addons/external-dns.yaml
git add ./k8s/infrastructure/addons/cluster-autoscaler.yaml

git commit -m "Updating Apps"
git push &> /dev/null

echo ""
echo "Finished configuring Apps managed by FluxCD..."
