pipeline {
    agent any
    tools {
        nodejs "NodeJS 18" // NodeJS 설치 이름
    }
    environment {
        // 글로벌 스코프에 변수 선언
        DOCKER_IMAGE = "team2-registry.ci.lion.nyhhs.com:8443/harbor/test/team2-backend:${env.BUILD_NUMBER}"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: 'github_access_token',
                    url: 'https://github.com/Cloud-Engineering1/team2BackendRepo.git'
            }
        }
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }
        stage('Test') {
            steps {
                sh 'npm test'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // DOCKER_IMAGE 변수는 이미 글로벌 스코프에 선언되어 있음
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                withDockerRegistry([credentialsId: 'harbor_access_credentials', url: 'https://team2-registry.ci.lion.nyhhs.com:8443']) {
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // DOCKER_IMAGE 변수 사용
                    sh "kubectl set image deployment/team2-backend team2-backend=${DOCKER_IMAGE}"
                }
            }
        }
    }
    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed. Please check the logs.'
        }
    }
}
