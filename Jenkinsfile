pipeline {
    agent any
    
    environment {
        DOCKER_HOST = 'unix:///var/run/docker.sock'
        PATH = "$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
    }
    
    stages {
        stage('Verify Environment') {
            steps {
                script {
                    sh '''
                        echo "Python version:"
                        python3 --version
                        echo "Ansible version:"
                        ansible --version
                        echo "Docker status:"
                        docker ps
                    '''
                }
            }
        }
        
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Run Ansible Playbook') {
            steps {
                script {
                    try {
                        ansiblePlaybook(
                            playbook: 'ansible/playbook.yml',
                            inventory: 'ansible/inventory',
                            colorized: true,
                            extras: '--verbose'
                        )
                    } catch (Exception e) {
                        echo "Ansible playbook failed: ${e.getMessage()}"
                        echo "Full stack trace: ${e.toString()}"
                        throw e
                    }
                }
            }
        }
        
        stage('Verify Deployment') {
            steps {
                script {
                    sh '''
                        echo "Checking NGINX container:"
                        docker ps | grep nginx-server
                        echo "Testing NGINX response:"
                        curl -s http://localhost:80 || true
                    '''
                }
            }
        }
    }
    
    post {
        always {
            echo 'Printing debug information...'
            sh 'docker ps -a'
            sh 'ls -la /var/run/docker.sock || true'
        }
        failure {
            echo 'Pipeline failed! Collecting debug information...'
            sh '''
                echo "Docker info:"
                docker info || true
                echo "System info:"
                uname -a
                echo "Directory structure:"
                ls -R ansible/
            '''
        }
    }
}