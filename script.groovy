pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "darin04/mavenwebapp"
        DOCKER_TAG = "latest"
        EKS_CLUSTER_NAME = "darin-cluster"
        KUBE_CONFIG = "/var/lib/jenkins/.kube/config"
    }

    stages {
        stage('Checkout Code Only') {
            steps {
                git branch: 'master', url: 'https://github.com/suffixscope/maven-web-app.git'
                sh 'rm -f k8s-deploy.yml' 
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image (Using Local Dockerfile)') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE:$DOCKER_TAG -f /var/lib/jenkins/workspace/k8s/Docker/Dockerfile .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withDockerRegistry([credentialsId: 'docker-hub-credentials', url: '']) {
                    sh 'docker push $DOCKER_IMAGE:$DOCKER_TAG'
                }
            }
        }

        stage('Deploy to Kubernetes (Using Local Deployment YAML)') {
            steps {
                sh "kubectl apply -f /var/lib/jenkins/workspace/k8s/deployment.yaml --kubeconfig=$KUBE_CONFIG"
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
