#!/bin/sh
#general update
APP_NAME=car-dashboard

CLUSTER_TYPE=free
#CLUSTER_TYPE=standard
#CLUSTER_NAME=$APP_NAME
CLUSTER_NAME=cloudnativedev
CLUSTER_LOCATION=hou02
CLUSTER_WORKERS=2
CLUSTER_MC_TYPE=u1c.2x4
CLUSTER_HARDWARE=shared

VLAN_PRIV=priv01
VLAN_PUB=pub01

#KUBE_NAMESPACE=$APP_NAME
KUBE_NAMESPACE=default
KUBECONFIG_DIR=~/.bluemix/plugins/container-service/clusters/$CLUSTER_NAME
KUBECONFIG_FILE=$KUBECONFIG_DIR/kube-config-$CLUSTER_LOCATION-$CLUSTER_NAME.yml

REGISTRY=registry.ng.bluemix.net
REGISTRY_NAMESPACE=rhowe
IMAGE_NAME=$APP_NAME

echo bx cr login
bx cr login
echo bx cs init
bx cs init
bx cs cluster-config $CLUSTER_NAME

if [ -f "$KUBECONFIG_FILE" ]; then
  export KUBECONFIG=$KUBECONFIG_FILE
else
  # HACK: if we get here, then most likely cause is that $CLUSTER_LOCATION is not valid
  # This will happen if the cluster is public, in which case it will be in mel01
  KUBECONFIG_FILE=$KUBECONFIG_DIR/kube-config-mel01-$CLUSTER_NAME.yml
  if [ -f "$KUBECONFIG_FILE" ]; then
    export KUBECONFIG=$KUBECONFIG_FILE
  else
    echo KUBECONFIG file is not found
  fi
fi
echo KUBECONFIG=$KUBECONFIG
