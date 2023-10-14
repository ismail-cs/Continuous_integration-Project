 def COLOR_MAP = [
	'SUCCESS': 'good',
	'FAILURE': 'danger',
 ]
 
pipeline {
    agent any

    stages{
    
        stage('Fetch code') {
          steps{
              git branch: 'main', url:'https://github.com/ismail-cs/Continuous_integration-Project.git'
          }  
        }

        stage('Build') {
            steps {
                sh 'mvn clean install -DskipTests'
            }
            post {
                success {
                    echo "Now Archiving."
                    archiveArtifacts artifacts: '**/*.war'
                }
            }
        }
        stage('Test'){
            steps {
                sh 'mvn test'
            }

        }

        stage('Checkstyle Analysis'){
            steps {
                sh 'mvn checkstyle:checkstyle'
            }
        }

        stage('Sonar Analysis') {
            environment {
                scannerHome = tool 'sonar4.7'
            }
            steps {
               withSonarQubeEnv('sonar') {
                   sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=Project_Alpha \
                   -Dsonar.projectName=Project_Alpha \
                   -Dsonar.projectVersion=1.0 \
                   -Dsonar.sources=src/ \
                   -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                   -Dsonar.junit.reportsPath=target/surefire-reports/ \
                   -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                   -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
              }
            }
        }
        
        stage("Quality Gate") {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    // Parameter indicates whether to set pipeline to UNSTABLE if Quality Gate fails
                    // true = set pipeline to UNSTABLE, false = don't
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        
        
        
        stage("Upload Artifact") {
        	steps {
        		
        		nexusArtifactUploader(
				nexusVersion: 'nexus3',
				protocol: 'http',
				nexusUrl: '172.31.61.246:8081',
				groupId: 'QA',
				version: "${env.BUILD_ID}-${env.BUILD_TIMESTAMP}",
				repository: 'Project_Alpha',
				credentialsId: 'nexuslogin',
					artifacts: [
						[artifactId: 'application',
						 classifier: '',
						 file: 'target/project_alpha-v2.war',
						 type: 'war']
					]
			 	)	
        	}
        }
        
    }
    
    post {
		always {
			echo 'Slack Notification.'
			slackSend channel: 'team-a',
				color: COLOR_MAP[currentBuild.currentResult],
				message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL}"
		}
	}
}
