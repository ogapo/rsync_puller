rsync Puller
------------

This is a little script that runs in two modes:
- "once" mode which just does an rsync from `rsync://$RSYNC_HOST$RSYNC_PATH`
- standard mode loops periodically rsync-ing every 30 sec.

The intention of this script is to be able to keep a content directory in your container in sync with global content. The global content can thus be packaged into an rsync server bundle and hosted as a service that the other containers periodically pull from. This lets apps that are file-notify-aware manage changing content directly.

## Default Environment Variables:
- *$RSYNC_HOST* = `localhost`
- *$RSYNC_PATH* = `/app`

## Example K8S Usage:

Ideal usage is as both a side-car and init container. Here's an example PodSpec:

```yaml
spec:
  initContainers:
  - name: rg-client-puller-init
    image: 'gcr.io/oz-engine/rsync_puller'
    args: [ 'once' ]
    resources:
      requests:
        cpu: 1m
    volumeMounts:
    - name: game-data
      mountPath: /data
  containers:
  - name: rg-client-puller
    image: 'gcr.io/oz-engine/rsync_puller'
    resources:
      requests:
        cpu: 1m
    volumeMounts:
    - name: game-data
      mountPath: /data
``` 
