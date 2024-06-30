###################### EKS Create Cluster ##########################################################
eksctl create cluster -f cluster.yaml
aws eks update-kubeconfig --name <cluster name>
####################################################################################################

1. Create Namespace
kubectl create namespace flux-system

2. Pre-Check
flux check --pre

3. Set Temp environment values
$env:TMP = "flux-system"

4. Install Flux on EKS
flux bootstrap github `
  --owner="RekhuGopal" `
  --repository=AWS_EKS_Flux_GitOps `
  --branch=main `
  --path=.\apps `
  --personal

5. Create Flux Custom Resources
kubectl apply -f sync.yaml

6. Verify Installation
flux get kustomizations

7. See live logs
flux get kustomization --watch

================= Ingress Controllers ===============================
1. Create IAM Policy
aws iam create-policy `
  --policy-name ALBIngressControllerIAMPolicy `
  --policy-document file://ingresspolicy.json

2. Create the IAM Role for the ALB Ingress Controller:
eksctl create iamserviceaccount `
  --region us-west-2 `
  --name aws-load-balancer-controller `
  --namespace kube-system `
  --cluster fluxDemo `
  --attach-policy-arn arn:aws:iam::357171621133:policy/ALBIngressControllerIAMPolicy `
  --approve

3. Install the ALB Ingress Controller:
helm upgrade -i aws-load-balancer-controller eks/aws-load-balancer-controller `
  --set clusterName=fluxDemo `
  --set region=us-west-2 `
  --set vpcId=vpc-0a00cc1d1f8081eb9 `
  --set serviceAccount.create=false `
  --set serviceAccount.name=aws-load-balancer-controller `
  -n kube-system

## Verify and Troubleshoot
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller
kubectl describe ingress ui -n ui
kubectl get events -n ui --sort-by='.metadata.creationTimestamp'