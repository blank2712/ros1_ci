
pipeline {
    agent any 
    stages {

        stage('Install jenkins') {
            steps {
                sh '''
                    // Cambiar al directorio de trabajo
                        // Comprobar si el directorio move_and_turn ya existe
                    if [ ! -f /home/user/run_jenkins.sh ]; then
                    wget -nc https://raw.githubusercontent.com/TheConstructAi/jenkins_demo/master/run_jenkins.sh && sleep 10s && bash run_jenkins.sh
                    fi
                    if [ ! -f /home/user/run_jenkins.sh ]; then
                    wget -nc https://raw.githubusercontent.com/TheConstructAi/jenkins_demo/master/run_jenkins.sh && sleep 10s && bash run_jenkins.sh
                    fi
                    wget -nc https://raw.githubusercontent.com/TheConstructAi/jenkins_demo/master/setup_ssh_git.sh && bash setup_ssh_git.sh
                '''
            }
        }

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
                sudo usermod -aG docker $USER
                newgrp docker
                cd ~/ros_jenkins_ws/src/ros1_ci 
                sudo docker build -t tortoisebot_test .
                '''
            }
        }
        stage('Create container') {
            steps {
                
                sh '''
                sudo usermod -aG docker $USER
                newgrp docker
                sudo docker run --rm --name tortoisebot_container -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix tortoisebot_test:latest &
                sleep 10
                sudo usermod -aG docker $USER
                newgrp docker
                sudo docker exec tortoisebot_container /bin/bash -c ". /opt/ros/noetic/setup.bash && . catkin_ws/devel/setup.bash && rostest tortoisebot_waypoints waypoints_test.test --reuse-master"

                '''

            }
        }
        stage('Done') {
            steps {
                sleep 2
                sh 'sudo docker rm -f tortoisebot_container'
                echo 'Pipeline completed'
            }
        }
    }
}