pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'dotnet-jenkins-v2-image'
        GITHUB_REPO = 'https://github.com/Abitdavy/dotnet-jenkins-v2.git'
        GITHUB_TOKEN = credentials('github-secret-token')
    }
    stages {
        stage('Clean Workspace') {
            steps {
                script {
                    // Ensure the workspace is clean
                    deleteDir()
                }
            }
        }
        stage('Checkout') {
            steps {
                script {
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
        stage('Stop Existing Container') {
                    steps {
                        script {
                            // Stop any running containers using port 8081
                            def runningContainers = sh(script: "docker ps --filter 'publish=8081' -q", returnStdout: true).trim()
                            if (runningContainers) {
                                sh "docker stop ${runningContainers}"
                            }
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