pipeline {
    agent {
        kubernetes {
            defaultContainer 'jnlp'
            yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    component: ci
spec:
  containers:
  - name: dotnetsdk
    image: mcr.microsoft.com/dotnet/sdk:7.0
    command:
    - cat
    tty: true
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command:
    - /busybox/cat
    tty: true
    volumeMounts:
      - name: docker-config
        mountPath: /kaniko/.docker
  volumes:
  - name: docker-config
    projected:
      sources:
      - secret:
          name: regcred
          items:
            - key: .dockerconfigjson
              path: config.json
"""
        }
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout scm
                }
            }
        }

        stage('Build Dotnet') {
            steps {
                container('dotnetsdk') {
                    dir('db_calculation_api') {
                        sh 'dotnet restore'
                        sh 'dotnet build -c Release'
                    }
                }
            }
        }

        stage('Build Docker Image with Kaniko') {
            steps {
                container('kaniko') {
                    dir('db_calculation_api') {
                        sh '''
                        /kaniko/executor --dockerfile=Dockerfile --context . \
                        --destination=registry-url/db_calculation_api:latest
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Build and Docker image creation successful!'
        }
        failure {
            echo 'Build failed.'
        }
    }
}