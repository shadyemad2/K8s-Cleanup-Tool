#!/bin/bash


echo "Starting Kubernetes Cleanup at $(date)"

if [[ "$DELETE_JOBS" == "true" ]]; then
  echo "Deleting Completed Jobs..."
  kubectl delete jobs --all-namespaces --field-selector=status.successful=1
fi

if [[ "$DELETE_PODS" == "true" ]]; then
  echo "Deleting Failed or Evicted Pods..."
  kubectl get pods --all-namespaces | grep -E 'Evicted|CrashLoopBackOff|Error' | awk '{print $1, $2}' | while read ns pod; do
    kubectl delete pod $pod -n $ns
  done
fi

if [[ "$DELETE_PVCS" == "true" ]]; then
  echo "Deleting Lost PVCs..."
  kubectl get pvc --all-namespaces | grep "Lost" | awk '{print $1, $2}' | while read ns pvc; do
    kubectl delete pvc $pvc -n $ns
  done
fi

echo "Cleanup Completed"



