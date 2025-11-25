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
                    usernamePassword(
                        credentialsId: 'dockerCredentials',
                        usernameVariable: 'DOCKERHUB_USER',
                        passwordVariable: 'DOCKERHUB_PASS'
                    )
                ]) {

                    sh """
                        echo ">>> Logging into Docker Hub"
                        echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin

                        echo ">>> Building Docker Image"
                        docker build -t "$DOCKERHUB_USER/${DOCKERHUB_REPO}:${IMAGE_TAG}" .

                        echo ">>> Pushing Image to Docker Hub"
                        docker push "$DOCKERHUB_USER/${DOCKERHUB_REPO}:${IMAGE_TAG}"
                    """
                }
            }
        }

        stage("Deploy") {
            steps {

                withCredentials([
                    string(credentialsId: 'DB_HOST', variable: 'DB_HOST'),
                    string(credentialsId: 'DB_USER', variable: 'DB_USER'),
                    string(credentialsId: 'DB_PASS', variable: 'DB_PASS')
                ]) {

                    sh """
                        echo ">>> Pulling latest image"
                        docker pull dheerengaud/${DOCKERHUB_REPO}:${IMAGE_TAG}

                        echo ">>> Stopping old container"
                        docker stop ebs_container || true
                        docker rm ebs_container || true

                        echo ">>> DEBUG ENV VALUES (LENGTH ONLY)"
                        echo "DB_HOST length: \${#DB_HOST}"
                        echo "DB_USER length: \${#DB_USER}"
                        echo "DB_PASS length: \${#DB_PASS}"

                        echo ">>> Starting new container"
                        docker run -d \
                            --name ebs_container \
                            -p 5000:5000 \
                            -e DB_HOST=$DB_HOST \
                            -e DB_USER=$DB_USER \
                            -e DB_PASS=$DB_PASS \
                            -e DB_NAME=studentdb \
                            dheerengaud/${DOCKERHUB_REPO}:${IMAGE_TAG}
                    """
                }
            }
        }
    }
}
