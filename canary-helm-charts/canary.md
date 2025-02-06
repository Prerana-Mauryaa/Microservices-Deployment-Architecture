## Canary Helm Chart Template for Business and Frontend Microservice
I am using a shared Helm chart for both microservices, which will create a virtual service and destination rule for each microservice in its respective namespace.

### Directory Structure 
```
./canary/
├── templates/
│   ├── VirtualService.yaml
│   └── destinationRule.yaml
├── values.yaml
└── Chart.yaml
```

### Dynamic Fields in values.yaml

The following fields in the values.yaml file will change dynamically to accommodate the differences between the two microservices:

* defaults.host: Specifies the host for each microservice.
```
defaults:
    host: <host> 
```
* namespace: Defines the namespace for deploying each microservice.
 ```
defaults:
    namespace: <namespace> 
```

### Why Use a Common Helm Chart for Two Microservices?

* **Consistency**: Ensures uniform deployment and configuration.
* **Reusability**: Reduces template duplication and maintenance effort.
* **Efficiency**: Simplifies CI/CD pipeline management.
* **Namespace Isolation**: Enables isolated deployments through namespace parameterization.

