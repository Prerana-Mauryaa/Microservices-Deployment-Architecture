
# Microservices-Deployment-Architecture

This project involved designing, deploying, and managing a highly scalable microservices-based application architecture on Amazon Elastic Kubernetes Service (EKS). The architecture consists of a total of 11 microservices, including one custom-built Python Flask microservice connected via gRPC to an existing microservice from a Google-provided repository. The project focused on implementing secure communication, deployment automation, and observability features to create a production-ready system.
## Implementation 
#### Microservice  Analysis 
* I analyzed the communication patterns between the microservices to understand their interaction and dependencies.
* To gain a deeper understanding of microservice communication, I developed a custom **Python Flask** microservice and integrated it with one of the existing microservices using **gRPC**, enabling lightweight and efficient communication.
#### Deployment Strategy
* I created and managed Helm charts for each microservice to simplify deployment, scaling, and management on Kubernetes.
* For better resource isolation and organization, I deployed each microservice in a separate Kubernetes namespace.
#### Traffic Management
* I configured an Ingress Gateway to efficiently handle external traffic between the users and the application.
* For internal (East-West) traffic between microservices, I set up Istio service mesh for effective and secure communication, utilizing sidecar patterns and proxies to manage traffic and enforce security policies.
#### Security Implementation
* To secure communication between microservices, I enabled mutual TLS (mTLS) within the Istio service mesh. This ensured encrypted data transmission, enhancing security across the system.

#### Deployment Automation
* I set up a Jenkins server to automate the build, test, and deployment processes.
* For better organization and manageability, I created separate Jenkins pipelines for each microservice and grouped them into different views.
* The pipelines automated microservice builds, deployments, and updates, streamlining the entire workflow.
#### Upgrade Strategy
* To reduce risks during upgrades and test new versions with a subset of users, I implemented canary deployment for two critical microservices. This approach allowed incremental rollouts while maintaining system stability.
#### Observability Setup
* I integrated Prometheus for metrics collection and Grafana for visualization, enabling detailed monitoring of nodes, the EKS cluster, and the Istio service mesh.
* This observability setup provided valuable insights into system health, resource usage, and the performance of microservices, ensuring proactive issue resolution and system optimization.

