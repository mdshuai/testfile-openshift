### Enable podtolerationrestriction in openshift
```
# cat /etc/origin/master/master-config.yaml
---
admissionConfig:
  pluginConfig:
    PodTolerationRestriction:
      configuration:
        apiVersion: podtolerationrestriction.admission.k8s.io/v1alpha1
        kind: Configuration
        default:
         - key: key1
           operator: Equal
           value: value1
         - key: key2
           operator: Equal
           value: value2
        whitelist:
         - key: key1
           operator: Equal
           value: value1
         - key: key2
---
```

### Enable podtolerationrestriction in k8s
```
apiVersion: apiserver.k8s.io/v1alpha1
kind: AdmissionConfiguration
plugins:
- name: "PodTolerationRestriction"
  configuration:
    apiVersion: podtolerationrestriction.admission.k8s.io/v1alpha1
    kind: Configuration
    default:
     - Key: key1
       Value: value1
     - Key: key2
       Value: value2
    whitelist:
    - Key: key1
      Value: value1
    - Key: key2
      Value: value2
```

### Enable admission in k8s (TODO: need update)
```
---method(1)
apiVersion: apiserver.k8s.io/v1alpha1
kind: AdmissionConfiguration
plugins:
- name: "ImagePolicyWebhook"
  path: "image-policy-webhook.json"

---method(2)
apiVersion: apiserver.k8s.io/v1alpha1
kind: AdmissionConfiguration
plugins:
- name: "ResourceQuota"
  configuration:
    apiVersion: resourcequota.admission.k8s.io/v1alpha1
    kind: Configuration
    limitedResources:
    - resource: pods
      matchContains:
      - pods
      - requests.cpu
    - resource: persistentvolumeclaims
      matchContains:
      - .storageclass.storage.k8s.io/requests.storage

```
