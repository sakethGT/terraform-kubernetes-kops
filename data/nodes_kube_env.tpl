Assets:
- ef979a00ba2f7bf4ee5023e82f94ced2d94c1726@https://storage.googleapis.com/kubernetes-release/release/v1.9.3/bin/linux/amd64/kubelet
- a27d808eb011dbeea876fe5326349ed167a7ed28@https://storage.googleapis.com/kubernetes-release/release/v1.9.3/bin/linux/amd64/kubectl
- d595d3ded6499a64e8dac02466e2f5f2ce257c9f@https://storage.googleapis.com/kubernetes-release/network-plugins/cni-plugins-amd64-v0.6.0.tgz
- c6f310214f687b6c2f32e81c2a49235182950be3@https://kubeupv2.s3.amazonaws.com/kops/1.9.0/linux/amd64/utils.tar.gz
ClusterName: ${cluster_name}
ConfigBase: s3://${config_bucket}/${cluster_name}
InstanceGroupName: nodes
Tags:
- _automatic_upgrades
- _aws
- _networking_cni
channels:
- s3://${config_bucket}/${cluster_name}/addons/bootstrap-channel.yaml
protokubeImage:
  hash: 4bbfcc6df1c1c0953bd0532113a74b7ae21e0ded
  name: protokube:1.9.0
  source: https://kubeupv2.s3.amazonaws.com/kops/1.9.0/images/protokube.tar.gz
