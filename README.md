# 💻 **Inception of Things - Bonus Stage** 🚀

![meme](https://github.com/chahid001/42Inception-of-Things/blob/main/assets/meme.webp)



This project demonstrates how to build a complete CI/CD pipeline with **GitOps**, **ArgoCD**, **K3D**, and **GitLab Runner** using the **Docker outside of Docker** method.
## 🔧 **Technologies Used**:
- **Terraform** for deploying the base infrastructure in Azure
- **Vagrant** to manage virtual machines inside the Azure VM
- **K3S** as a lightweight Kubernetes distribution
- **K3D** (K3S in Docker) for the lightweight Kubernetes clusters
- **ArgoCD** to manage the GitOps process, monitoring changes in GitHub and automatically deploying updates
- **GitLab Runner** for CI/CD tasks, configured with Docker outside of Docker
- **Docker** for containerizing applications
- **Kustomize** for patching ArgoCD YAML files
## 🏗️ **Architecture Overview**:
The project has three main parts, with the focus on the **Bonus** section, where we implement **GitOps**.
### Bonus Architecture:
- We have **K3D** running **K3S** inside a Docker container on the host VM.
- **ArgoCD** is installed to manage the GitOps process, pulling deployment manifests from GitHub.
- **GitLab Runner** is installed as a container in the **K3D** cluster, but using the Docker volume technique to run jobs on the host's Docker engine.
- **Kustomize** is used to patch the `install.yaml` for ArgoCD to allow insecure access to the GUI without HTTPS.
### 📁 **GitLab Runner Setup with Docker Outside of Docker**:
In this setup, **GitLab Runner** is deployed inside **K3D** but runs jobs in the host VM's Docker engine using **Docker outside of Docker**. Here's how it works:
1. The **Docker socket** is mounted between the host and the GitLab Runner container, allowing the runner to control Docker on the host VM.
2. The **runner configuration** is accessible from the host, making it easier to debug and manage pipelines.
3. When a pipeline runs, it builds Docker images on the host VM and pushes them to Docker Hub.
### 🚀 **Deployment Process**:
1. Push changes to the `deployment.yaml` in the GitHub repository, such as updating the Docker image version (e.g., from `test:v1` to `test:v2`).
2. **ArgoCD** monitors the repository for changes and automatically deploys the new version when detected.
3. **GitLab Runner** builds the Docker image, pushes it to Docker Hub, and updates the deployment manifest in GitHub.
4. **ArgoCD** syncs the deployment and pulls the new image from Docker Hub to apply it to the Kubernetes cluster.
### 📜 **Why Kustomize Patch?**:
We used **Kustomize** to patch the `install.yaml` for **ArgoCD** with an `--insecure` flag. This allows us to access the **ArgoCD** GUI without setting up HTTPS, simplifying access for development purposes.
## 🌐 **GitOps Explained**:
**GitOps** is the practice of using Git as the single source of truth for declarative infrastructure and applications. In this project, we use **ArgoCD** to continuously monitor our GitHub repository for changes to the Kubernetes deployment manifests and automatically apply those changes to our **K3D** cluster.
## 🛠️ **How to Run the Project**:
1. Clone the repository to your local machine.
2. Follow the instructions to set up **K3D**, **ArgoCD**, and **GitLab Runner** using the provided **Ansible** playbooks.
3. Push changes to the `deployment.yaml` file in the GitHub repository and watch **ArgoCD** deploy the new version automatically.

