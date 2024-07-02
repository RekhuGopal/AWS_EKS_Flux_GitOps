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
  --path=".\apps" `
  --personal

5. Create Flux Custom Resources
kubectl apply -f apps.yaml

6. Verify Installation
flux get kustomizations

7. See live logs
flux get kustomization --watch

8. Manually trigger Flux to reconcile
flux reconcile source git flux-system -n flux-system

8. Port Forwarding to Access App
kubectl port-forward -n ui svc/ui 8080:80