pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'yourdockerhubusername/java-rest-api:latest'
        EC2_HOST = 'ec2-user@your-ec2-public-ip'
        SSH_KEY = 'your-ssh-key-id'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/yourgithubusername/your-repo.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t $DOCKER_IMAGE ."
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    docker push $DOCKER_IMAGE
                    '''
                }
            }
        }

        stage('Deploy to AWS EC2') {
            steps {
                sshagent (credentials: ["$SSH_KEY"]) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no $EC2_HOST << EOF
                    docker pull $DOCKER_IMAGE
                    docker stop app || true
                    docker rm app || true
                    docker run -d --name app -p 8080:8080 $DOCKER_IMAGE
                    EOF
                    '''
                }
            }
        }
    }
}
