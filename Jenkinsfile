//Author Lucas Verrilli July 15, 2021 Email: lucas.verrilli@northwestern.edu
//This program will check the status of the repos in a list in order to tell the user
//if they are all up to date with the latest tag.


pipeline {
  agent any
    parameters{


        //pipeline parameters (may need to be dynamic)
        booleanParam(defaultValue: true, name: 'All_Repos')
        booleanParam(defaultValue: false, name: 'MoneyCat')
        booleanParam(defaultValue: false, name: 'FRS')
        //choice
        choice(
          choices: ['30 8 * * * ', '0 17 * * *', '15 * * * *', '1 23 31 2 *'],
          name: 'SCHEDULE',
          description: 'Everyday at 8:30am, Everyday at 5:00pm, Every 15 minutes, Never'
          )


      }


  //This triggers the cron pattern for the program
  triggers {
          cron("${params.SCHEDULE}")
        //cron("${params.SCHEDULE}")
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
            usernamePassword(credentialsId: 'luv1593', passwordVariable: 'GITHUB_PASSWORD', usernameVariable: 'GITHUB_USERNAME'),
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
                  sh "chmod +x -R \"${env.WORKSPACE}\""
                  //runs the script
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
