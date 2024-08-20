# Kubernetes

- Kubernetes is an Application Orchestrator that enables the Deployment, Scaling, and Management of containerized Applications.
- Containerized Applications (i.e. Containers) are lightweight, portable, and encapsulate an Application along with its Dependencies.
- Kubernetes automatically scales containerized Applications up or down as needed, providing Zero-Downtime Deployments and optimal Resource Utilization.

## Kubernetes Cluster

- A Kubernetes Cluster is a Collection of **Worker Nodes** that work together as a single Unit to run containerized Applications.
- It is fundamental to the Kubernetes Architecture, ensuring high Availability, Fault Tolerance, and Load Balancing by distributing Workloads across multiple Worker Nodes. This Setup ensures that Applications remain accessible and responsive, even if individual Worker Nodes or Components fail.
- The Key Components of the Kubernetes Cluster are:
  - **Worker Nodes**: These are the Machines within the Kubernetes Cluster that host and run the **Pods**, which encapsulate Containers. Worker Nodes provide Compute Resources, Storage, and Networking Capabilities to run Containers.
  - **Control Plane**: The centralized Management Component responsible for Controlling and Managing the Kubernetes Cluster.
  - **Etcd**: A distributed, consistent Key-Value Store that serves as the Database for the Kubernetes Cluster. It stores critical Cluster Information such as Configuration, Health, and Metadata, ensuring Reliability and Resilience.
- High Availability and Fault Tolerance Considerations:
  - **Replication of Control Plane Components**: Key components like the API Server, Scheduler, and Controller Manager are often replicated across multiple Nodes for Redundancy.
  - **Distribute Pods across multiple Nodes**: Kubernetes schedules and distributes Pods across multiple Nodes to avoid a single Point of Failure.
  - **Scale Nodes and Pods**: Kubernetes allows Nodes to be dynamically added or removed to meet Resource Demands. Pods can also be scaled horizontally by replicating them across multiple Nodes.
  - **Load Balancing Traffic**: Kubernetes includes built-in Load Balancing Mechanisms to distribute Traffic across Nodes. Load Balancers can be configured to distribute incoming Requests across multiple Application Instances, ensuring optimal Resource Utilization and improved Application Performance.

## Kubernetes Architecture

<p align="center">
  <img src="https://user-images.githubusercontent.com/29623199/133905860-332dcbbf-40a8-4f32-a2b9-0aaa17d34aae.JPG" alt="Kubernetes Architecture" width="50%"/>
</P>

<hr>

### Master Node

- The **Master Node** manages the Kubernetes Cluster and makes Key Decisions for the Cluster.
- Communication between the Master Node and Worker Nodes is handled by the **Kubelet**.
- The Master Node contains the **Control Plane**.

#### Control Plane

- The **Control Plane** composed of multiple Components that communicate via the API Server.
- The **Cloud Controller Manager** interacts with the underlying Cloud Provider (e.g., AWS).
- The Control Plane manages various Controllers that handle Tasks such as Node and Pod Lifecycle, Replication, and Monitoring.
- The Control Plane's API Server serves as the central Management Point, exposing the Kubernetes API. All Interactions with the Cluster go through the API Server.
- The Control Plane is responsible for Scheduling Pods to Nodes based on Resource Requirements, Constraints, and Policies.
- The Control Plane stores via Etcd the Cluster Configuration and Health Information, ensuring Consistency and high Availability.

<p align="center">
  <img src="https://user-images.githubusercontent.com/29623199/133905831-033273c3-b05f-4796-88dc-ce835dba2e5a.JPG" alt="Control Plane" width="75%"/>
</P>

- The Control Plane contains the following Components:

#### API Server

- The **API Server** is the Frontend to the **Control Plane**.
- All Communications (external and internal) is routed through the API Server that is exposed as restful API on Port 443.

#### Cluster Store

- The **Cluster Store** stores the Configuration and State of the entire Cluster.
- It uses a distributed Key-Value Data Store (i.e. etcd), which is the single Source of Truth.

#### Scheduler

- The **Scheduler** monitors for new Workloads / Pods and assigns them to a Worker Node based on several Factors, including:
  - Pod Health
  - Resource Availability
  - Port Availability
  - Pod Affinity or Anti-Affinity Rules

#### Controller Manager

- The **Controller Manager** is a Daemon that manages the Control Loop.
- It monitors the current State of the API Server for Changes that do not match the desired State and takes Action to achieve the desired State.
- It is responsible for managing different Controllers:
  - **Node Controller**: Responds to Changes in Node Status and ensures the desired State is achieved.
  - **ReplicaSet**: Ensures that the correct Number of Pods are always running.
  - **Endpoint**: Assigns Pods to Services.
  - **Namespace**, **Services Accounts**, and more.

##### Cloud Controller Manager

- The **Cloud Controller Manager** interacts with the underlying Cloud Provider (e.g., AWS).

<hr>

### Worker Node

- Worker Nodes provide the Computing Power to run containerized Applications in a Kubernetes Cluster. Each Worker Node is a physical or virtual Machine forming the underlying Infrastructure of the Cluster.
- Key Components of a Worker Node include the Kubelet (the primary Agent responsible for Communication between the Control Plane and the Worker Node), the **Container Runtime** (Software responsible for running Containers, such as Docker, Containerd, or CRI-O), and the **Kube Proxy**
- Worker Nodes require sufficient CPU, Memory, and Storage Resources, Network Connectivity, and a compatible Operating System (Linux, Windows, etc.) to host Containers, manage Volumes, enable Communication between Containers on different Worker Nodes, and interact with external Networks and Services.
- Worker Nodes manage the Lifecycle of Pods (i.e. Groups of Containers) scheduled on them by the Cluster Scheduler based on Resource Requirements and Constraints. This includes allocating the necessary Resources, ensuring that the Containers are running as expected, and Monitoring their Health and Status via the Kubelet.
- In Case of Worker Node Failure or Unavailability, the Control Plane reschedules the affected Pods to other available Worker Nodes to ensure high Availability and Fault Tolerance.

<p align="center">
  <img src="https://user-images.githubusercontent.com/29623199/133918227-22f32945-9192-4750-b4fd-be8ed340c84e.JPG" alt="Worker Node" width="50%"/>
</P>

#### Kubelet

- The Kubelet is the primary Node Agent that runs on each Node.
- It receives Pod Definition from the API Server.
- It interacts with the Container Runtime to run Containers associated with the Pod.
- It reports the State of Node and Pod to the Master Node through the API Server.
- The Kubelet can register the Node with the API Server using various Identifiers, including the Hostname, Flags to override the Hostname, or specific Logic for a Cloud Provider.

<p align="center">
  <img src="https://user-images.githubusercontent.com/29623199/133918337-e177688b-cc7f-441c-9427-75c5f4d9453e.JPG" alt="Kubelet" width="50%"/>
</P>

#### Container Runtime

- The **Container Runtime** is responsible to pulling Images from the Container Registry.
- It runs Containers from these Images and abstracts Container Management for Kubernetes.
- It provides the CRI (Container Runtime Interface) that is an Interface for Third-Party Container Runtime.
- The **containerd** Runtime, an Industry-Standard Runtime alongside Docker, manages the complete Container Lifecycle on its Host System, including Image Transfer, Storage, Execution, and Monitoring, as well as low-level Storage and Network Attachments.

<p align="center">
  <img src="https://user-images.githubusercontent.com/29623199/133918601-fc82f4f2-bb9e-4bd5-be23-ee40c10e623b.JPG" alt="Container Runtime" width="50%"/>
</P>

#### Kube Proxy

- **Kube Proxy** is an Agent that runs on each Node through a DaemonSet.
- It manages local Cluster Networking, ensuring that each Node has its own unique IP Address.
- Kube Proxy is responsible for routing Network Traffic as Load Balancer for Services.
- It maintains Network Rules to allow Communication to Pods from inside and outside the Cluster.
- It implements a Controller that monitors the API Server for new Services and Endpoints.

<hr>

### Pods

- Pods are the smallest deployable Units in Kubernetes, encapsulating one or more Containers that are scheduled and run together on a Worker Node.
- Pods represent a running Process with a unique IP Address and provide a shared Execution Environment, simplifying the Management, Scaling, and Coordination of Containers.
- Containers within a Pod share the same Network and Storage Namespaces, allowing them to communicate via Localhost and standard inter-process Communication Mechanisms such as TCP/IP or Unix Sockets.
- Pods can also mount shared Volumes for persistent Data Access.
- The Control Plane manages the Lifecycle of Pods, based on desired States defined in the Deployment Configurations. Pods can be scaled horizontally by replicating them across multiple Worker Nodes as needed.
- **Init Containers** run before the **Main Container**, **Sidecar Containers** support the Main Container, and a DaemonSets ensure that a Copy fo a Pod runs across the Cluster or on each Worker Node.

<p align="center">
  <img src="https://user-images.githubusercontent.com/29623199/133935228-c55da185-b448-4e88-bb8c-d459802ee8af.JPG" alt="Pod" width="50%"/>
</P>

#### Resource Management

- A Pod can define the minimum Amount of Resources a Container needs (Request).
- A Pod can define the maximum Amount of Resources a Container can have (Limit).

#### Networking

- **Networking** is an Abstraction that defines a logical Set of Pods and a Policy for Accessing them.
- **Services** provide a stable Network Endpoint for connecting to the Pods, even if they are dynamically created or terminated.
- The Networking manages incoming Network Traffic and routes it to Services within the Cluster based on defined Rules.
- It acts as a Reverse Proxy and Load Balancer for external Access to Services.
- **CNI** (Container Networking Interface) is a Specification that defines how Networking is configured for Containers.
- Various CNI Plugins are available to implement Networking solutions in Kubernetes.

#### Volumes

- **Volumes** are an Abstraction that provides a Way to store Data in a Pod.
- Volumes can be associated with one or more Containers within a Pod, allowing Data to persist even when Containers are terminated or rescheduled.

##### EmptyDir Volume

- An **EmptyDir Volume** is a temporary Directory that shares the Lifetime of a Pod.
- It is initially empty and shares Data between Containers in one Pod.

##### HostPath Volume

- A **HostPath Volume** is used when Applications need access to the underlying Host File System.

##### Persistent Volume

- A **Persistent Volume** stores Data beyond the Pod Lifecycle, ensuring Data persistence even if a Pod fails or is moved to a different Node.
- It is a Storage Resource provided by an Administrator.
- **Persistent Volume Claim** is a Request from a User for a Persistent Volume.
- **Storage Class** describes the Parameters for a Class of Storage for which Persistent Volumes can be dynamically provided.

<hr>

### Deployments

- Pods should be only published through a **Deployment**.
- A Deployment is a Kubernetes Resource that manages the Release and Lifecycle of an Application by creating Pods and ReplicaSets
- It provides Zero-Downtime Deployments; for Example, if an Application contains a Bug and crashes, the Deployment will release new Version of the Application.
- A ReplicateSet is created by a Deployment to ensure that the desired Number of Pods are always running.
- ReplicaSets use Control Loops that continuously monitor the State of the Pods to ensure the desired Number of Pods are always present on the Cluster.
- A ReplicaSet is not deleted when a new Version is released, allowing for Rollbacks to a previous Version.

<p align="center">
  <img src="https://user-images.githubusercontent.com/29623199/209465647-475647df-a426-408f-97b8-4cde0469a4e3.png" alt="Deployment" width="50%"/>
</P>

<hr>

### Services

- A **Service** allows Interaction with Pods in a Deployment without the Need for Port-Forwarding or knowing their IP Addresses.
- The IP Address of a Service is stable and does not change, providing a stable IP Address, DNS Name, and Port.
- A Service provides Service Discovery for Applications to locate each other on a Network.

<p align="center">
  <img src="https://user-images.githubusercontent.com/29623199/209472908-0cb1c1ad-0f53-4774-9ffa-d03180b796df.png" alt="Service" width="75%"/>
</P>

- A Service can be one of the following Types: ClusterIP, NodePort, ExternalName and LoadBalancer.

#### Service Type: ClusterIP

- **ClusterIP** (Default) is used only for internal Access.

<p align="center">
  <img src="https://user-images.githubusercontent.com/29623199/209473002-685ef877-2884-4f22-b41b-14d7fdd15b7d.png" alt="Service" width="50%"/>
</P>

#### Service Type: NodePort

- **NodePort** allows to open one specific Port on all Nodes.

<p align="center">
  <img src="https://user-images.githubusercontent.com/29623199/209473015-7b537872-1b15-4568-a817-211d328724ed.png" alt="Service" width="50%"/>
</P>

#### Service Type: ExternalName

- **ExternalName** does not have Selectors and uses DNS Names instead.

#### Service Type: LoadBalancer

- LoadBalancer exposes the Application to the Internet and creates a Load Balancer per Service.

<p align="center">
  <img src="https://user-images.githubusercontent.com/29623199/209477834-fd68f5dc-ba13-4fa9-9781-9ed158467b60.png" alt="LoadBalancer" width="50%"/>
</P>

### Ingress Controller (Reverse Proxy)

- The Ingress Controller in Kubernetes acts as a Reverse Proxy, managing external Access to Services within the Cluster. It routes external HTTP and HTTPS Traffic to internal Services based on URL and other Request Attributes.
- It differs from other Service Types like ClusterIP and NodePort by handling external Traffic and Providing a single Entry Point to the Cluster, enhancing Security and Efficiency.
- Ingress Rules define Traffic Routing, simplifying external Access Configuration and offering Features like SSL/TLS Termination, path-based Routing, and Load Balancing.
- Implemented using Tools like NGINX, HAProxy, or Traefik, the Ingress Controller requires Deployment in the Cluster and defining Ingress Resources for Traffic Routing.
- Ingress Controller centralizes Routing Rules, making Management and Updates more straightforward and efficient.

<hr>

### ConfigMaps

- A **ConfigMap** is a Map of Key-Value Pair that allows storing Configuration Data for an Container Images.
- It allows reusing Container Images across different Environments like Dev, Test, Staging and Production.
- Configuration Changes can be disruptive, so Application Configurations are often separated into ConfigMaps.
- Changes made to ConfigMaps will not be automatically reflected in running Containers.

<hr>

### Secrets

- A Secret is used to store and manage sensitive Information.
- Sensitive Data should not be stored using ConfigMaps.

<hr>

### Namespaces

- A **Namespace** organizes Objects in the Cluster.
- By Default, Kubectl interacts with the default Namespace.
- The **default Namespace** is used for Objects with no other Namespace specified.
- The **kube-system Namespace** is used for Objects created by the Kubernetes System.
- The **kube-public Namespace** is created automatically and is readable by all Users. It is mostly reserved for Cluster Usage when some Resources should be visible and readable publicly throughout the whole Cluster.
- The **kube-node-lease Namespace** is used for lease Objects associated with each Node, improving the Performance of Node Heartbeats as the Cluster scales.

<hr>

### StatefulSets

- A StatefulSet is used to deploy and manage stateful Applications like Databases and other long-lived Applications.
- It uses the Persistent Volume to store Data.

<hr>

## Managed Kubernetes

- A managed Kubernetes abstract the Master Node so that only the Worker Node need to be set up.
- One managed Kubernetes Solution is Amazon Elastic Kubernetes Service (EKS).

<p align="center">
  <img src="https://user-images.githubusercontent.com/29623199/133920258-c8be5005-2e30-469a-87e8-7afac12f48ad.JPG" alt="Amazon Elastic Kubernetes Service" width="50%"/>
</P>

- The Amazon EKS offers the following Options for Worker Nodes in the Cluster:

  - AWS Fargate: Used to deploy serverless Containers.
  - Amazon EC2: Used to deploy long-running Containers.

- Minikube is a managed Kubernetes Solution for local Development or Continuous Integration.

<hr>

### Minikube Commands

| Command                              | Description                                            |
| ------------------------------------ | ------------------------------------------------------ |
| minikube start                       | Starts Cluster                                         |
| minikube start --nodes=2             | Starts Cluster with two Nodes (Master and Worker Node) |
| minikube status                      | Shows Status of Cluster                                |
| minikube stop                        | Stops Cluster                                          |
| minikube delete                      | Removes Cluster                                        |
| minikube ssh --node minikube-m02     | SSH into Node                                          |
| minikube service <node_name>         | SSH Tunnel into Node allows to interact with it        |
| minikube ip --node minikube          | Gets IP address of Master Node                         |
| minikube ip --node minikube-m02      | Gets IP address of Worker Node                         |
| minikube logs -f                     | Getting and following Logs for Master Node             |
| minikube logs --node minikube-m02 -f | Getting and following Logs for Master Node             |

<hr>

### Kubectl

- Kubectl is a CLI (Command Line Interface) Tool used to interact with the Kubernetes Cluster.
- It allows running Commands against a Cluster for Tasks such as deploying Applications, inspecting and managing Resources, editing Configurations, debugging, and viewing Logs.

<p align="center">
  <img src="https://user-images.githubusercontent.com/29623199/133933595-afd7a003-7282-4959-abdb-faa0d680064c.JPG" alt="Kubectl" width="75%"/>
</P>

- Kubectl uses **Process Health Checks** to monitor Applications, restarting them if necessary.
- Kubelet uses **Liveness Probes** to determine when to restart a Container.
- Kubelet uses **Readiness Probes** to determine when a Container is ready to start accepting Traffic.

#### Kubectl Commands (Declarative Management)

| Command                                                           | Description                                                  |
| ----------------------------------------------------------------- | ------------------------------------------------------------ |
| kubectl version --client                                          | Shows Version of kubectl                                     |
| kubectl run hello-world --image=<container_repository> --port=80  | Runs a Pod in Cluster (Minikube)                             |
| kubectl get pods                                                  | Show all Pods in Cluster from default Namespace              |
| kubectl get pods --selector="environment=test"                    | Show all Pods in Cluster with specific Label                 |
| kubectl get pods -l 'environment in (test)'                       | Show all Pods in Cluster with specific Label                 |
| kubectl describe pod hello-world                                  | Describes a specific Pod                                     |
| kubectl logs hello-world<pod_name> -c hello-world<container_name> | Logs the Output of a specific Container                      |
| kubectl port-forward pod/hello-world 8080:80                      | Port-Forwarding for Pod (only for Testing)                   |
| kubectl delete pod hello-world/hello-world                        | Deletes a specific Pod                                       |
| kubectl get nodes                                                 | Get all (Master and Worker) Nodes in Cluster                 |
| kubectl apply -f manifest.yaml                                    | Applies the given Template to create Resources               |
| kubectl delete -f manifest.yaml                                   | Deletes the Resources given in the Template                  |
| kubectl exec -it hello-world -c hello-world -- bash               | Executes into a specific Container in a Pod                  |
| kubectl port-forward pod/hello-world 8042:80                      | Port-forwards a specific Port from the Host to the Container |
| kubectl rollout history deployment hello-world                    | Shows the Rollout History for a specific Deployment          |
| kubectl rollout undo deployment hello-world                       | Rollbacks to the previous Version of the Deployment          |
