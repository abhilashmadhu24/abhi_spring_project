pipeline {
    agent any
    tools {
        maven "Maven"
          }
    stages {
        stage("Clone from repo") {
            steps {
           git branch: 'main', credentialsId: 'xxxxxxxxxxxxxxxx', url: 'http://abhxxxxxxxxxxxxxxx/xxx.git'
           }
        }   
        stage("Creating jar") {
            steps {
                script {
                    sh "./mvnw package"
                }
            }
        }
        stage("Building Docker Image") {
            steps {
                script {
                    sh '''
                        docker build -t abhi_project:$BUILD_NUMBER .
                       '''
                }
            }
        }
        stage("Pusing Docker image to Nexus repo") {
            steps {
            withDockerRegistry(credentialsId: 'e22bf589-46a8-4xxxxxxxxxxxx', url: 'http://localhost:8091') {
                script {
                    sh '''
                    sudo docker tag abhi_project:$BUILD_NUMBER localhost:8091/repository/abhi_repo/abhi_project:$BUILD_NUMBER
                    sudo docker push localhost:8091/repository/abhi_repo/abhi_project:$BUILD_NUMBER
                    '''
                }
            }
                script {
                    sh '''
                        echo TASK COMPLETED!!!!!
                       '''
                }
            }    
        }
    }
}
