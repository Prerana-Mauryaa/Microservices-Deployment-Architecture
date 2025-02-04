#!/bin/bash

# Array of namespace names
namespaces=("emailservice" "checkoutservice" "recommendationservice" "frontend" "paymentservice" "productcatalogservice" "cartservice" "loadgenerator" "currencyservice" "shippingservice" "adservice" "business-service")

# Loop through the array and create each namespace
for namespace in "${namespaces[@]}"
do
  echo "Creating namespace: $namespace"
  kubectl create namespace $namespace
done

echo "All namespaces created successfully!"
