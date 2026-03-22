metadata:
  name: ${cluster_name}
spec:
  api:
    loadBalancer:
      type: Public
  authorization:
    rbac: {}
  channel: stable
  cloudProvider: aws
  clusterDNSDomain: cluster.local
  configBase: s3://${config_bucket}/${cluster_name}
  configStore: s3://${config_bucket}/${cluster_name}
  dnsZone: ${cluster_zone_id}
  docker:
    bridge: ""
    ipMasq: false
    ipTables: false
    logDriver: json-file
    logLevel: warn
    logOpt:
    - max-size=10m
    - max-file=5
    storage: overlay,aufs
    version: 1.12.6
  etcdClusters:
  - etcdMembers:
    - instanceGroup: master-us-east-1a
      name: a
    - instanceGroup: master-us-east-1b
      name: b
    - instanceGroup: master-us-east-1c
      name: c
    image: gcr.io/google_containers/etcd:2.2.1
    name: main
    version: 2.2.1
  - etcdMembers:
    - instanceGroup: master-us-east-1a
      name: a
    - instanceGroup: master-us-east-1b
      name: b
    - instanceGroup: master-us-east-1c
      name: c
    image: gcr.io/google_containers/etcd:2.2.1
    name: events
    version: 2.2.1
  iam:
    allowContainerRegistry: true
    legacy: false
  keyStore: s3://${config_bucket}/${cluster_name}/pki
  kubeAPIServer:
    address: 127.0.0.1
    admissionControl:
    - Initializers
    - NamespaceLifecycle
    - LimitRanger
    - ServiceAccount
    - PersistentVolumeLabel
    - DefaultStorageClass
    - DefaultTolerationSeconds
    - MutatingAdmissionWebhook
    - ValidatingAdmissionWebhook
    - NodeRestriction
    - ResourceQuota
    - Priority
    allowPrivileged: true
    anonymousAuth: false
    apiServerCount: 3
    authorizationMode: RBAC
    cloudProvider: aws
    etcdQuorumRead: false
    etcdServers:
    - http://127.0.0.1:4001
    etcdServersOverrides:
    - /events#http://127.0.0.1:4002
    image: gcr.io/google_containers/kube-apiserver:v1.9.3
    insecurePort: 8080
    kubeletPreferredAddressTypes:
    - InternalIP
    - Hostname
    - ExternalIP
    logLevel: 2
    requestheaderAllowedNames:
    - aggregator
    requestheaderExtraHeaderPrefixes:
    - X-Remote-Extra-
    requestheaderGroupHeaders:
    - X-Remote-Group
    requestheaderUsernameHeaders:
    - X-Remote-User
    securePort: 443
    serviceClusterIPRange: 100.64.0.0/13
    storageBackend: etcd2
  kubeControllerManager:
    allocateNodeCIDRs: true
    attachDetachReconcileSyncPeriod: 1m0s
    cloudProvider: aws
    clusterCIDR: 100.96.0.0/11
    clusterName: ${cluster_name}
    configureCloudRoutes: false
    image: gcr.io/google_containers/kube-controller-manager:v1.9.3
    leaderElection:
      leaderElect: true
    logLevel: 2
    useServiceAccountCredentials: true
  kubeDNS:
    cacheMaxConcurrent: 150
    cacheMaxSize: 1000
    domain: cluster.local
    replicas: 2
    serverIP: 100.64.0.10
  kubeProxy:
    clusterCIDR: 100.96.0.0/11
    cpuRequest: 100m
    hostnameOverride: '@aws'
    image: gcr.io/google_containers/kube-proxy:v1.9.3
    logLevel: 2
  kubeScheduler:
    image: gcr.io/google_containers/kube-scheduler:v1.9.3
    leaderElection:
      leaderElect: true
    logLevel: 2
  kubelet:
    allowPrivileged: true
    cgroupRoot: /
    cloudProvider: aws
    clusterDNS: 100.64.0.10
    clusterDomain: cluster.local
    enableDebuggingHandlers: true
    evictionHard: memory.available<100Mi,nodefs.available<10%,nodefs.inodesFree<5%,imagefs.available<10%,imagefs.inodesFree<5%
    featureGates:
      ExperimentalCriticalPodAnnotation: "true"
    hostnameOverride: '@aws'
    kubeconfigPath: /var/lib/kubelet/kubeconfig
    logLevel: 2
    networkPluginName: cni
    nonMasqueradeCIDR: 100.64.0.0/10
    podInfraContainerImage: gcr.io/google_containers/pause-amd64:3.0
    podManifestPath: /etc/kubernetes/manifests
  kubernetesApiAccess:
  - 10.0.0.0/16
  kubernetesVersion: 1.9.3
  masterInternalName: api.internal.${cluster_name}
  masterKubelet:
    allowPrivileged: true
    cgroupRoot: /
    cloudProvider: aws
    clusterDNS: 100.64.0.10
    clusterDomain: cluster.local
    enableDebuggingHandlers: true
    evictionHard: memory.available<100Mi,nodefs.available<10%,nodefs.inodesFree<5%,imagefs.available<10%,imagefs.inodesFree<5%
    featureGates:
      ExperimentalCriticalPodAnnotation: "true"
    hostnameOverride: '@aws'
    kubeconfigPath: /var/lib/kubelet/kubeconfig
    logLevel: 2
    networkPluginName: cni
    nonMasqueradeCIDR: 100.64.0.0/10
    podInfraContainerImage: gcr.io/google_containers/pause-amd64:3.0
    podManifestPath: /etc/kubernetes/manifests
    registerSchedulable: false
  masterPublicName: api.${cluster_name}
  networkCIDR: ${vpc_cidr}
  networkID: ${vpc_id}
  networking:
    flannel:
      backend: vxlan
  nonMasqueradeCIDR: 100.64.0.0/10
  secretStore: s3://${config_bucket}/${cluster_name}/secrets
  serviceClusterIPRange: 100.64.0.0/13
  sshAccess:
  - 10.0.0.0/16
  subnets:
  - cidr: ${private_subnet_a_cidr}
    id: ${private_subnet_a_id}
    name: us-east-1a
    type: Private
    zone: us-east-1a
  - cidr: ${private_subnet_b_cidr}
    id: ${private_subnet_b_id}
    name: us-east-1b
    type: Private
    zone: us-east-1b
  - cidr: ${private_subnet_c_cidr}
    id: ${private_subnet_c_id}
    name: us-east-1c
    type: Private
    zone: us-east-1c
  - cidr: ${public_subnet_a_cidr}
    id: ${public_subnet_a_id}
    name: utility-us-east-1a
    type: Utility
    zone: us-east-1a
  - cidr: ${public_subnet_b_cidr}
    id: ${public_subnet_b_id}
    name: utility-us-east-1b
    type: Utility
    zone: us-east-1b
  - cidr: ${public_subnet_c_cidr}
    id: ${public_subnet_c_id}
    name: utility-us-east-1c
    type: Utility
    zone: us-east-1c
  topology:
    dns:
      type: Private
    masters: private
    nodes: private

