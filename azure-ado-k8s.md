-------

    kubectl config view --minify -o jsonpath={.clusters[0].cluster.server}
    kubectl create serviceaccount ado-serviceaccount -n kube-system
    kubectl get serviceaccount ado-serviceaccount -n kube-system -o=jsonpath={.secrets[*].name}
    kubectl get secret ado-serviceaccount -n kube-system -o json

-------
