-------

    kubectl config view --minify -o jsonpath={.clusters[0].cluster.server}
    kubectl get serviceAccounts ado-serviceAccount -n kube-system -o=jsonpath={.secrets[*].name}
    kubectl get secret ado-serviceAccount -n kube-system -o json

-------
