#!/bin/bash
namespaces=("emailservice" "checkoutservice" "recommendationservice" "frontend" "paymentservice" "productcatalogservice" "cartservice" "loadgenerator" "currencyservice" "shippingservice" "adservice" "business-service")

for namespace in "${namespaces[@]}"
do
  echo "Creating namespace: $namespace"
  kubectl create namespace $namespace
done

echo "All namespaces created successfully!"
