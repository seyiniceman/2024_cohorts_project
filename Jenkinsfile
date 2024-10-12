pipeline {
    agent any
    
    tools {
        maven 'Maven'   // Define Maven tool in Jenkins (or Gradle if needed)
    }

    stages {

        // Stage 1: Testing Stage
        stage('Testing') {
            steps {
                sh 'cd SampleWebApp mvn test'
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
                withSonarQubeEnv('sonar_server') {  // This is the name of your SonarQube server in Jenkins
                    sh 'mvn -f SampleWebApp/pom.xml sonar:sonar'
                }
            }
        }

        // Stage 4: Push to Nexus Artifactory
        stage('Upload to Nexus') {
            steps {
                echo 'Uploading build artifacts to Nexus...'
                script {

                    nexusArtifactUploader artifacts: [[artifactId: 'SampleWebApp', classifier: '', file: 'SampleWebApp/target/SampleWebApp.war', type: 'war']], credentialsId: 'Nexus_ID', groupId: 'SampleWebApp', nexusUrl: '34.247.191.254:8081', nexusVersion: 'nexus2', protocol: 'http', repository: 'maven-snapshots', version: '1.0-SNAPSHOTS'
                }
            }
        }

        // Stage 5: Deploy to Tomcat Webserver
        stage('Deploy to Tomcat') {
            steps {
                deploy adapters: [tomcat9(credentialsId: 'Tomcat_ID', path: '', url: 'http://3.248.193.120:8080')], contextPath: 'webapp', war: '**/*.war'
                }
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
