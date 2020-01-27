apiVersion: kops/v1alpha2
kind: InstanceGroup
metadata:
  creationTimestamp: 2018-05-01T17:18:03Z
  labels:
    kops.k8s.io/cluster: ${cluster_name}
  name: nodes
spec:
  nodeLabels:
    kops.k8s.io/instancegroup: nodes
  role: Node
