pipeline {
  agent any

  stages {
      stage('Build Artifact') {
            steps {
              bat "mvn clean package -DskipTests=true"
              archive 'target/*.jar'
            }
        }

      stage('Unit Tests - JUnit and Jacoco') {
        steps {
          bat "mvn test"
        }
        post {
          always {
            junit 'target/surefire-reports/*.xml'
            jacoco execPattern: 'target/jacoco.exec'
          }
        }
      }

      stage('Mutation Tests - PIT') {
        steps {
          bat "mvn org.pitest:pitest-maven:mutationCoverage"
        }
        post {
          always {
            pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
          }
        }
      }

      stage('SonarQube - SAST') {
          steps {
            withSonarQubeEnv('SonarQube') {
              bat "mvn clean verify sonar:sonar \
                  -Dsonar.projectKey=numeric-application \
                  -Dsonar.host.url=http://localhost:9000
            }
            timeout(time: 2, unit: 'MINUTES') {
              script {
                waitForQualityGate abortPipeline: true
              }
            }
          }
      }

      stage('Docker Build and Push') {
        steps {
          withDockerRegistry([credentialsId: "docker-hub", url: ""]) {
            bat 'docker build -t bferraz1990/numeric-app:v5 .'
            bat 'docker push bferraz1990/numeric-app:v5'
          }
        }
      }

      stage('Kubernetes Deployment - DEV') {
        steps {
          withKubeConfig([credentialsId: 'kubeconfig']) {              
            bat "kubectl apply -f k8s_deployment_service.yaml"
          }
        }
      }    
    }
}