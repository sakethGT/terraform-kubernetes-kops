apiVersion: kops/v1alpha2
kind: Keyset
metadata:
  name: ${name}
spec:
  keys:
  - id: "1"
    publicMaterial: ${cert}
  type: Keypair
