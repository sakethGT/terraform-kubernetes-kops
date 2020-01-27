apiVersion: kops/v1alpha2
kind: InstanceGroup
metadata:
  labels:
    kops.k8s.io/cluster: ${cluster_name}
  name: master-us-east-1${az_id}
spec:
  nodeLabels:
    kops.k8s.io/instancegroup: master-us-east-1${az_id}
  role: Master
  subnets:
  - us-east-1{az_id}
