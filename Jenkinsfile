pipeline {
    agent any
    
    stages {

        // Stage 1: Testing Stage
        stage('Testing') {
            steps {
                sh 'cd SampleWebApp && mvn test'  // Fixed command chaining
            }
        }

        // Stage 2: Build and Compile
        stage('Build & Compile') {
            steps {
                sh 'cd SampleWebApp && mvn clean install'
            }
        }

        // Stage 3: Quality Code and Scan Analysis
        stage('SonarQube Analysis') {
            steps {
                echo 'Performing SonarQube code analysis...'
                withSonarQubeEnv('sonar-server') {  // This is the name of your SonarQube server in Jenkins
                    sh 'mvn -f SampleWebApp/pom.xml sonar:sonar'
                }
            }
        }

        // Stage 4: Push to Nexus Artifactory (Updated)
        stage('Upload to Nexus') {
            steps {
                echo 'Uploading build artifacts to Nexus...'
                script {
                    nexusArtifactUploader artifacts: [[
                        artifactId: 'SampleWebApp', 
                        classifier: '', 
                        file: 'SampleWebApp/target/SampleWebApp.war', 
                        type: 'war'
                    ]], 
                    credentialsId: 'Nexus_ID', 
                    groupId: 'SampleWebApp', 
                    nexusUrl: '54.229.101.96:8081',  // Updated Nexus URL
                    nexusVersion: 'nexus3',           // Updated Nexus version
                    protocol: 'http', 
                    repository: 'maven-snapshots', 
                    version: '1.0-SNAPSHOT'
                }
            }
        }

        // Stage 5: Deploy to Tomcat Webserver (Updated)
        stage('Deploy to Tomcat') {
            steps {
                deploy adapters: [tomcat9(
                    credentialsId: 'Tomcat_ID', 
                    path: '', 
                    url: 'http://3.251.79.244:8080'  // Updated Tomcat URL
                )], 
                contextPath: 'webapp', 
                war: '**/*.war'
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs()  // Clean up workspace after the pipeline is complete
        }
    }
}
