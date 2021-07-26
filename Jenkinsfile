//Author Lucas Verrilli July 15, 2021 Email: lucas.verrilli@northwestern.edu
//This program will check the status of the repos in a list in order to tell the user
//if they are all up to date with the latest tag.


pipeline {
  agent any


    //These are the stages of the build
    stages {


      stage('Setup') {
        steps {
          //get dynamic pipelineTest dir   (newTestPipeline, Lucas-Test1)
          deleteDir()
        }
      }

      //This stage finds the branches are compares them to the latest tag
      stage('build') {
        steps {
          withCredentials([
            usernamePassword(credentialsId: 'GitHub-awsCloudOpsCJT', passwordVariable: 'GITHUB_PASSWORD', usernameVariable: 'GITHUB_USERNAME'),
            ]) {
              script {
                sh"""
                git config --global credential.https://github.com/NIT-Administrative-Systems/AS-Common-AWS-Modules.git.helper '!f() { echo "username=""" + '${GITHUB_USERNAME}' + """"; echo "password=""" + '${GITHUB_PASSWORD}' + """"; }; f'
                """

                sh 'git clone https://github.com/luv1593/mergeTest.git'
                dir('mergeTest') {
                  sh "chmod +x -R ${env.WORKSPACE}"
                  sh './BashScript.sh'
                }


                //Bash script for git comparisons
                sh 'pwd'


                sh"""
                git config --global --unset credential.https://github.com/NIT-Administrative-Systems/AS-Common-AWS-Modules.git.helper
                """



    EmailData = readFile(file: 'Email.txt')




          }
//call sh file in jenkins file


        }
      }

    }

  }
  //jenkins email with formating
  //mimetype html

/*
post {

  always {
  //add email param

    mail to: 'lucasv0107@gmail.com' ,
      subject: "Status of pipeline: test",
      body: " Jenkins pipeline Test Build Number: '${currentBuild.number}': '${EmailData}'"
    }
  }


*/


}
