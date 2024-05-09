
pipeline {
    agent any 
    stages('build') {
        stage('Create workspace and build') {
            steps {
                sh 'mkdir -p ~/catkin_ws/src'
                sh 'cd ~/catkin_ws'
                sh 'source /opt/ros/noetic/setup.bash'
                sh 'catkin_make'
            }
        }
        stage('echo "Will check if we need to clone or just pull"') {
            steps {
                sh 'cd /home/user/catkin_ws/src'
                script {
                    // Comprueba si el directorio move_and_turn ya existe
                    if (!fileExists('ros1_ci')) {
                        // Si no existe, clona el repositorio
                        sh 'git clone https://github.com/morg1207/ros1_ci.git'
                    } else {
                        // Si existe, cambia al directorio y realiza un pull para actualizar
                        dir('ros1_ci') {
                            sh 'git pull origin master'
                        }
                    }
                }
            }
        }
        stage('build docker image') {
            steps {
                sh '''
                cd ~/catkin_ws/src/ros1_ci 
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