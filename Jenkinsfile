pipeline {
    agent any
    
    tools {
        maven 'Maven'   // Define Maven tool in Jenkins (or Gradle if needed)
    }

    stages {

        // Stage 1: Testing Stage
        stage('Testing') {
            steps {
                sh 'cd SampleWebApp && mvn test'  // Ensure commands are properly chained with &&
            }
        }

        // Stage 2: Build and Compile
        stage('Build & Compile') {
            steps {
                sh 'cd SampleWebApp && mvn clean install'  // Consistent use of && for chaining
            }
        }

        // Stage 3: Quality Code and Scan Analysis
        stage('SonarQube Analysis') {
            steps {
                echo 'Performing SonarQube code analysis...'
                withSonarQubeEnv('sonar_server') {  // Ensure 'sonar_server' matches the SonarQube configuration in Jenkins
                    sh 'mvn -f SampleWebApp/pom.xml sonar:sonar'
                }
            }
        }

        // Stage 4: Push to Nexus Artifactory
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
                    nexusUrl: '34.247.191.254:8081', 
                    nexusVersion: 'nexus2', 
                    protocol: 'http', 
                    repository: 'maven-snapshots', 
                    version: '1.0-SNAPSHOT'
