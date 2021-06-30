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


              //put all info into 1 vari and at end append and clean





                        sh '''#!/bin/bash

                        echo "-------------------------------------------------------------------------"
                        REPO_LIST={"https://github.com/luv1593/mergeTest.git"]

                      for i in $REPO_LIST
                      do
                        echo $i
                        git $i


                        echo $REPONAME >> Email.txt
                        echo " " >> Email.txt

                        disc=$( git describe --tags `git rev-list --tags --max-count=1`)



                        echo $disc
                        echo "---------------------------latest vs QA ---------------------------------"
                        echo "latest verison: " >> Email.txt
                        echo $disc >> Email.txt

                        echo " " >> Email.txt

                        echo "difference between latest tag and QA:"  >> Email.txt

                        diffsQ=$(git diff --stat $disc..origin/QA)
                        if [[ "$diffsQ" = *"insertions"* ||  "$diffsQ" = *"deletions"* ||  "$diffsQ" = *"insertion"* ||  "$diffsQ" = *"deletion"* ]];
                        then


                        echo "                                              " >> Email.txt
                        echo $(git diff --stat-graph-width=1 $disc..origin/QA) >> Email.txt
                        echo "                                              " >> Email.txt

                        else

                           echo "                                              " >> Email.txt
                           echo "There are no differences between latest tag and QA " >> Email.txt
                           echo "                                              " >> Email.txt

                        fi


                        echo "-------------------------latest vs dev------------------------------------"
                        #email section
                        echo "difference between latest tag and dev:"  >> Email.txt
                        echo " " >> Email.txt
                        echo $(git diff  --stat-graph-width=1 $disc..origin/dev) >> Email.txt
                        echo " " >> Email.txt

                        echo "-------------------------latest vs master------------------------------------"
                        #email section
                        echo "difference between latest tag and master:"  >> Email.txt

                        diffsM=$(git diff --stat $disc..origin/master)
                        echo $diffsM

                        if [[ "$diffsM" = *"insertions"* ||  "$diffsM" = *"deletions"* ||  "$diffsM" = *"insertion"* ||  "$diffsM" = *"deletion"* ]];
                        then


                        echo "                                               " >> Email.txt
                        echo $(git diff --stat-graph-width=1 $disc..origin/master) >> Email.txt
                        echo "                                               " >> Email.txt
                        echo " " >> Email.txt


                        else
                        echo "                                              " >> Email.txt
                         echo "There are no differences between latest tag and master " >> Email.txt
                         echo "                                              " >> Email.txt
                         echo " ~~~~~~~~~~~~~~~~~~end of repo~~~~~~~~~~~~~~~~~~~~~~ " >> Email.txt

                        fi

                        echo "-------------------------------------------------------------------"
                        # get latest tag from all 3 branches then if master is not latest report where latest is , created a branch not from master
                        #if master is not most up to date then tag was created from not master

                        done

                        '''

                        }







            }
        }

    }
    post {
        always {
            emailext attachLog: true, attachmentsPattern: 'Email.txt',body:" attached is the email.txt ", recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: "Jenkins pipeline Test Build Number: '${currentBuild.number}' "
        }
    }




}
