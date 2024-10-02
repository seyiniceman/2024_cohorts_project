pipeline {
    agent any

    stages {
        stage('Test') {
            steps {
                sh 'cd SampleWebApp mvn test'
            }
        }
        stage('Build & Complie') {
            steps {
                sh 'cd SampleWebApp && mvn clean package'
            }
        }
        
        stage('Deploy to Tomcat Web Server') {
            steps {
                deploy adapters: [tomcat9(credentialsId: '49eb3256-3189-4c51-8882-1cd26645ef6e', path: '', url: 'http://54.247.206.56:8080')], contextPath: 'app', war: '**/*.war'
            }
        }
    }
}
