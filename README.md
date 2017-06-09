# Description

Supportconfig plugin for CaaSP project.



# Information which have to be collected by supportconfig from CaaSP installation

## Docker service
It will be collected by *docker_info()* in **supportconfig**

### Output from commands
```
docker version
systemctl status docker.service
docker info
docker images
docker ps --all
ls -al --time-style=long-iso /var/lib/docker/containers
ls -alR --time-style=long-iso /sys/fs/cgroup/*/system.slice/docker*
journalctl -u docker
```

### Configuration files
* /etc/sysconfig/docker

### Logs from containers
```
docker top 
docker logs
docker inspect
```

## Etcd service
### Output from commands
```
etcdctl --version
etcdctl member list
etcdctl cluster-health
etcdctl get /flannel/network/config
etcdctl ls /flannel/network/subnets
systemctl status etcd.service
journalctl -u etcd
```

### Configuration files
* /etc/sysconfig/etcd

## Flanneld service
### Output from commands
```
flanneld -version
systemctl status flanneld.service
journalctl -u flanneld
```

### Configuration files
* /etc/sysconfig/flanneld

## Kubernetes service
### Output from commands
```
kubectl config view -a
kubectl version
kubectl api-versions
kubectl cluster-info dump --all-namespaces --output-directory=/var/log/kubernetes
kubectl get nodes
kubectl top nodes
for srv in kube-apiserver kube-scheduler  kube-controller-manager kubelet; do
    systemctl status $srv
done
journalctl -u
```

### Configuration files
* /etc/kubernetes/*

### Logs from containers
```
kubectl top 
kubectl logs
kubectl describe
```

## Salt
### Output from commands
```
salt-minion --versions-report
systemctl status salt-minion
journalctl -u salt-minion
```

```
for container in k8s_salt-api k8s_salt-minion-ca k8s_salt-master; do
    CONTAINER_ID=$(docker ps -a | grep $container | cut -d" " -f1)
    docker top $CONTAINER_ID
    docker logs $CONTAINER_ID
    docker inspect $CONTAINER_ID
done
```
This will be collected by *docker_info()* in **supportconfig**

### Configuration files
* /etc/salt

### Logs from containers
* /var/log/salt

## Velum
```
for container in `docker ps -a | grep k8s_velum | cut -d" " -f1`; do
    CONTAINER_ID=$(docker ps -a | grep $container | cut -d" " -f1)
    docker top $CONTAINER_ID
    docker logs $CONTAINER_ID
    docker inspect $CONTAINER_ID
done
```
This will be collected by *docker_info()* in **supportconfig**

## Mariadb
```
CONTAINER_ID=$(docker ps -a | grep k8s_velum-mariadb | cut -d" " -f1)
docker top $CONTAINER_ID
docker logs $CONTAINER_ID
docker inspect $CONTAINER_ID
```
This will be collected by *docker_info()* in **supportconfig**
