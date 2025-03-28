pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = credentials('docker-hub-username')
        DOCKER_HUB_PASS = credentials('docker-hub-password')
        DOCKER_IMAGE = "your-dockerhub-username/hello-world-java"
        SONARQUBE_SERVER = "SonarQube"
        K8S_NAMESPACE = "default"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Arun-foxy/java-application.git'
            }
        }

        stage('Code Quality Analysis') {
            steps {
                script {
                    withSonarQubeEnv('SonarQube') {
                        sh 'mvn sonar:sonar'
                    }
                }
            }
        }

        stage('Build and Package') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                        docker login -u $DOCKER_HUB_USER -p $DOCKER_HUB_PASS
                        docker build -t $DOCKER_IMAGE:${BUILD_NUMBER} .
                        docker tag $DOCKER_IMAGE:${BUILD_NUMBER} $DOCKER_IMAGE:latest
                        docker push $DOCKER_IMAGE:${BUILD_NUMBER}
                        docker push $DOCKER_IMAGE:latest
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh """
                        kubectl apply -f k8s/deployment.yaml -n $K8S_NAMESPACE
                        kubectl apply -f k8s/service.yaml -n $K8S_NAMESPACE
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Deployment successful!"
        }
        failure {
            echo "Deployment failed!"
        }
    }
}
