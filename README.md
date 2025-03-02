Project Report: Automated CI/CD Pipeline on AWS using Jenkins, Docker, and Kubernetes
Objective
The goal of this project is to set up an automated CI/CD pipeline that retrieves code from GitHub, builds a Docker image, pushes it to a container registry, and deploys it on an AWS-hosted Kubernetes cluster.

Tools & Technologies Used
Cloud Provider: AWS (EC2, EKS)
CI/CD Tool: Jenkins
Infrastructure as Code: Terraform
Containerization: Docker
Container Orchestration: Kubernetes (EKS)
Repository Management: GitHub
Monitoring: AWS CloudWatch, Prometheus & Grafana
Project Workflow
Infrastructure Provisioning using Terraform

Created an AWS EC2 instance for Jenkins and EKS for Kubernetes.
Installed required tools like Docker, Kubernetes CLI (kubectl), Helm, and AWS CLI.
Setting up Jenkins for CI/CD

Installed Jenkins on EC2 and configured required plugins.
Created a Jenkins pipeline to automate the build and deployment process.
CI/CD Pipeline Flow

Step 1: Jenkins pulls the latest code from GitHub.
Step 2: Maven is used to build the application and generate a .war file.
Step 3: Jenkins builds a Docker image using the Dockerfile and tags it.
Step 4: The image is pushed to Docker Hub.
Step 5: Kubernetes deployment is triggered using kubectl apply -f deployment.yaml.
Kubernetes Deployment

Created a Kubernetes deployment using a YAML file.
Configured a service (LoadBalancer) to expose the application.
Ensured rolling updates and pod health checks.
Jenkins Pipeline Code
groovy
Copy
Edit
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "darin04/mavenwebapp"
        DOCKER_TAG = "latest"
        EKS_CLUSTER_NAME = "darin-cluster"
        KUBE_CONFIG = "/var/lib/jenkins/.kube/config"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'master', url: 'https://github.com/suffixscope/maven-web-app.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE:$DOCKER_TAG -f Dockerfile .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withDockerRegistry([credentialsId: 'docker-hub-credentials', url: '']) {
                    sh 'docker push $DOCKER_IMAGE:$DOCKER_TAG'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh "kubectl apply -f deployment.yaml --kubeconfig=$KUBE_CONFIG"
            }
        }
    }

    post {
        success {
            echo "Deployment Successful!"
        }
        failure {
            echo "Deployment Failed!"
        }
    }
}
Deployment Configuration Files
Dockerfile
dockerfile
Copy
Edit
FROM tomcat:latest
MAINTAINER Vinod <vinod@scopeindia.org>
EXPOSE 8080
COPY target/maven-web-app.war /usr/local/tomcat/webapps/maven-web-app.war
Kubernetes Deployment YAML
yaml
Copy
Edit
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mavenwebappdeployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: mavenwebapp
  template:
    metadata:
      labels:
        app: mavenwebapp
    spec:
      containers:
      - name: mavenwebappcontainer
        image: darin04/mavenwebapp:latest
        ports:
        - containerPort: 8080
        imagePullPolicy: Always
---
apiVersion: v1
kind: Service
metadata:
  name: mavenwebappsvc
spec:
  selector:
    app: mavenwebapp
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080
  type: LoadBalancer
Pipeline Execution & Deployment Behavior
Scenario 1: Code Change in Git
When a change is committed to Git, Jenkins automatically triggers the pipeline.
The pipeline builds a new Docker image, tags it, and pushes it to Docker Hub.
Kubernetes pulls the new image and replaces old pods with new ones.
Scenario 2: No Code Change, Pipeline Rerun
If the pipeline is manually triggered without code changes, Jenkins will rebuild the image and push it to Docker Hub.
If the image digest remains the same, Kubernetes will not replace the existing pods.
If the image digest changes, Kubernetes will trigger rolling updates.
Conclusion
This project successfully demonstrates an end-to-end CI/CD pipeline using Jenkins, Docker, and Kubernetes on AWS. By automating the deployment process, this setup ensures faster releases, consistency in deployments, and improved reliability.

This setup can be extended further by integrating:

Monitoring (Prometheus & Grafana)
Alerting (AWS CloudWatch)
Blue-Green Deployment or Canary Deployment for better release management.
