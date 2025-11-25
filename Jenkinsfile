pipeline {
    agent any

    environment {
        DOCKERHUB_REPO = "student_db_app"
        IMAGE_TAG = "latest"
    }

    stages {

        stage("Load Secrets") {
            steps {
                withCredentials([
                    usernamePassword(credentialsId: 'dockerCredentials', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS'),
                    // string(credentialsId: 'ec2-public-ip', variable: 'EC2_IP'),
                    // sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'EC2_KEYFILE', usernameVariable: 'EC2_SSH_USER')
                ]) {
                    sh "echo 'Secrets loaded'"
                }
            }
        }

        stage("Clone Repo") {
            steps {
                git branch: 'main', url: 'https://github.com/DheerenGaud/RDS_APP.git'
            }
        }

        stage("Build Docker Image") {
            steps {
                sh """
                    docker images
                    docker build -t $DOCKERHUB_USER/${DOCKERHUB_REPO}:${IMAGE_TAG} .
                """
            }
        }

        stage("Login to Docker Hub") {
            steps {
                sh """
                    echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin
                """
            }
        }

        stage("Push Docker Image") {
            steps {
                sh "docker push $DOCKERHUB_USER/${DOCKERHUB_REPO}:${IMAGE_TAG}"
            }
        }

        stage("Deploy") {
            steps {
              sh """
                 docker pull $DOCKERHUB_USER/${DOCKERHUB_REPO}:${IMAGE_TAG}
                 docker stop student_db_app_container || true
                 docker rm student_db_app_container || true
                 docker run -d --name student_db_app_container -p 5000:5000 $DOCKERHUB_USER/${DOCKERHUB_REPO}:${IMAGE_TAG}
             """
          }
        }

    }
}
