#!/bin/sh


argocd login $ARGOCD_SERVER --username=$ARGOCD_USERNAME --password=$ARGOCD_PASSWORD --insecure

# Read the clusters file and iterate over each line
while IFS=':' read -r CLUSTER_NAME CLUSTER_SERVER; do
  # Trim whitespace from the cluster name and server
  CLUSTER_NAME=$(echo "$CLUSTER_NAME" | tr -d '[:space:]')
  CLUSTER_SERVER=$(echo "$CLUSTER_SERVER" | tr -d '[:space:]')
  oc login --token=$CLUSTER_TOKEN --server=$CLUSTER_SERVER --insecure-skip-tls-verify=true

  export CLUSTER_CONTEXT=$(kubectl config view --minify --output 'jsonpath={.current-context}' --kubeconfig=/.kube/config)

  # Add the cluster using argocd cluster add command
  argocd cluster add "$CLUSTER_CONTEXT" --name "$CLUSTER_NAME" --yes
done < clusters