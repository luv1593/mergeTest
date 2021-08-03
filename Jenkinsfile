//Author Lucas Verrilli July 15, 2021 Email: lucas.verrilli@northwestern.edu
//This program will check the status of the repos in a list in order to tell the user
//if they are all up to date with the latest tag.


pipeline {
  agent any
  parameters{

      //ADD doc for adding new repo

      //pipeline parameters (may need to be dynamic)
      booleanParam(defaultValue: true, name: 'All')
      booleanParam(defaultValue: false, name: 'SysDevMoneyCat')
      booleanParam(defaultValue: false, name: 'SysDevFRS')
      booleanParam(defaultValue: false, name: 'SysDevURG')
      booleanParam(defaultValue: false, name: 'ecatsapi')
      booleanParam(defaultValue: false, name: 'ecatsui', description: "All will run all repositories through the program. You can also uncheck All to select specific the repositories that you want to run. ")

      //choice
      }

  //This triggers the cron pattern for the program
  triggers {
          /*
              Everyday at 8:30am
                30 8 * * *

              Never
               1 23 31 2 *

              Every 5 minutes
               5 * * * *

              Every 30 minutes
               30 * * * *
            */
        //env.param
        cron('30 8 * * * ')
    }

  //webhook credentials
  environment{
    TEAMS_WEBHOOK_URL = credentials('training-repo-alert-webhook')
  }

    //Stages of the build
    stages {
      //setup stage clears workspace dir
      stage('Setup') {
        steps {
          deleteDir()
        }
      }

      //Build stage finds the branches are compares them to the latest tag using a bash script
      stage('build') {
        steps {
          //Gets credentials for git clone
          withCredentials([
            usernamePassword(credentialsId: 'GitHub-awsCloudOpsCJT', passwordVariable: 'GITHUB_PASSWORD', usernameVariable: 'GITHUB_USERNAME'),
            ]) {
              script {
                //config global credentials
                sh"""
                git config --global credential.https://github.com/NIT-Administrative-Systems/AS-Common-AWS-Modules.git.helper '!f() { echo "username=""" + '${GITHUB_USERNAME}' + """"; echo "password=""" + '${GITHUB_PASSWORD}' + """"; }; f'
                """
                //clones repo to get BashScript
                sh 'git clone https://github.com/luv1593/mergeTest.git'
                //sets dir to mergeTest
                dir('mergeTest') {
                  //adds permissions so the bashscript can be read
                  env.EVNVARI = "${workspace}"
                  sh "chmod +x -R $EVNVARI"
                  //runs scripts
                  sh './BashScript.sh'
                }
                //unsets global credentials
                sh"""
                git config --global --unset credential.https://github.com/NIT-Administrative-Systems/AS-Common-AWS-Modules.git.helper
                """
          }
        }
      }
    }
  }
}
