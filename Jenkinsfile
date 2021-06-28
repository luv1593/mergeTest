pipeline {
    agent any

    parameters{
      choice(name: "Schedule",
            choices: ['never', 'week','day', 'hour', "Monday(9am)", "Friday(9am)"],
            description: "How often would you like the pipeline to run?")
    }



    triggers {
        parameterizedCron('''
            */1 * 31 2 * %Schedule="never"
            */1 1 * * 1 %Schedule="week"
            */1 1 1 * * %Schedule="day"
            */1 1 * * * %Schedule="hour"
            0 9 * * 1 %Schedule="Monday(9am)"
            0 9 * * 5 %Schedule="Friday(9am)"
        ''')
    }

    stages {
        stage('chosen parameters') {
            steps {
                echo "${params.repo}"
                echo "${params.Schedule}"

            }
        }

        stage('build') {
            steps {
              script {
                REPO_LIST = ["https://github.com/luv1593/mergeTest.git", "https://github.com/luv1593/branchTest.git"]
                
                for(int i=0; i < REPO_LIST.size(); i++) {
                          stage(REPO_LIST[i]){
                              echo "Element: $i"
                              }
                              }

                git 'https://github.com/luv1593/mergeTest.git'


                GIT_VERSION_TAG = sh (
                  script: 'git describe --tags `git rev-list --tags --max-count=1`',
                    returnStdout: true
                      ).trim()
                    echo "${GIT_VERSION_TAG}"
                  sh "git diff --stat-graph-width=1 ${GIT_VERSION_TAG}..origin/QA "


                      }

                    }
        }

    }
    post {
        always {
            emailext attachLog: true, attachmentsPattern: 'Email.txt',body:" attached is the email.txt ", recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: "Jenkins pipeline Test Build Number: '${currentBuild.number}' repo: ${params.repo} "
        }
    }




}
