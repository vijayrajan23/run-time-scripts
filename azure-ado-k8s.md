-------

    kubectl config view --minify -o jsonpath={.clusters[0].cluster.server}
    kubectl create serviceaccount ado-serviceaccount -n kube-system
    kubectl get serviceaccount ado-serviceaccount -n kube-system -o=jsonpath={.secrets[*].name}
    kubectl get secret ado-serviceaccount-token-xxxx -n kube-system -o json

-------



azure-pipelines.yml
-------

```yml
    trigger: none

    resources:
    - repo: self

    pool: 
      name: miga
      demands:  
      - Agent.ComputerName -equals access-server

    steps:
      - task: KubernetesManifest@0
        displayName: kubernetes-deploy
        inputs:
          kubernetesServiceConnection: dev-aks-ado-service-account
          namespace: nifi-dev
          manifests: deployment/file.yml
```
-------
