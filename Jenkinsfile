pipeline {
    agent any

    environment {
        DOCKERHUB_REPO = "student_db_app"
        IMAGE_TAG = "latest"
    }

    stages {

        stage("Clone Repo") {
            steps {
                git branch: 'main', url: 'https://github.com/DheerenGaud/RDS_APP.git'
            }
        }

        stage("Build & Push Docker Image") {
            steps {
                withCredentials([
                    usernamePassword(credentialsId: 'dockerCredentials', 
                                     usernameVariable: 'DOCKERHUB_USER', 
                                     passwordVariable: 'DOCKERHUB_PASS')
                ]) {

                    sh """
                        echo ">>> Logging in to Docker Hub"
                        echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin

                        echo ">>> Building Image"
                        docker build -t $DOCKERHUB_USER/${DOCKERHUB_REPO}:${IMAGE_TAG} .

                        echo ">>> Pushing Image"
                        docker push $DOCKERHUB_USER/${DOCKERHUB_REPO}:${IMAGE_TAG}
                    """
                }
            }
        }

        stage("Deploy") {
            steps {
                withCredentials([
                    usernamePassword(credentialsId: 'dockerCredentials', 
                                     usernameVariable: 'DOCKERHUB_USER', 
                                     passwordVariable: 'DOCKERHUB_PASS')
                ]) {

                    sh """
                        docker pull $DOCKERHUB_USER/${DOCKERHUB_REPO}:${IMAGE_TAG}
                        docker stop ebs_container || true
                        docker rm ebs_container || true
                        docker run -d --name ebs_container -p 5000:5000 $DOCKERHUB_USER/${DOCKERHUB_REPO}:${IMAGE_TAG}
                    """
                }
            }
        }
    }
}
