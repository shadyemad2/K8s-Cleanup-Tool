# 🧹 Kubernetes Cleanup Tool

A lightweight automated tool to clean up unnecessary Kubernetes resources such as:
- ✅ Completed Jobs
- ❌ Failed or Evicted Pods
- 🗑️ Lost Persistent Volume Claims (PVCs)

Runs periodically via CronJob and is fully configurable using a ConfigMap.

## 🚀 Features
- Deletes **Completed Jobs** across all namespaces  
- Deletes **Failed / Evicted Pods** (CrashLoopBackOff, Error, Evicted)  
- Deletes **Lost PVCs** that are no longer bound  
- Simple to configure via ConfigMap  
- Secured via Kubernetes RBAC  

## 🧩 Tech Stack
- Docker (image with kubectl)
- Kubernetes (CronJob, ConfigMap, RBAC)
- Bash

## 📁 Project Structure
```
k8s-cleanup-tool/
├── cleanup.sh                 # Main cleanup script
├── Dockerfile                 # Builds image with kubectl
├── README.md                  # Documentation file
├── k8s/
│   ├── configmap.yaml         # Environment variables (DELETE_JOBS, etc.)
│   └── cronjob.yaml           # Scheduled CronJob definition
└── rbac/
    ├── serviceaccount.yaml    # ServiceAccount for cleanup
    ├── clusterrole.yaml       # Permissions for listing/deleting resources
    └── rolebinding.yaml       # Binds role to service account
```

## ⚙️ Configuration

In `k8s/configmap.yaml`:

```yaml
data:
  DELETE_JOBS: "true"
  DELETE_PODS: "true"
  DELETE_PVCS: "false"
```

## 🛠️ Build & Push Docker Image

```bash
docker build -t yourname/k8s-cleanup:latest .
docker push yourname/k8s-cleanup:latest
```

## 🚀 Deploy to Kubernetes

```bash
kubectl apply -f rbac/
kubectl apply -f k8s/
```

Run manually:

```bash
kubectl create job --from=cronjob/k8s-cleanup k8s-cleanup-manual
kubectl logs job/k8s-cleanup-manual
```

## 🛡️ RBAC Notes

Make sure the `cleanup-sa` service account is bound to a `ClusterRole` that allows:

- `get`, `list`, `delete`, `watch` on:
  - `pods`
  - `persistentvolumeclaims`
  - `jobs.batch`

## ✅ Sample Output

```
[🧹] Kubernetes Cleanup Started
[🗑️] Deleting Completed Jobs...
[🗑️] Deleting Failed or Evicted Pods...
[✅] Kubernetes Cleanup Completed
```

> View output using:
```bash
kubectl logs job/k8s-cleanup-manual
```

## 👨‍💻 Author

Shady Emad

