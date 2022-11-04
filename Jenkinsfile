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
                  -Dsonar.host.url=http://localhost:9000"
            }
            timeout(time: 2, unit: 'MINUTES') {
              script {
                waitForQualityGate abortPipeline: true
              }
            }
          }
      }

      // stage('Vulnerability Scan - Docker ') {
      //   steps {
      //     bat "mvn dependency-check:check"
      //   }
      // }

      stage('Vulnerability Scan - Docker ') {
        steps {
          parallel (
            "Dependency Scan": {
              bat "mvn dependency-check:check"
            },
            "Trivy Scan": {
              bat "trivy-docker-image-scan.bat"
            },
            "OPA Conftest": {
              bat 'docker run --rm -v D:\\Estudos\\DevSecOps\\Capitulo2\\kubernetes-devops-security:/project openpolicyagent/conftest test --policy opa-docker-security.rego Dockerfile'
            }
          )          
        }
      }

      stage('Docker Build and Push') {
        steps {
          withDockerRegistry([credentialsId: "docker-hub", url: ""]) {
            bat 'docker build -t bferraz1990/numeric-app:v6 .'
            bat 'docker push bferraz1990/numeric-app:v6'
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

    post {
      always {
        junit 'target/surefire-reports/*.xml'
        jacoco execPattern: 'target/jacoco.exec'
        //pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
        dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
      }

      // success {

      // }

      // failure {

      // }
    }
}