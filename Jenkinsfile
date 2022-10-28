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

        stage('Docker Build and Push') {
          steps {
            withDockerRegistry([credentialsId: "docker-hub", url: ""]) {
              bat 'printenv'
              bat 'docker build -t bferraz1990/numeric-app:""$GIT_COMMIT"" .'
              bat 'docker push bferraz1990/numeric-app:""$GIT_COMMIT""'
            }
          }
        }

        stage('Kubernetes Deployment - DEV') {
          steps {
            withKubeConfig([credentialsId: 'kubeconfig']) {
              bat "sed -i 's#replace#bferraz1990/numeric-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
              bat "kubectl apply -f k8s_deployment_service.yaml"
            }
          }
        }    
    }
}