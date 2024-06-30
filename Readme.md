## Flux bootstrap
choco install flux

## Create a Namespace for flux
kubectl create namespace flux-system

## Install Flux on EKS
flux bootstrap github \
  --owner=GITHUB_USER \
  --repository=GITHUB_REPO \
  --branch=main \
  --path=./clusters/my-cluster \
  --personal
