pipeline {
  agent any
   stages {
    stage ('Build') {
      steps {
        sh '''#!/bin/bash
        python3 -m venv test3
        source test3/bin/activate
        pip install pip --upgrade
        pip install -r requirements.txt
        export FLASK_APP=application
        flask run &
        '''
     }
   }
    stage ('test') {
      steps {
        sh '''#!/bin/bash
        source test3/bin/activate
        py.test --verbose --junit-xml test-reports/results.xml
        ''' 
      }
    
      post{
        always {
          junit 'test-reports/results.xml'
        }
       
      }
    } 
     stage ('Create image')
      {
        agent {label "DockerDeploy"}
       steps {
         sh '''
         docker build --tag url-shortner:v1 .
         sudo docker tag url-shortner:v1 michaelblasse/url-shortner:latest
         sudo docker push michaelblasse/urlshortner:latest
         '''
       }
     }
          stage ('Deploy to ecs')
      {
        agent {label "TerraformDeploy"}
       steps {
        withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'),string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')])
        {dir("initTerraform"){
          sh '''
         terraform init
         terraform plan -out plan.tfplan -var="aws_access_key=$aws_access_key" -var="aws_secret_key=$aws_secret_key
         terraform apply plan.tfplan
         '''
        }}
       }
     }
     stage ('Email_Confirmation'){
       steps{
         emailext body: 'Build confirmed',
                  subject: 'Build Confirm',
                  to: 'mblasse@hotmail.com',
                  attachLog: true
       }
     }
  }
}
