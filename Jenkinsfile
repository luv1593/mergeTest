pipeline {
    agent any

    parameters{
      choice(name: "Schedule",
            choices: ['never', 'week','day', 'hour', "9am Everyday"],
            description: "How often would you like the pipeline to run?")

    }



    triggers {
        parameterizedCron('''
            */1 * 31 2 * %Schedule="never"
            */1 1 * * 1 %Schedule="week"
            */1 1 1 * * %Schedule="day"
            */1 1 * * * %Schedule="hour"
            0 9 * * * %Schedule="9am Everyday"

        ''')
    }

    stages {
        stage('chosen parameters') {
            steps {

                sh '''#!/bin/bash
                dateAndTime=`date`
                echo " " > Email.txt
                echo "Date and Time: " >> Email.txt
                echo $dateAndTime >> Email.txt
                echo " " >> Email.txt
                '''
            }
        }

        stage('build') {
            steps {
              script {
              REPO_LIST = ["https://github.com/luv1593/mergeTest.git", "https://github.com/luv1593/branchTest.git"]




              for(int i=0; i < REPO_LIST.size(); i++) {



                    stage(REPO_LIST[i]){
                        git REPO_LIST[i]
                        echo REPO_LIST[i]
                        def repoName = REPO_LIST[i]
                        echo "${repoName}"

                        sh '''#!/bin/bash
                        echo "-------------------------------------------------------------------------"
                        git "${repoName}"
                        echo "Repo: ${repoName}" >> Email.txt
                        echo " " >> Email.txt

                        disc=$( git describe --tags `git rev-list --tags --max-count=1`)


                        echo $disc
                        echo "---------------------------latest vs QA ---------------------------------"
                        echo "latest verison: " >> Email.txt
                        echo $disc >> Email.txt
                        unset disc
                        echo $disc
                        echo " " >> Email.txt



                        echo "difference between latest tag and QA:"  >> Email.txt
                        echo "                                              " >> Email.txt
                        echo $(git diff --stat-graph-width=1 $disc..origin/QA) >> Email.txt
                        echo "                                              " >> Email.txt


                        echo "-------------------------latest vs dev------------------------------------"
                        #email section
                        echo "difference between latest tag and dev:"  >> Email.txt
                        echo " " >> Email.txt
                        echo $(git diff  --stat-graph-width=1 $disc..origin/dev) >> Email.txt
                        echo " " >> Email.txt

                        echo "-------------------------latest vs master------------------------------------"
                        #email section
                        echo "difference between latest tag and master:"  >> Email.txt
                        echo "                                               " >> Email.txt
                        echo $(git diff --stat-graph-width=1 $disc..origin/master) >> Email.txt
                        echo "                                               " >> Email.txt
                        echo " " >> Email.txt

                        echo "-------------------------------------------------------------------"
                        # get latest tag from all 3 branches then if master is not latest report where latest is , created a branch not from master
                        #if master is not most up to date then tag was created from not master
                        '''

                        }
                      }
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
