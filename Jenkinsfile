
pipeline {
    agent any 
    stages {
        stage('Create workspace and build') {
            steps {
                sh 'mkdir -p ~/ros_jenkins_ws/src'
                sh '''
                cd ~/ros_jenkins_ws
                source /opt/ros/noetic/setup.bash
                catkin_make
                '''
            }
        }
        stage('Will check if we need to clone or just pull') {
            steps {
                script {
                    // Cambiar al directorio de trabajo
                    dir('/home/user/ros_jenkins_ws/src') {
                        echo 'Will check if we need to clone or just pull'
                        // Comprobar si el directorio move_and_turn ya existe
                        if (!fileExists('ros1_ci')) {
                            // Si no existe, clonar el repositorio
                            sh 'git clone https://github.com/morg1207/ros1_ci.git'
                        } else {
                            // Si existe, cambiar al directorio y realizar un pull para actualizar
                            dir('ros1_ci') {
                                sh 'git pull origin master'
                            }
                        }
                    }
                }
            }
        }
        stage(' install and build docker image') {
            steps {
                sh '''
                sudo apt-get update
                sudo apt-get install docker.io docker-compose -y
                sudo service docker start
                sudo usermod -aG docker jenkins
                newgrp docker
                cd ~/ros_jenkins_ws/src/ros1_ci 
                docker build -t tortoisebot_test .
                '''
            }
        }
        stage('Create container') {
            steps {
                sh 'docker run --rm tortoisebot_test:latest bash -c "rostest tortoisebot_waypoints waypoints_test.test" '

            }
        }
        stage('Done') {
            steps {
                sleep 5
                echo 'Pipeline completed'
            }
        }
    }
}