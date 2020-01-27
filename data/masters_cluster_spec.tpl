cloudConfig: null
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
encryptionConfig: null
etcdClusters:
  events:
    image: gcr.io/google_containers/etcd:2.2.1
    version: 2.2.1
  main:
    image: gcr.io/google_containers/etcd:2.2.1
    version: 2.2.1
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
  clusterName: $${cluster_name}
  configureCloudRoutes: false
  image: gcr.io/google_containers/kube-controller-manager:v1.9.3
  leaderElection:
    leaderElect: true
  logLevel: 2
  useServiceAccountCredentials: true
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
