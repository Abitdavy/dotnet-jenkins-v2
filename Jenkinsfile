pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'dotnet-jenkins-v2-image'
        GITHUB_REPO = 'https://github.com/Abitdavy/dotnet-jenkins-v2.git'
        GITHUB_TOKEN = credentials('github-secret-token')
    }
    stages {
        stage('Checkout') {
            steps {
                script {
                    // Ensure the workspace is clean
                    sh 'rm -rf * || true'
                    
                    // Clone the repository securely
                    withCredentials([string(credentialsId: 'github-secret-token', variable: 'GITHUB_TOKEN')]) {
                        sh '''
                            git clone https://${GITHUB_TOKEN}@github.com/Abitdavy/dotnet-jenkins-v2.git .
                        '''
                    }
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    docker.build("${env.DOCKER_IMAGE}:${env.BUILD_NUMBER}", ".")
                }
            }
        }
        stage('Run Docker Container') {
            steps {
                script {
                    // Run the Docker container
                    docker.image("${env.DOCKER_IMAGE}:${env.BUILD_NUMBER}").run('-d -p 8081:80')
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}