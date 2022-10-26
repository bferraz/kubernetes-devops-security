pipeline {
  agent any

  stages {
      stage('Build Artifact') {
            steps {
              sh "mvn clean package -DskipTests=true"
              archive 'target/*.jar'
            }
        }

        stage('Unit Tests - JUnit and Jacoco') {
          steps {
            sh "mvn test"
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
              sh 'printenv'
              sh 'docker login -u bferraz1990 -p b2r4u6n8o@1'
              sh 'docker build -t bferraz1990/numeric-app:""$GIT_COMMIT"" .'
              sh 'docker push bferraz1990/numeric-app:""$GIT_COMMIT""'
          }
        }    
    }
}