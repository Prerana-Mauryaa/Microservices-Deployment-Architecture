#setting up istio service mesh  and enabling sidecar injection for all namespaces
#!/bin/bash

# List of namespaces
namespaces=("emailservice" "checkoutservice" "recommendationservice" "frontend" "paymentservice" "productcatalogservice" "cartservice" "loadgenerator" "currencyservice" "shippingservice" "adservice" "business-service")

# Install Istio using istioctl
curl -L https://istio.io/downloadIstio | sh -

# Move istioctl to the system path
sudo mv istio-*/bin/istioctl /usr/local/bin/

# Install Istio into the Kubernetes cluster
istioctl install --set profile=default -y

# Enable sidecar injection for the specified namespaces
for namespace in "${namespaces[@]}"
do
  echo "Enabling sidecar injection for namespace: $namespace"
  kubectl label namespace $namespace istio-injection=enabled --overwrite
done

echo "Istio has been installed and sidecar injection is enabled for the specified namespaces."
