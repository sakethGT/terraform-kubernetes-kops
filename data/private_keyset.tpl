apiVersion: kops/v1alpha2
kind: Keyset
metadata:
  creationTimestamp: null
  name: ${name}
spec:
  keys:
  - id: "1"
    privateMaterial: ${key}
    publicMaterial: ${cert}
  type: Keypair
