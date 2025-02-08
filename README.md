
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
* To secure communication between microservices, I enabled **mutual TLS** (mTLS) within the Istio service mesh. This ensured encrypted data transmission, enhancing security across the system.

#### Deployment Automation
* I set up a Jenkins server to automate the build, test, and deployment processes.
* For better organization and manageability, I created separate Jenkins pipelines for each microservice and grouped them into different views.
* The pipelines automated microservice builds, deployments, and updates, streamlining the entire workflow.
#### Upgrade Strategy
* To reduce risks during upgrades and test new versions with a subset of users, I implemented canary deployment for two critical microservices. This approach allowed incremental rollouts while maintaining system stability.
#### Observability Setup
* I integrated Prometheus for metrics collection and Grafana for visualization, enabling detailed monitoring of nodes, the EKS cluster, and the Istio service mesh.
* This observability setup provided valuable insights into system health, resource usage, and the performance of microservices, ensuring proactive issue resolution and system optimization.

## Microservice Application Structure 
The application is an Online Boutique, a cloud-native microservices-based demo e-commerce platform by [GoogleCloudPlatform](https://github.com/GoogleCloudPlatform/microservices-demo) . It allows users to browse products, add items to their cart, and make purchases without requiring signups or logins.

The system consists of **11 microservices** written in various programming languages, communicating primarily over gRPC. These services cover key functionalities such as user interactions, product catalog management, order processing, and recommendations.

I have added a new microservice named **Business** in python flask, which allows users to sell their products online. This service integrates seamlessly with the existing microservice.



| **Service Name**            | **Language**        | **Description**                                                                     |
|-------------------------|-----------------|---------------------------------------------------------------------------------|
| BusinessService          | Python (Flask)  | Allows users to sell their products online.     |
| Frontend                 | Go              | Serves the website via an HTTP server, generating session IDs for users.        |
| CartService              | C#              | Manages the shopping cart in Redis.                                             |
| ProductCatalogService    | Go              | Provides product listings and search features.                                  |
| CurrencyService          | Node.js         | Converts currency values using real-time rates.                                 |
| PaymentService           | Node.js         | Simulates payment transactions.                                                 |
| ShippingService          | Go              | Estimates shipping costs and simulates shipping.                                |
| EmailService             | Python          | Sends order confirmation emails.                                                |
| CheckoutService          | Go              | Handles order preparation and orchestrates payments and notifications.          |
| RecommendationService    | Python          | Suggests products based on cart contents.                                       |
| AdService                | Java            | Displays context-based text ads.                                                |
| LoadGenerator            | Python/Locust   | Simulates user shopping behaviors for performance testing.                      |

![Microservice Architecture](https://github.com/Prerana-Mauryaa/Microservices-Deployment-Architecture/blob/master/images/diagrams/Untitled%20design%20(65).png)


<img src="https://github.com/Prerana-Mauryaa/Microservices-Deployment-Architecture/blob/master/images/diagrams/microservice.drawio%20(2).svg" width="200px" />

![Alt text]([path-to-your-image.svg](https://github.com/Prerana-Mauryaa/Microservices-Deployment-Architecture/blob/master/images/diagrams/microservice.drawio%20(2).svg))
