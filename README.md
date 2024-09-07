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
- Volumes can have different access modes:
  - **ReadWriteOnce (RWO)**: The Volume can be mounted as read-write by a single Node.
  - **ReadOnlyMany (ROX)**: The Volume can be mounted as read-only by multiple Nodes.
  - **ReadWriteMany (RWX)**: The Volume can be mounted as read-write by multiple Nodes.
- Kubernetes allows flexible Management of these Volumes, supporting various underlying Storage Systems and Drivers. Below are some of the key volume types and storage solutions available in Kubernetes:

##### Local Storage

- **Local Storage** refers to Volumes mounted from the Host Machine's local Disk into the Pod's Filesystem. Like:
  - **EmptyDir**: Temporary Storage that is deleted when the Pod is deleted.
  - **HostPath**: Maps a File or Directory from the Host to the Pod.
- While simple to use, Local Storage is not recommended for high Availability Setups since the Data is tied to a single Node. If the Node fails, the Data becomes inaccessible to other Nodes in the Cluster.
- Example Use Case: Storing Data for Applications running on a single-node Kubernetes Setup.
- Example:

  ```yaml
  volumes:
    - name: local
      hostPath:
      path: /path/on/host
  ```

##### Network File System (NFS)

- **NFS Volumes** are a popular Choice for shared Storage across multiple Nodes, allowing Applications on different Nodes to access the same Data.
- NFS Volumes is particularly useful for Applications that require shared Storage but need to maintain Data consistency across Pods.
- NFS Volumes support various Access Modes, including ReadWriteMany (RWX), making them suitable for multi-node Deployments.
- Example:
  ```yaml
  volumes:
    - name: nfs
      nfs:
        server: <NFS_SERVER_IP>
        path: /path/on/nfs/server
  ```

##### Persistent Volumes and Persistent Volume Claims (PVC)

- **Persistent Volumes (PV)**: Persistent Storage Resources created by an Administrator. These Volumes exist independently of any specific Pod and can be reused.
- **Persistent Volume Claims (PVC)**: A Request for Storage by a User. PVCs consume PV Resources based on defined Storage Capacity and Access Modes.

###### Persistent Volume Claim (PVC)

- A **Persistent Volume Claim** is used to bind a Pod to a Persistent Volume.
- A PVC requests Storage from the available PVs in the Cluster. Once a Match is found based on the Access Mode and Storage Capacity, the PVC is bound to the PV.
- PVCs are namespace-scoped, meaning they must be created in the same Namespace as the Pods that will use them.
- Example:

  ```yaml
  apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
  name: my-pvc
  spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  ```

###### Dynamic Provisioning

- **Dynamic Provisioning** simplifies Storage Management in Kubernetes. When a PVC is created, Kubernetes automatically provisions the required PV based on the specified Storage Class.
- Dynamic Provisioning eliminates the Need for pre-provisioning Storage and allows Kubernetes to handle the underlying Storage Allocation.
- Example:

  ```yaml
  apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
  name: dynamic-pvc
  spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: <Dynamic_Storage_Class>
  resources:
    requests:
      storage: 5Gi
  ```

###### Storage Class

- A **Storage Class** defines the Types of Storage available in a Kubernetes Cluster and provides Parameters to dynamically provision PVs.
- Different Storage Backends (e.g., NFS, cloud storage) require different Storage Class Configurations.
- In Cloud Environments, using a Storage Class simplifies Storage Management by automating PV Creation and Deletion.
- Example:

  ```yaml
  apiVersion: storage.k8s.io/v1
  kind: StorageClass
  metadata:
  name: standard
  provisioner: kubernetes.io/aws-ebs
  parameters:
  type: gp2
  zones: us-west-2a, us-west-2b
  ```

##### Cloud Storage

- Cloud Storage is a managed Service provided by Cloud Platforms, offering high Availability, Durability, and Ease of Use.
- Kubernetes integrates seamlessly with Cloud Storage services (e.g., AWS EBS, Google Cloud Persistent Disks, Azure Disks) through dynamic Provisioning. This means that when a Persistent Volume Claims (PVC) is created, the Cloud Provider automatically provisions the necessary Storage.
- Cloud Storage often supports the ReadWriteOnce (RWO) Access Mode, although some Cloud Providers also support ReadWriteMany (RWX).
- Example:

  ```yaml
  apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
  name: cloud-pvc
  spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: <Cloud_Storage_Class>
  resources:
    requests:
      storage: 1Gi
  ```

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

### Config Maps

- A **Config Map** in Kubernetes is a Resource used to store Configuration Data as Key-Value Pairs or Files, which can be consumed by Application Containers. This enables the decoupling of Configuration Artifacts from Image Content to keep containerized Applications portable.
- ConfigMaps are essential when there is a Need to manage Environment Variables, Command-Line Arguments, or Configuration Files that an Application depends on. They are stored centrally within Kubernetes and can be referenced by any Pod within the cluster.
- The `data` Field in a Config Map can contain the Key-Value Pairs or File Content. Files can be added to a Config Map by defining the Filename and using the Pipe Operator to input the File's Contents.
- Example:

  ```yaml
  apiVersion: v1
  kind: ConfigMap
  metadata:
  name: example-config
  data:
  config.json: |
    {
      "key": "value",
      "another_key": "another_value"
    }
  log_level: "debug"
  ```

- In a Deployment, a Config Map can be mounted as a Volume or used to populate Environment Variables within Containers. This allows dynamic Configuration without rebuilding Container Images.
- Example:

  ```yaml
  volumes:
    - name: config-volume
      configMap:
        name: example-config
  containers:
    - name: myapp
      image: myapp:latest
      volumeMounts:
        - name: config-volume
          mountPath: /app/config
      env:
        - name: LOG_LEVEL
          valueFrom:
            configMapKeyRef:
              name: example-config
              key: log_level
  ```

  <hr>

### Secrets

- **Secrets** in Kubernetes are similar to Config Maps but are specifically designed to store sensitive Information such as Passwords, Tokens, or SSH Keys. While Config Maps are intended for non-sensitive Data, Secrets provide a base64-encoded Method to handle confidential Data.
- Kubernetes provides different Types of Secrets, including Opaque for generic Secrets and specialized Types like `kubernetes.io/tls` for TLS Certificates.
- Example:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: example-secret
type: Opaque
stringData:
  username: admin
  password: p@ssw0rd
```

- Secrets can be used in a Deployment to inject sensitive Information into Containers as Environment Variables or as Files mounted on the Filesystem. This Method ensures that Credentials and other sensitive Data are not hardcoded into the Application or its Configuration.
- Example:

```yaml
env:
  - name: DB_USERNAME
    valueFrom:
      secretKeyRef:
        name: example-secret
        key: username
  - name: DB_PASSWORD
    valueFrom:
      secretKeyRef:
        name: example-secret
        key: password
volumes:
  - name: secret-volume
    secret:
      secretName: example-secret
containers:
  - name: myapp
    image: myapp:latest
    volumeMounts:
      - name: secret-volume
        mountPath: /app/secret
        readOnly: true
```

- Although Secrets in Kubernetes are base64-encoded, this is not Encryption and should not be considered highly secure by itself. The Data stored in Secrets is accessible to anyone with Access to the Kubernetes API or etcd Database, where Kubernetes stores all its Data.
- It is recommended to use Secrets in Combination with Kubernetes RBAC (Role-Based Access Control) and secure etcd with Encryption at Rest and proper Access Controls.
- Additionally, Integrating Tools like Vault by HashiCorp or Kubernetes' native Encryption Providers can add an extra Layer of Security to Secrets Management.

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

- **Minikube** is a managed Kubernetes Solution for local Development or Continuous Integration.

<hr>

### Minikube Commands

| Command                             | Description                                                                              |
| ----------------------------------- | ---------------------------------------------------------------------------------------- |
| minikube start                      | Starts a Minikube Cluster with the default Configuration                                 |
| minikube start --nodes=<number>     | Starts a Minikube Cluster with <number> Nodes (one Master and <number-1> Worker Nodes)   |
| minikube status                     | Displays the current Status of the Minikube Cluster                                      |
| minikube stop                       | Stops the running Minikube Cluster                                                       |
| minikube delete                     | Deletes the Minikube Cluster and all associated Resources                                |
| minikube ssh --node <node_name>     | SSH into a specific Node within the Minikube Cluster                                     |
| minikube service <service_name>     | Opens a SSH Connection to a Service, allowing interaction with it from the local Machine |
| minikube ip --node <node_name>      | Retrieves the IP Address of a specific Node in the Minikube Cluster                      |
| minikube logs -f                    | Streams and follows the Logs of the Minikube Master Node                                 |
| minikube logs --node <node_name> -f | Streams and follows the Logs of a specific Node in the Minikube Cluster                  |

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

| Command                                                      | Description                                                                                 |
| ------------------------------------------------------------ | ------------------------------------------------------------------------------------------- |
| kubectl version --client                                     | Shows Version of Kubectl Client                                                             |
| kubectl run <pod_name> --image=<image> --port=<port>         | Creates and runs a new Pod in the Cluster using the specified Image and Port                |
| kubectl get pods                                             | Lists all Pods in the current Namespace                                                     |
| kubectl get pods --selector="<label_selector>"               | Lists Pods in the Cluster that match a specific Label Selector                              |
| kubectl get pods -l '<label_selector>'                       | Lists Pods in the Cluster that match a specific Label Selector                              |
| kubectl describe pod <pod_name>                              | Displays detailed Information about a specific Pod                                          |
| kubectl logs <pod_name> -c <container_name>                  | Retrieves the Logs from a specific Container within a Pod                                   |
| kubectl port-forward pod/<pod_name> <local_port>:<pod_port>  | Forwards a local Port to a Port on a Pod, useful for accessing the Pod locally or testing   |
| kubectl delete pod <pod_name>                                | Deletes a specific Pod from the Cluster                                                     |
| kubectl get nodes                                            | Lists all Nodes in the Cluster, including both Master and Worker Nodes                      |
| kubectl apply -f <manifest_file>                             | Applies the Configuration from a specified YAML Manifest File to create or update Resources |
| kubectl delete -f <manifest_file>                            | Deletes Resources defined in the specified YAML Manifest File                               |
| kubectl exec -it <pod_name> -c <container_name> -- <command> | Executes a Command inside a specific Container within a Pod interactively                   |
| kubectl rollout history deployment/<deployment_name>         | Displays the Rollout History of a specific Deployment                                       |
| kubectl rollout undo deployment/<deployment_name>            | Reverts a Deployment to its previous Version                                                |

<hr>

## Ingress Controller (Reverse Proxy)

- The **Ingress Controller** in Kubernetes manages external Access to Services within the Cluster, often using Reverse Proxy Techniques. It accepts HTTP and HTTPS Traffic and forwards it based on defined Rules, making the Services accessible from Outside the Kubernetes Cluster.
- Unlike using a Load Balancer for each Service, an Ingress Controller routes Traffic based on more granular Rules, such as Hostname, Path, or Header Information. This allows multiple Services to be exposed over the same IP or Port, with Traffic distributed accordingly.
- It is used to enhance Security by managing SSL/TLS Termination, Routing Rules, and other Features like path-based Routing or rewriting Headers before forwarding the Traffic.
- To define how the Traffic should be managed, Ingress Objects are used. These Objects define Rules about Routing external Requests to internal Services within the Cluster.
- A Kubernetes Ingress Controller can be implemented with several Tools, such as NGINX, Traefik, HAProxy, or other Reverse Proxies.

### How Ingress Works

- The **Ingress Object** defines how the Service is accessed from Outside the Cluster. It allows Customization of Routing Rules, SSL Handling, and Traffic Direction based on the Service's external Domain or internal Policies. Each Ingress Object can define:
  - **Hosts**: Specify which Domain or Subdomain is being routed.
  - **Paths**: Define specific URL Paths for Traffic Forwarding.
  - **Backend Services**: The Kubernetes Service to which Traffic should be forwarded, including the Port to use.
- Ingress Controllers support SSL/TLS Termination to provide secure HTTPS Access to Services. They handle SSL Certificates either through static Files or dynamically via Services such as Let's Encrypt, ensuring that Services can be securely exposed to the Internet.
- Ingress can centralize Traffic Management for multiple Services, simplify SSL Certificate Management, and reduce the Need for multiple Load Balancers.

### SSL/TLS Termination

- Ingress Controllers simplify SSL/TLS Termination, which involves Managing Certificates and Handling secure Connections on Behalf of Services. A Approach is to automatically retrieve Certificates from Certificate Authorities (CAs) such as Let's Encrypt, using a DNS or HTTP Challenge to prove Domain Ownership.
- Controllers like Traefik can manage SSL/TLS Certificates dynamically, ensuring Services are exposed securely. The Certificates are stored persistently, avoiding Re-issuance upon Restarts, and can be configured with Automation for Renewals.

<hr>

## Secure Access to Kubernetes Clusters and SSH Servers

- Managing secure Access to Kubernetes Clusters, SSH Servers, and Web Interfaces is crucial in any Infrastructure Environment. Ensuring proper Authentication, Permissions, and Logging of User Activities across these Systems is essential for maintaining Security and Control over Resources.

### Access Management and Authentication

- One of the primary Challenges in managing Infrastructure is Controlling and Securing Access for Users. In distributed Environments, managing SSH Keys, VPNs, and Authentication Mechanisms can become complex. This Issue is amplified when multiple Users or Teams need Access to various Resources such as Servers, Databases, or Kubernetes Clusters.
- A **Unified Access Plane** (UAP), such as Teleport, addresses this Challenge by centralizing Authentication, Permission Management, and Access Control in one Platform. This System ensures that Access to critical Infrastructure, whether it is a Linux Server, Kubernetes Cluster, or Web Application, is secure, auditable, and manageable.

### Two-Factor Authentication (2FA)

- To further enhance Security, it is essential to use Two-Factor Authentication for Access to sensitive Systems. 2FA requires both a Password and an additional Authentication Factor, typically a Token generated by an Authenticator App. This ensures that even if User Credentials are compromised, unauthorized Access remains difficult without the second Factor.
- Each Login is protected by 2FA, ensuring that Credentials alone are insufficient to gain Access. This is critical in preventing unauthorized Access to Kubernetes Clusters, SSH Servers, and Web Interfaces.

### Role-Based Access Control (RBAC)

- Role-based Access Control is another critical Feature that enables Administrators to define User Permissions based on Roles. Each Role specifies which Resources a User can access and what Actions they are allowed to perform. This fine-grained Control ensures that users have Access only to the Resources necessary for their Tasks, reducing the Risk of accidental or malicious Changes.
- RBAC also applies to Kubernetes, where role-based Policies can be defined for Namespaces, Resources, and cluster-wide Access. Users and Groups can be assigned specific Roles, granting them Access only to the Namespaces or Workloads they are responsible for managing.

### Session Recording and Audit Logging

- Every Session conducted via Teleport is logged and recorded. This ensures full Visibility into User Activities, allowing Administrators to monitor and review Access to Resources. The Session Recording Functionality creates a detailed Audit Trail, enabling Review of what Actions were performed during each Session. This is especially important for Compliance and Security Purposes, as it allows Organizations to track User Activities and investigate any unusual or suspicious Behavior.
- Audit Logs provide a comprehensive View of all Access Attempts, failed Logins, and Activities within the Infrastructure. These Logs can be invaluable for Troubleshooting, Compliance Audits, and detecting potential Security Incidents.

### Teleport for SSH and Kubernetes Access

- Teleport simplifies secure Access to both SSH Servers and Kubernetes Clusters by integrating with existing Environments and providing secure Authentication Mechanisms. Once deployed, it can manage Access to multiple Resources, ensuring that Users connect securely to Servers or Clusters without needing direct Access to Credentials like SSH keys or kubeconfig Files.
- For SSH Access, Teleport handles Authentication via a central Interface, eliminating the Need for distributing and managing SSH Keys. Users can log in to the System through a Web Interface or a Terminal Client, with each Session being logged and monitored.
- For Kubernetes Access, Teleport integrates with Clusters by providing short-lived Certificates that replace long-lived kubeconfig Files. This enhances Security by reducing the Risk of compromised Credentials and simplifies Access Management by enabling role-based Access Controls for Kubernetes Resources.

<hr>

## Helm

- **Helm** is a Package Manager for Kubernetes that simplifies the Installation, Management, and Upgrading of Applications on Kubernetes Clusters. It functions similarly to traditional Package Managers like `apt` but is specifically designed for Kubernetes.
- Using Helm can significantly reduce the Complexity involved in deploying Applications that require multiple Kubernetes Resources, such as Deployments, Services, Config Maps, Secrets, and Persistent Volumes. Instead of manually creating and managing these Resources through separate Manifest Files, Helm allows grouping them into a single Package known as a **Chart**.
- Helm also supports the creation of custom Charts. Custom Charts can be packaged and stored in a private or public Repository, making them reusable across multiple Deployments.

### Helm Charts

- **Helm Charts** are pre-configured Templates that define all the Kubernetes Resources needed to run a particular Application. Each Chart encapsulates the Details required to deploy an Application, including default Configurations, Service Definitions, and Dependencies.
- Charts are available for a wide Range of Applications, from simple Web Servers to complex Systems like Databases and Content Management Platforms. They can be customized to meet specific Needs by overriding default Values provided within the Chart.

### Deploying Applications

- Helm can be configured to work with a Kubernetes Cluster by ensuring that Kubectl is properly set up. Helm uses the same Configuration Settings as Kubectl, including the Namespace Context.
- Before deploying Applications, it is necessary to add Repositories where Helm Charts are stored. Repositories are similar to those used in other Package Managers, providing a Collection of Charts that can be searched and installed.

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
```

- Once a Repository is added, Applications can be deployed using a simple Command that specifies the Chart and any Custom Configurations. Helm handles the Deployment by creating all necessary Kubernetes Resources as defined in the Chart.

```bash
helm install my-webserver bitnami/nginx
```

### Managing Helm Releases

- Helm tracks the History of each Application Deployment, known as a **Release**. Each Release is versioned, allowing Updates to be applied incrementally and enabling Rollbacks if something goes wrong.
- Releases are managed through Helm Commands, which can list installed Charts, view History, and update or rollback Changes.

### Customizing Helm Charts

- While Helm Charts come with default Configurations, these can be customized to suit specific Requirements by providing a Values File. The Values File overrides the default Settings specified in the Chart.
- Custom Values are passed to Helm during the Installation or Upgrade of a Chart, enabling tailored Deployments without modifying the original Chart Files.

```bash
helm install my-blog bitnami/wordpress -f custom-values.yaml
```

### Updating and Rolling Back Helm Releases

- Helm allows Updates to be made to an existing Release by specifying new Values or applying a newer Version of the Chart. If an Update introduces Issues, Helm provides the Capability to rollback to a previous Release.
- The Rollback Command reverts the Deployment to a specific **Revision**, making it easy to undo Changes that have caused Problems.

```bash
helm rollback my-blog 1
```

### Helm Commands

| Command                                 | Description                                                              |
| --------------------------------------- | ------------------------------------------------------------------------ |
| helm repo add <name> <url>              | Adds a new Helm Repository to the local Configuration                    |
| helm repo list                          | Lists all Repositories that have been added to the local Configuration   |
| helm search repo <keyword>              | Searches for Helm Charts in the configured Repositories                  |
| helm install <release_name> <chart>     | Installs a Helm Chart with the specified Release Name                    |
| helm list                               | Lists all Helm Releases in the current Namespace                         |
| helm upgrade <release_name> <chart>     | Upgrades an existing Helm Release with a new Chart or updated Values     |
| helm rollback <release_name> <revision> | Rollbacks a Helm Release to a specific Revision Number                   |
| helm uninstall <release_name>           | Uninstalls a Helm Release and removes all associated Kubernetes Objects. |
| helm show values <chart>                | Displays the default Values for a specific Chart                         |
| helm history <release_name>             | Shows the History of a specific Helm Release, including all Revisions    |
| helm template <chart>                   | Renders the Chart Templates locally without installing them              |
| helm get all <release_name>             | Retrieves all Information about a deployed Release                       |

## Portainer on Kubernetes

- **Portainer** is a Tool that simplifies the Management of Container Environments through a user-friendly Web Interface. While traditionally used with Docker, Portainer also supports Kubernetes, making it easier for Administrators to manage Kubernetes Resources without relying solely on Command-line Tools like Kubectl or Helm.

## Installing Portainer on Kubernetes

- Portainer can be installed directly on a Kubernetes Cluster or remotely to manage multiple Clusters. There are two primary Methods for deploying Portainer on Kubernetes:
  1. Kubernetes Manifests: Portainer provides Manifest Example Files that can be customized according to specific Needs. This Approach involves manually applying these Manifests using Kubectl.
  2. Helm Chart: The simpler and more automated Approach is using Helm, the Package Manager for Kubernetes. Helm makes it easier to install, configure, and upgrade Portainer by handling Dependencies and Custom Configurations.
     STOPP
     - To install Portainer via Helm, ensure that the Kubernetes Cluster has a Valid Storage Class to persist Data. Most Cloud Providers configure this by default. After setting up Storage, the next Step is to add the Portainer Helm Repository and update the local repository cache to ensure the latest charts are used.
- Portainer can be exposed using various Methods, depending on the Environment:
  - **NodePort**: This Method exposes the Portainer Web UI through a specific Port on the Nodes.
  - **Ingress**: Requires an Ingress Controller like NGINX or Traefik to manage Access through an Ingress Resource.
  - **Load Balancer**: This is the easiest Method, automatically provisioning a public IP Address and exposing Portainer's Web Interface.

### Securing the Portainer Web UI

- By default, Portainer's Web UI is exposed via both HTTP (Port 9000) and HTTPS (Port 9443) with a self-signed Certificate. It is recommended to restrict Access to the HTTP Port and ensure only HTTPS Connections are allowed.
- For additional Security, Firewall Rules should be applied to limit Access to trusted IP Addresses. Another Option is to expose the Portainer Web UI using an Ingress Controller and obtain trusted SSL Certificates through Services like Let's Encrypt.
- Alternatively, integrating with Tools such as Teleport adds Layers of Security, allowing to implement 2FA and restrict Access through a Jump Host.

### Features of Portainer for Kubernetes

- Portainer offers an intuitive UI that simplifies managing Kubernetes Clusters. Some of the Key Features include:
- **Resource Management**: Portainer allows Users to easily create, edit, and delete Kubernetes Resources such as Namespaces, Deployments, Config Maps, Secrets, and Persistent Volumes. The UI provides a clear View of what Resources are running, their Namespaces, and their Statuses.
- **Helm Chart Integration**: Another Features is the Ability to deploy Helm Charts directly from the UI. Users can browse Helm Repositories, select Charts, and customize Values before Deployment.
- **Application Menu**: This provides a detailed Overview of all running Resources, including Pods, Daemon Sets, Port Mappings, and more. Applications can be deployed using Forms, making it easy for those who are less familiar with Kubernetes Commands to manage Resources. Additionally, YAML Manifests can be uploaded directly into Portainer, or Docker Compose Templates can be translated into Kubernetes Manifests.

### Ingress Configuration

- The Ingress Configuration in Portainer allows Users to expose Applications publicly. It requires enabling Ingress in both the Cluster Setup and each Namespace. Once enabled, Ingress Routes can be created for specific Applications within the Namespace.
- A limitation is that Users must predefine the allowed Hostname at the Namespace Level before configuring Ingress for an Application. While this may provide better Control over Hostname Usage, it can be cumbersome for Users managing multiple Subdomains.

### GitOps with Portainer

- Portainer is integrated with Git, which enables GitOps Workflows. This allows Users to automate Deployments by linking Git Repositories directly with Kubernetes Clusters managed through Portainer. By configuring a Git Repository containing Kubernetes Manifests, Portainer can automatically deploy and manage Resources based on Changes in the Repository.
- Users can set up Repositories from GitHub, GitLab, or private Git Servers, specify the Branch, and define the Deployment Path. Automatic Updates can be configured to periodically check the Repository for Changes and apply them to the Cluster.
- This GitOps Feature streamlines Infrastructure Management and reduces the Need for complex CI/CD Pipelines, making it easier to integrate Automation into Kubernetes Environments.
