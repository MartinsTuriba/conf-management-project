pipeline {
    agent any
    
    environment {
        DOCKER_HOST = 'unix:///var/run/docker.sock'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Run Ansible Playbook') {
            steps {
                script {
                    // Run Ansible playbook
                    ansiblePlaybook(
                        playbook: 'ansible/playbook.yml',
                        inventory: 'ansible/inventory',
                        colorized: true
                    )
                }
            }
        }
        
        stage('Verify Deployment') {
            steps {
                script {
                    // Add verification steps
                    sh '''
                        docker ps | grep nginx-server
                        curl -s http://localhost:80
                    '''
                }
            }
        }
    }
    
    post {
        failure {
            echo 'Pipeline failed! Check the logs for details.'
        }
        success {
            echo 'Pipeline succeeded! NGINX container deployed successfully.'
        }
    }
}