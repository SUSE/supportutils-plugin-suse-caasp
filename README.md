# Description

Supportconfig plugin for CaaSP project.

## Information which have to be collected by supportconfig from CaaSP installation

### Cri-o service

Output from commands
```
crictl version
systemctl status --full crio.service
crictl info
crictl images
crictl ps --all
journalctl -u crio
```

Configuration files
* /etc/crictl.yaml
* /etc/sysconfig/crio

Logs from containers
```
crictl top
crictl logs
crictl inspect
```

### Kubernetes service

Output from commands
```
kubectl config view
kubectl version
kubectl api-versions
kubectl cluster-info dump --all-namespaces --output-directory=/var/log/kubernetes
kubectl get nodes
kubectl get nodes
for srv in kube-proxy kubelet; do
    systemctl status --full $srv
done
journalctl -u kubelet
```

Configuration files
* /etc/kubernetes/*

Logs from containers
```
kubectl top 
kubectl logs
kubectl describe
```
