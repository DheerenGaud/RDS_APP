pipeline {
    agent any

    environment {
        DOCKERHUB_REPO = "student_db_app"
        IMAGE_TAG = "latest"
        PUBLIC_IP = "3.111.35.126"
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
                        echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
                        docker build -t $DOCKERHUB_USER/$DOCKERHUB_REPO:$IMAGE_TAG .
                        docker push $DOCKERHUB_USER/$DOCKERHUB_REPO:$IMAGE_TAG
                    """
                }
            }
        }

        stage("Deploy on EC2") {
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'ec2_ssh_key',
                        keyFileVariable: 'EC2_KEY',
                        usernameVariable: 'EC2_USER'
                    ),
                    string(credentialsId: 'DB_HOST', variable: 'DB_HOST'),
                    string(credentialsId: 'DB_USER', variable: 'DB_USER'),
                    string(credentialsId: 'DB_PASS', variable: 'DB_PASS')
                ]) {

                    sh """
                        ssh -o StrictHostKeyChecking=no -i $EC2_KEY $EC2_USER@${PUBLIC_IP} '
                            echo ">>> Pulling latest image";
                            docker pull dheerengaud/student_db_app:latest;

                            echo ">>> Stopping old container";
                            docker stop ebs_container || true;
                            docker rm ebs_container || true;

                            echo ">>> Starting new container";
                            docker run -d \
                                --name ebs_container \
                                -p 5000:5000 \
                                -e DB_HOST=$DB_HOST \
                                -e DB_USER=$DB_USER \
                                -e DB_PASSWORD=$DB_PASS \
                                -e DB_NAME=studentdb \
                                dheerengaud/student_db_app:latest;
                        '
                    """
                }
            }
        }
    }
}
