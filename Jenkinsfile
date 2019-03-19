pipeline {
    agent any
    options {
        ansiColor('xterm')
    }
    environment {
        WORK_DIR  = "${env.WORKSPACE}"
    }
    stages {
        stage('Checkout from git') {
          // This stage checks out the appropriate source code from github code
          steps {

            dir ("${env.WORK_DIR}"){
              checkout scm: [
                $class: 'GitSCM', userRemoteConfigs: [
                  [
                    url: 'https://github.com/MANOHAR452/node-mongodb.git',
                    credentialsId: 'git-creds',
                    changelog: false,
                  ]
                ],
                branches: [
                  [
                    name: "refs/heads/master"
                  ]
                ],
                poll: false
              ]
            }
          }
        }
        stage('docker build') {
            steps {
                dir ("${env.WORK_DIR}"){
                    script {
                        sh "docker build -f Dockerfile.dev -t manohar4524/node-mongodb:latest ."
                    }
                }
            }
        }        
        stage('docker push') {
            steps {
                dir ("${env.WORK_DIR}"){
                    withCredentials([string(credentialsId: 'dockerHub-creds', variable: 'dockerHubpwd')]) {
                      script {
                        sh "docker login -u manohar4524 -p ${dockerHubpwd}"
                      }
                    } 
                    script {
                        sh "docker push manohar4524/node-mongodb:latest"
                    }
                }
            }
        }
        stage('docker deploy') {
            steps {
                dir ("${env.WORK_DIR}"){
                    //script {
                    //    sh 'sed -i "s/node-.*/node-mongodb:${BUILD_NUMBER}/g" docker-compose.yml'
                    //}
                    sshagent(['node-app-creds']) {
                        script {
                           sh 'ssh -o StrictHostKeyChecking=no -l marranagu 10.168.0.2 "bash -s" < deploy.sh'
                        }
                    }
                } 
            }
        }        

    }
    // Post describes the steps to take when the pipeline finishes
    post {
        always {
            echo "Clearing workspace"
            deleteDir() // Clean up the local workspace so we don't leave behind a mess, or sensitive files
        }
    }
}
