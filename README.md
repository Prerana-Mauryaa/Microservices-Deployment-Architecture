
# Microservices-Deployment-Architecture

This project involved designing, deploying, and managing a highly scalable microservices-based application architecture on Amazon Elastic Kubernetes Service (EKS). The architecture consists of a total of 11 microservices, including one custom-built Python Flask microservice connected via gRPC to an existing microservice from a Google-provided repository. The project focused on implementing secure communication, deployment automation, and observability features to create a production-ready system.
## Project Architecture

![Project Architecture](https://github.com/Prerana-Mauryaa/Microservices-Deployment-Architecture/blob/master/images/diagrams/Project-overview.png)

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

![Microservice Architecture](https://github.com/Prerana-Mauryaa/Microservices-Deployment-Architecture/blob/master/images/diagrams/Microservice_Arc.png)


## How I Developed the Business Microservice
### Creating the Flask Application
I started by setting up a basic Python Flask app with a form that allows users to submit product details. The app connects to the Email Service and sends an email upon form submission.

### Defining the gRPC Schema
I defined the communication schema between services in the demo.proto file, which included messages and services like:
```
service EmailService {
    rpc SendOrderConfirmation(SendOrderConfirmationRequest) returns (Empty) {}
    rpc SendVerificationEmail (SendVerificationRequest) returns (SendVerificationResponse){}
}

message OrderItem {
    CartItem item = 1;
    Money cost = 2;
}

message OrderResult {
    string   order_id = 1;
    string   shipping_tracking_id = 2;
    Money shipping_cost = 3;
    Address  shipping_address = 4;
    repeated OrderItem items = 5;
}

message SendOrderConfirmationRequest {
    string email = 1;
    OrderResult order = 2;
}
```

* SendVerificationEmail: Handles sending verification emails.
* SendOrderConfirmation: Manages order confirmation emails.
### Generating Protocol Buffers
Using the following command, I generated the required gRPC code for both client and server:

```bash
python -m grpc_tools.protoc -I ./protos --python_out=. --grpc_python_out=. ./protos/demo.proto
```

### Implementing Client and Server Code

* **Client Code**: Handles communication with the Email Service using the gRPC stub.
```
try:
    value = os.getenv('EMAIL_SERVICE') 
    channel = grpc.insecure_channel(value)
    stub = demo_pb2_grpc.EmailServiceStub(channel)

    # Create the SendVerificationRequest message
    verification_request = demo_pb2.SendVerificationRequest(
        email=data['email'],
        product_name=data['product_name'],
        price=float(data['price']) if data['price'] else 0.0
    )

    # Call the SendVerificationEmail RPC
    response = stub.SendVerificationEmail(verification_request)

    # Handle the response
    if response.success:
        return render_template('business.html', success_message=f"{response.message}")
    else:
        return render_template('business.html', error_message=f"{response.message}")

except grpc.RpcError as err:
    return render_template('business.html', error_message=f"Error: Unable to connect to the email service. Details: {err.details()}")
```
* **Server Code**: Manages the logic for sending verification emails and responding with status messages.

```
def SendVerificationEmail(self, request, context):
    """Sends a verification email and returns a success status."""
    try:
        # Simulate the process of sending a real email in production
        logger.info(f"Sending verification email to {request.email} for {request.product_name} of price {request.price}")
        
        # Here, integrate with your actual email sending service (e.g., SMTP, SES, SendGrid, etc.)
        message = f"Verification email sent to {request.email} for {request.product_name} of price {request.price}."

        # Return success response
        return demo_pb2.SendVerificationResponse(success=True, message=message)
    except Exception as e:
        logger.error(f"Error sending email: {e}")
        return demo_pb2.SendVerificationResponse(success=False, message="Failed to send verification email.")
```


### Dockerizing the Application
I created a multi-stage Dockerfile to containerize the application efficiently:

* **Builder Stage**: Installs dependencies for gRPC and Flask.
* **Production Stage**: Uses a lightweight distroless image for security and efficiency.

### Testing and Integration
After successful testing, I ensured the Business Microservice integrated seamlessly with the existing microservices, providing enhanced functionality for selling products online.

# Deploying the Microservice Application

## Setting Up the Deployment Environment
To streamline the entire infrastructure configuration and deployment process, I developed a comprehensive setup script located at ``` setup-scripts\eks-setup.sh```

The setupscript/ek_setup.sh automates the setup process with the following steps:

* **AWS CLI Installation**: Installs and configures AWS CLI for seamless interaction with AWS services.
* **Docker Installation**: Sets up Docker for containerization and image management.
* **Kubernetes Tools Setup**: Installs and configures kubectl and eksctl for managing Kubernetes clusters.


## Creation of Kubernetes cluster
```
eksctl create cluster --name Microservice-Architecture --region us-east-1 --node-type t2.medium --nodes-min 3 --nodes-max 3
```

## Creation of namespace for each microservice
I have created one  shell script located at ```
setup-scripts\creating_namespace.sh ```, that will automate the creation of namespaces for each microservice.

## Installation of Istio
Istio is a powerful service mesh platform for Kubernetes that provides advanced traffic management, security, and observability features for microservices. It helps decouple service communication from application logic, making deployments more scalable, secure, and reliable.

I have created a shell script located at `setup-scripts/istio-setup.sh` that automates the installation and configuration of Istio in your Kubernetes cluster.  

**what it does?**
* Downloads the latest Istio CLI and installs Istio with the default profile on the Kubernetes cluster.  

* Labels the  namespaces  for automatic sidecar injection that we created for each microservices.  

## Creation of Helm Charts 

1. **Helm Charts for Microservices:**  
   I have created Helm charts for each microservice, adhering to the standard Helm chart structure. These charts enable streamlined deployment and resource management for each service.  

2. **Helm Chart for Canary Deployment:**  
   A dedicated Helm chart was developed for canary deployments, allowing both the Business and Frontend microservices to efficiently create and manage their own resources during staged rollouts.

## Setting up Jenkins and Creation of Pipelines  

1. **Jenkins Setup:**  
   I followed the official [Jenkins documentation](https://www.jenkins.io/doc/book/installing/linux/) to set up Jenkins on the server and configure it for my project requirements.  

2. **Accessing the Jenkins Server:**  
   After the installation, I accessed the Jenkins UI via the server's IP address and port to manage pipelines and credentials.

3. **Creating Credentials:**  
   - **GitHub Credentials:** Configured SSH-based access using a private key file for secure repository integration.  
   - **Docker Hub Credentials:** Added credentials for Docker Hub to push Docker images securely.

4. **Pipeline Views:**  
   For better organization and visibility, I created dedicated views in Jenkins for each microservice.  

5. **Pipeline Implementations:**  
   - **Business Microservice:**  
     - **Deployment Pipeline:** Deploys the application on the EKS cluster.  
     - **Traffic Splitting Pipeline:** Manages traffic routing during Canary deployments.  
   
   - **Frontend Microservice:**  
     - **Deployment Pipeline:** Deploys the application on the EKS cluster.  
     - **Traffic Splitting Pipeline:** Manages traffic routing during Canary deployments.  
    - **Other Microservice Pipelines:**  
        - For microservices that do not require Canary upgrades, I created simple deployment pipelines that directly deploy the latest version of the application on the EKS cluster without any traffic splitting.

### Pipeline Overview
### Canary Deployment Pipeline

#### **Parameters**  
- `STABLE_DOCKER_IMAGE_TAG`: Tag for the stable Docker image (default: `latest`).  
- `canaryEnabled`: Boolean flag to enable or disable Canary deployment (default: `false`).  
- `CANARY_DOCKER_IMAGE_TAG`: Tag for the Canary Docker image (required if `canaryEnabled` is true).  
- `ROLLBACK`: Boolean flag to trigger rollback to the previous Helm release revision (default: `false`).  

#### **Stages**  
*  **`Clean Workspace`:** Clears Jenkins workspace for fresh deployments (skipped during rollback).  
*  **`Clone Repo`:** Fetches the latest code from the GitHub repository (skipped during rollback).  
* **`Build and Push Docker Image`:** Builds and pushes stable Docker images; optionally builds Canary images if enabled.  
* **`Install Canary Helm Chart`:** Installs Canary Helm chart with custom configurations if enabled.  
* **`Install Business-Service Helm Chart`:** Deploys or upgrades the stable service and canary configurations if applicable.  
* **`Rollback Release`:** Rolls back to the previous Helm revision when rollback is triggered.  

![Microservice Architecture](https://github.com/Prerana-Mauryaa/Microservices-Deployment-Architecture/blob/master/images/diagrams/canary_deployment.png)


This pipeline ensures flexibility for controlled Canary deployments and rollback handling.

### Traffic Splitting Pipeline 

#### **Parameters**  
- `STABLE_TRAFFIC_WEIGHT`: Percentage for stable version traffic (default: `20%`).  
- `CANARY_TRAFFIC_WEIGHT`: Percentage for canary version traffic (default: `80%`).  

#### **Stages**  
* **`Clean Workspace`:** Ensures a clean environment by clearing the workspace.  
* **`Clone Repo`:** Fetches the required configurations from the repository.  
* **`Traffic Splitting`:** Deploys and configures traffic weights for stable and canary releases.  

![Microservice Architecture](https://github.com/Prerana-Mauryaa/Microservices-Deployment-Architecture/blob/master/images/diagrams/traffic_splitting.png)

### Normal Deployment Pipeline

#### **Parameters**  
- `DOCKER_IMAGE_TAG`: Tag for the Docker image to be built and deployed (default: `latest`).  

#### **Stages**  
* **`Clean Workspace`:** Clears Jenkins workspace for a fresh build.  
* **`Clone Repo`:** Clones the latest code from the GitHub repository.  
*  **`Build and Push Docker Image`:** Builds and pushes the Docker image to Docker Hub.  
* **`Install Helm Chart`:** Deploys or upgrades Helm charts with the provided image tag.  

![Microservice Architecture](https://github.com/Prerana-Mauryaa/Microservices-Deployment-Architecture/blob/master/images/diagrams/normal_deployment.png)

## Deploy the application
Deploy the application on eks cluster by building the jenkins pipeline jobs.

### Frontend
![Microservice Architecture](https://github.com/Prerana-Mauryaa/Microservices-Deployment-Architecture/blob/master/images/screenshots/frontend.png)

### Business
![Microservice Architecture](https://github.com/Prerana-Mauryaa/Microservices-Deployment-Architecture/blob/master/images/screenshots/business.png)

# Setting Up Monitoring with Prometheus and Grafana
To effectively monitor and visualize application performance and infrastructure health, I have configured Prometheus and Grafana using the Prometheus Operator deployed via Helm. Below are the steps I followed for setting up the monitoring stack and creating insightful dashboards:

## Installing Prometheus Operator Using Helm
The Prometheus Operator simplifies the deployment and configuration of Prometheus and Grafana in Kubernetes environments. Here's how I installed it:

### Commands to Install the Prometheus Operator:
* Add the Helm repository for Prometheus Operator
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts  
```

* Update the repository to get the latest charts
```
helm repo update  
```

* Install Prometheus Operator
```
helm install prometheus-operator prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace
```
This installation deploys Prometheus, Grafana, Alertmanager, and node exporters for collecting system metrics.
**Acesss Prometheus**
```
kubectl expose service prometheus-operated \
  --type=NodePort \
  --name=prometheus-ui-nodeport \
  -n monitoring \
  --port=9090 \
  --target-port=9090

```
Acess prometheus UI at http://<Node_IP>:9090

* Setting Up Grafana for Visualization
Grafana is automatically installed with the Prometheus Operator. Here's how I accessed and configured it:

**Access Grafana**
```
kubectl expose service prometheus-operator-grafana \
  --type=NodePort \
  --name=grafana-ui-nodeport \
  -n monitoring \
  --port=80 \
  --target-port=80

```
Acess Grafana UI at  http://<Node_IP>:80


* Configure Prometheus as a Data Source:
Navigate to Configuration > Data Sources > Add Data Source, select Prometheus, and set the URL to http://<Node_IP>:9090

### Dashboards for Effective Monitoring
I have created and configured three dashboards in Grafana for comprehensive monitoring:

* **Nodes Monitoring Dashboard**:

Displays CPU, memory, and disk utilization for individual nodes.
Helps identify resource bottlenecks at the node level.

* **Kubernetes Cluster Monitoring Dashboard**:

Tracks pod status, deployments, and resource usage across the cluster.
Useful for understanding the overall health of the Kubernetes environment.

![Microservice Architecture](https://github.com/Prerana-Mauryaa/Microservices-Deployment-Architecture/blob/master/images/screenshots/k8s.png)

* **Istio Service Mesh Monitoring Dashboard**:

Visualizes traffic flow, service latencies, and error rates within the Istio mesh.
Provides insights into service-to-service communication and mesh performance.

![Microservice Architecture](https://github.com/Prerana-Mauryaa/Microservices-Deployment-Architecture/blob/master/images/screenshots/istio-servicemesh.png)

