# 💻 **Inception of Things** 🚀

![meme](https://github.com/chahid001/42Inception-of-Things/blob/main/assets/meme.webp)



This project demonstrates how to build a complete CI/CD pipeline with **GitOps**, **ArgoCD**, **K3D**, and **GitLab Runner** using the **Docker outside of Docker** method.


### Project Structure 🏗️

1. **Part 1**: 🌐 Create a K3s cluster with 2 VMs inside an Azure VM.
2. **Part 2**: 🖥️ Deploy apps with Nginx and Ingress on a single K3s VM.
3. **Part 3**: 🐳 Use **K3D** for K3s inside Docker and deploy apps using ArgoCD.
4. **Bonus**: 🔥 Add **GitLab** and integrate **GitLab Runner** to manage Docker builds and deployments with a **GitOps** workflow.

### Key Components 🛠️

- **Terraform**: To provision the Azure VM.
- **Vagrant**: For creating nested VMs running K3s.
- **K3D**: Run K3s inside Docker for the local environment.
- **ArgoCD**: Manage continuous delivery and automatic deployments from Git changes.
- **GitLab Runner**: CI/CD to build and push Docker images based on your code changes.
- **Kustomize Patch**: Modify ArgoCD to run in **insecure** mode, allowing easier GUI access without HTTPS.

## 🖼️ **Architecture Overview**:
The project has three main parts, with the focus on the **Bonus** section, where we implement **GitOps**.
### 🏗️ Bonus Architecture:

![](https://github.com/chahid001/42Inception-of-Things/blob/main/assets/archi-land.png)

The architecture consists of:
- We have **K3D** running **K3S** inside a Docker container on the host VM (Deployed with **Terraform**).
- **ArgoCD** is installed to manage the GitOps process, pulling deployment manifests from GitHub.
- **GitLab Runner** is installed as a container in the **K3D** cluster, but using the Docker volume technique to run jobs on the host's Docker engine.
- **Kustomize** is used to patch the `install.yaml` for ArgoCD to allow insecure access to the GUI without HTTPS.
---

### Key Components 🛠️

- **Terraform**: To provision the Azure VM.
- **Vagrant**: For creating nested VMs running K3s.
- **K3D**: Run K3s inside Docker for the local environment.
- **ArgoCD**: Manage continuous delivery and automatic deployments from Git changes.
- **GitLab Runner**: CI/CD to build and push Docker images based on your code changes.
- **Kustomize Patch**: Modify ArgoCD to run in **insecure** mode, allowing easier GUI access without HTTPS.

## 🌐 **GitOps Explained**:
**GitOps** is the practice of using Git as the single source of truth for declarative infrastructure and applications. In this project, we use **ArgoCD** to continuously monitor our GitHub repository for changes to the Kubernetes deployment manifests and automatically apply those changes to our **K3D** cluster.

### GitOps Workflow 🚀

This project uses a **GitOps** approach where changes in the Git repository automatically trigger deployment updates:

1. **GitLab Runner** builds the Docker image (using a simple Nginx `Dockerfile`) and pushes it to Docker Hub.
2. **ArgoCD** continuously monitors the Git repository.
3. When the **image version** changes (e.g., from `test:v1` to `test:v2`), ArgoCD automatically pulls the new image and deploys it to the K3s cluster.
4. The application is served via **NodePort** for external access, with ports opened for **443** (ArgoCD) and **80:30010** (application).

### Why GitLab Runner + Docker Outside of Docker? 🤔

Using the **Docker outside of Docker** (DooD) approach with **K3D** allows:
- Simpler debugging: All job containers run directly on the host VM.
- Efficiency: You avoid the overhead of running containers inside containers.
- Flexibility: The GitLab Runner inside the K3s cluster is fully capable of managing Docker jobs on the host.

### 📜 **Why Kustomize Patch?**:
We used **Kustomize** to patch the `install.yaml` for **ArgoCD** with an `--insecure` flag. This allows us to access the **ArgoCD** GUI without setting up HTTPS, simplifying access for development purposes.

### 🚀 **Deployment Process**:
1. Push changes to the `deployment.yaml` in the GitHub repository, such as updating the Docker image version (e.g., from `test:v1` to `test:v2`).
2. **ArgoCD** monitors the repository for changes and automatically deploys the new version when detected.
3. **GitLab Runner** builds the Docker image, pushes it to Docker Hub, and updates the deployment manifest in GitHub.
4. **ArgoCD** syncs the deployment and pulls the new image from Docker Hub to apply it to the Kubernetes cluster.

### Technologies Used 🛠️

- **K3s**: Lightweight Kubernetes distribution.
- **K3D**: K3s running inside Docker.
- **Vagrant**: Virtual machine management for development environments.
- **Terraform**: Infrastructure as Code for deploying Azure resources.
- **ArgoCD**: GitOps-based continuous delivery tool.
- **GitLab Runner**: CI/CD pipeline for Docker image builds.
- **Ansible**: Automation for installing tools and setting up environments.
- **Kustomize**: A patch management tool for Kubernetes configurations.

## 🛠️ **How to Run the Project**:

### Prerequisites

  -  **Terraform** 
  -  **Ansible**
  -  **VirtualBox**
  -  **Vagrant**

1. Clone the repository to your local machine.
2. Deploy the host VM:
   
   ```bash
    terraform apply
   ```
4. For Part 1-2, Run the following Command:
   
    ``` bash
    vagrant up
   ```
6. For Part 3 / Bonus, Deploy using ansible:
   
   ``` bash
    ansible-playbook playbook.yml -i Inventories/host.ini
   ```
