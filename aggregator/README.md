### 1. Enalbe aggregator in OpenShift
#### Generate the key for aggregator
```
oadm ca create-signer-cert \
  --cert=aggregator-config/front-proxy-ca.crt \
  --key=aggregator-config/front-proxy-ca.key \
  --serial=aggregator-config/front-proxy-ca.serial.txt

oadm create-api-client-config \
  --certificate-authority=aggregator-config/front-proxy-ca.crt \
  --signer-cert=aggregator-config/front-proxy-ca.crt \
  --signer-key=aggregator-config/front-proxy-ca.key \
  --signer-serial=aggregator-config/front-proxy-ca.serial.txt \
  --user aggregator-front-proxy \
  --client-dir=aggregator-config
```

#### Copy the keys to master configure dir
```
cp aggregator-config/{front-proxy-ca.crt,aggregator-front-proxy.crt,aggregator-front-proxy.key} /etc/origin/master/
```

#### Add below below aggregator configure to `/etc/origin/master/master-config.yaml`
```
aggregatorConfig:
  proxyClientInfo:
    certFile: aggregator-front-proxy.crt
    keyFile: aggregator-front-proxy.key
authConfig:
  requestHeader:
    clientCA: front-proxy-ca.crt
    clientCommonNames:
    - aggregator-front-proxy
    usernameHeaders:
    - X-Remote-User
    groupHeaders:
    - X-Remote-Group
    extraHeaderPrefixes:
    - X-Remote-Extra-
```

### 2. Extend sample-apiserver api by aggregator

#### Build sample-apiserver image or you can use `docker.io/deshuai/kube-sample-apiserver:latest`
```
git clone https://github.com/kubernetes/kubernetes
pushd kubernetes
nice make WHAT=vendor/k8s.io/sample-apiserver/ && vendor/k8s.io/sample-apiserver/hack/build-image.sh
popd
```

#### Deploy sample-apiserver to openshift
```
oc new-project wardle
oadm policy add-scc-to-user privileged -z apiserver"
oc create -f sample-apiserver/
```

#### Verify new api is registered and works well
```
oc create -f flunder.yaml
# oc get flunder my-first-flunder
NAME               KIND
my-first-flunder   Flunder.v1alpha1.wardle.k8s.io
# oc get flunder my-first-flunder -n dma -o json
{
    "apiVersion": "wardle.k8s.io/v1alpha1",
    "kind": "Flunder",
    "metadata": {
        "creationTimestamp": "2017-06-28T15:41:23Z",
        "labels": {
            "sample-label": "true"
        },
        "name": "my-first-flunder",
        "resourceVersion": "27",
        "selfLink": "/apis/wardle.k8s.io/v1alpha1/namespaces/dma/flunders/my-first-flunder",
        "uid": "3d765b47-5c18-11e7-8b93-0a580a81003e"
    },
    "spec": {},
    "status": {}
}
```
