# Kubernetes

- Kubernetes is an Application Orchestrator
- It deploys and manages Applications
- Applications are Containers which run Images of various Applications
- It scales up and down the Applications according Demand
- It allows Zero-Downtime Deployments

## Cluster

- Cluster ist a Set of Nodes
- A Node can be a Virtual or Physical Machine which runs in the Cloud or On Premises

## Kubernetes Architecture

<p align="center">
  <img src="https://user-images.githubusercontent.com/29623199/133905860-332dcbbf-40a8-4f32-a2b9-0aaa17d34aae.JPG" alt="Kubernetes Architecture" width="50%"/>
</P>

<hr>

### Master Node

- Master Node makes the Decision for the Cluster
- Master Node and Worker Nodes communicate via the Kubelet
- The Master Node contains the **Control Plane**

#### Control Plane

- The Control Plane is made of several Components which are communicating via the API-Server
- Could Controller Manager communicates with the underlying Cloud Provider (for Example AWS)

<p align="center">
  <img src="https://user-images.githubusercontent.com/29623199/133905831-033273c3-b05f-4796-88dc-ce835dba2e5a.JPG" alt="Control Plane" width="75%"/>
</P>

- The Control Plane contains the following Components:

#### API Server

- The API Server is the Frontend to the **Control Plane**
- All Communications (external and internal) go through the API Server
- It exposes a restful API on Port 443

#### Cluster Store

- The Cluster Store stores Configuration and State of the entire Cluster
- It uses a distributed Key-Value Data Store etcd which is the single Source of Truth

#### Scheduler

- The Scheduler watches for new Workloads / Pods and assigns them to a Worker Node based on several Scheduling Factors:
  - Is the Pod healthy?
  - Has the Pod enough Resources?
  - Has the Pod available Ports?
  - Has the Pod Affinity or Anti Affinity Rules?

#### Controller Manager

- The Controller Manager is a Daemon that manages the Control Loop
- It watches the current State of the API Server for Changes that does not match the Desire State
- It is a Controller of Controllers
  - **Node Controller**: When the current State does not match the Desire State then the Node Controller reacts to
    those Changes and establishes the Desire State
  - **ReplicaSet**: The ReplicaSet (Controller) is responsible to ensure that the correct Number of Pods are running
  - **Endpoint**: The Endpoint (Controller) assigns Pods to Services
  - **Namespace**, **Services Accounts**, etc.

##### Cloud Controller Manager

- The Cloud Controller Manager is responsible to interact with the underlying Cloud Provider (for Example AWS)

<hr>

### Worker Node

- Worker Nodes make the Computational Power of the Cluster - runs the Applications
- It is a physical Machine or VM that provides the Running Environment for Applications
- The Applications should be should split into Microservices in Order to run well on Worker Nods
- A Worker Node consists of following three Components:
  - **Kubelet**: Kubelet is an Agent
  - **Container Runtime**
  - **Kube Proxy**

<p align="center">
  <img src="https://user-images.githubusercontent.com/29623199/133918227-22f32945-9192-4750-b4fd-be8ed340c84e.JPG" alt="Worker Node" width="50%"/>
</P>

#### Kubelet

- Kubelet is the primary "Node Agent" that runs on each Node
- It receives Pod Definition from the **API Server**
- It interacts with the **Container Runtime** to run Containers associated with the Pod
- it reports Node and Pod State to the **Master Node** through the **API Server**
- It can register the Node with the **API Server** using one of: the Hostname - a Flag to override the Hostname - or
  specific Logic for a Cloud Provider

<p align="center">
  <img src="https://user-images.githubusercontent.com/29623199/133918337-e177688b-cc7f-441c-9427-75c5f4d9453e.JPG" alt="Kubelet" width="50%"/>
</P>

#### Container Runtime

- The Container Runtime is responsible to pulling Images from the Container Registry
- It is responsible for running Containers of those Images and abstracts Container Management for Kubernetes
- It provides the CRI (Container Runtime Interface) that is an Interface for third Party Container Runtime
- It provides the Container Runtime **_containerd_** that is an Industry-Standard (besides Docker)
  - **_containerd_**: It manages the complete Container Lifecycle of its Host System, from Image Transfer and Storage
    to Container Execution and Supervision to Low-Level Storage to Network attachments and beyond

<p align="center">
  <img src="https://user-images.githubusercontent.com/29623199/133918601-fc82f4f2-bb9e-4bd5-be23-ee40c10e623b.JPG" alt="Container Runtime" width="50%"/>
</P>

#### Kube Proxy

- Kube Proxy is an Agent that runs on each Node through a DaemonSet
- It is responsible for local Cluster Networking where each Node gets it own unique IP Address
- It is responsible for Routing the Network Traffic as Load Balancer for the Services
- It maintains Network Rules to allow Communication to Pods from inside and outside the Cluster
- It implements a Controller that watches the API Server for new Services and Endpoints

### Pods

- A Pod is the smallest deployable Unit in Kubernetes (and not Containers)
- It is a Group of one or more Container which represents a running Process
- It has a unique IP Address to communicate with other Pods
- A Pod shares Network and Volumes
  - A Pod can contain Volumes to share Data between Container (which are inside it these Pod)
  - Container inside a Pod are using as Address localhost with their own Port to communicate together
- Init Containers are run before the Main Container
- Side Containers support the Main Container
- A DaemonSet ensures that a Copy of a Pod is running across the Cluster / on each Worker Node

<p align="center">
  <img src="https://user-images.githubusercontent.com/29623199/133935228-c55da185-b448-4e88-bb8c-d459802ee8af.JPG" alt="Pod" width="50%"/>
</P>

#### Resource Management

- A Pod can define the minimum Amount of resources a Container needs (Request)
- A Pod can define the maximum Amount of resources a Container can have (Limit)

#### Volumes

##### EmptyDir Volume

- A EmptyDir Volume is a temporary Directory that shares a Pod's Lifetime
- It is initially empty and shares Data between Containers in one Pod

##### HostPath Volume

- A HostPath Volume is used when Applications need to access to the underlying Host File System

##### Persistent Volume

- A Persistent Volume stores Data beyond the Pod Lifecycle, therefore it does not matter if a Pod fails or moves to a different Node
- **PersistentVolume** is a Storage Resource provided by an Administrator
- **PersistentVolumeClaim** is a User's Request for and claim to to a Persistent Volume
- **StorageClass** describes the PArameters for a Class of Storage for which PersistentVolumes can be dynamically provided

<hr>

### Deployments

- Pods should be only published through a Deployment
- A Deployment is a Kubernetes Resource that manages the Release of a new Application through Creating the Pods and Replicate Sets
- It provides Zero-Downtime Deployments - for Example if a Application contains a Bug and crushes the Deployment will release new Version fo the Application
- It creates a **ReplicateSet** for an Application
- A **ReplicateSet** ensurers that the desired Number of Pods are always running
- ReplicaSets are using Control Loops that implements a Background Control Loop that checks the sired Number of Pods are always present on the Cluster
- A ReplicateSet is not deleted when an new Version is released, instead it facilities for a Rollback to a previous Version

<p align="center">
  <img src="https://user-images.githubusercontent.com/29623199/209465647-475647df-a426-408f-97b8-4cde0469a4e3.png" alt="Deployment" width="50%"/>
</P>

<hr>

### Services

- A Service allows to interact with Pods in a Deployment without Port-Forwarding or knowing their IP Addresses
- The IP Address of a Service does not change - it is a stable IP Address
- A Service has a stable IP Address, DNS Name and Port
- It provides a Service Discovery for Application to locate each other on a Network

<p align="center">
  <img src="https://user-images.githubusercontent.com/29623199/209472908-0cb1c1ad-0f53-4774-9ffa-d03180b796df.png" alt="Service" width="75%"/>
</P>

- A Service can be one of the following Types: ClusterIP, NodePort, ExternalName and LoadBalancer

#### ClusterIP

- ClusterIP (Default) is used only for internal Access

<p align="center">
  <img src="https://user-images.githubusercontent.com/29623199/209473002-685ef877-2884-4f22-b41b-14d7fdd15b7d.png" alt="Service" width="50%"/>
</P>

#### NodePort

- NodePort allows to open one specific Port an all Nodes

<p align="center">
  <img src="https://user-images.githubusercontent.com/29623199/209473015-7b537872-1b15-4568-a817-211d328724ed.png" alt="Service" width="50%"/>
</P>

#### ExternalName

- ExternalName does not have Selectors and uses DNS Names instead

#### LoadBalancer

- LoadBalancer exposes the Application to the Internet
- It creates a Load Balancer per Service

<p align="center">
  <img src="https://user-images.githubusercontent.com/29623199/209477834-fd68f5dc-ba13-4fa9-9781-9ed158467b60.png" alt="LoadBalancer" width="50%"/>
</P>

<hr>

### ConfigMaps

- A ConfigMap is a Map of Key Value Pair that allows to store Configuration for an Container Images
- It allows to reuse a Container Images on different Environments like Dev, Test, Staging and Production
- Configuration Changes are disruptive, therefore an Application their Configuration is split
- Changes made to ConfigMaps will not be reflected on Containers

<hr>

### Secrets

- A Secret is used to store and manage sensitive Information
- Sensitive Data should not be stored by using ConfigMaps

<hr>

### Namespaces

- A Namespace organizes Objects in the Cluster
- By Default Kubectl interacts with the default Namespace
- The **default** Namespace is used for Objects with no other Namespace
- The **kube-system** is used for Objects created by the Kubernetes System
- The **kube-public** is created automatically and is readable by all Users
- **kube-public** is mostly reserved for Cluster Usage, in Case that some Resources should be visible and readable publicly throughout the whole Cluster
- **kube-node-lease** is used the lease Objects associated with each Node which improves the Performance of the Node Heartbeats as the Cluster Scales

<hr>

### StatefulSets

- A StatefulSet is used to deploy and manage stateful Applications like long lived Applications such as Databases
- It uses the Persistent Volume to store Data

<hr>

## Managed Kubernetes

- A managed Kubernetes abstract the Master Node so that only the Worker Node have to be set up
- One managed Kubernetes Solution is Amazon Elastic Kubernetes Service

<p align="center">
  <img src="https://user-images.githubusercontent.com/29623199/133920258-c8be5005-2e30-469a-87e8-7afac12f48ad.JPG" alt="Amazon Elastic Kubernetes Service" width="50%"/>
</P>

- The Amazon EKS allows as Worker Nodes for the Cluster the following Options:

  - AWS Fargate: AWS Fargate is used to deploy Server-less Containers
  - Amazon EC2: Amazon EC2 is used to deploy long-run Containers

- Minikube
  - Minikube is a managed Kubernetes Solution for local Development or Continuous Integration

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

### Kubectl

- Kubectl is a CLI (Command Line Interface) Tool to interact with the Cluster which is provided by Minikube
- It allows running the following Commands against a Cluster:
  - Deploy
  - Inspect
  - Edit Resources
  - Debug
  - View Logs

<p align="center">
  <img src="https://user-images.githubusercontent.com/29623199/133933595-afd7a003-7282-4959-abdb-faa0d680064c.JPG" alt="Kubectl" width="75%"/>
</P>

- It uses Process Health Check to check that a Application is alive and if it is not then it restarts the Process
- Kublet uses Liveness Probes to know when to restart a Container
- Kublet uses Readiness Probes to know when a Container is ready to start accepting Traffic

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
| kubectl apply -f pod.yaml                                         | Applies the given Template to create Resources               |
| kubectl delete -f pod.yaml                                        | Deletes the Resources given in the Template                  |
| kubectl exec -it hello-world -c hello-world -- bash               | Executes into a specific Container in a Pod                  |
| kubectl port-forward pod/hello-world 8042:80                      | Port-forwards a specific Port from the Host to the Container |
| kubectl rollout history deployment hello-world                    | Shows the Rollout History for a specific Deployment          |
| kubectl rollout undo deployment hello-world                       | Rollbacks to the previous Version of the Deployment          |
