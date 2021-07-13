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
              echo "hello"

            }
        }

        stage('build') {
            steps {
              script {


                cleanWs()


              //put all info into 1 vari and at end append and clean




                //jenkins needs to open repo

                  //git 'https://github.com/luv1593/branchTest.git'


                        sh '''#!/bin/bash

                        echo "-------------------------------------------------------------------------"
                        declare -a REPO_LIST=( 'mergeTest'
                                                'branchTest'
                                                )


                        dateAndTime=`date`
                        EMAIL="\n"
                        EMAIL+="  ${EMAIL} Date and Time: \n"
                        EMAIL+="${EMAIL}  $dateAndTime \n"


                      for i in "${REPO_LIST[@]}"
                      do
                        git clone https://github.com/luv1593/$i.git
                        cd "/Users/lucasverrilli/.jenkins/workspace/piplineTest/$i"

                        echo "repo: $i"


                        git pull




#open git repo here-> git ls-remote --tags --sort=v:refname https://github.com/luv1593/mergeTest.git (get last)
#local dir
#cant stop script in loop

#latest commit hash: git for-each-ref
#latest commit hash + changes: git show --pretty=format:"%H"

# git ls-remote --tags --sort=v:committerdate https://github.com/luv1593/mergeTest.git | grep -o 'v.1.*' | head -1
# git ls-remote --tags --sort=v:committerdate https://github.com/luv1593/mergeTest.git | grep -o 'v1.*' | tail -1


                          EMAIL+="\n "
                        EMAIL+="Email repo: $i"
                          EMAIL+="\n "

                      #  disc=$( git describe --tags `git rev-list --tags --max-count=1`)

                        disc=$( git ls-remote --tags --sort=v:committerdate https://github.com/luv1593/$i.git | grep -o 'v1.*' | tail -1)


                        echo "tag: $disc"
                        echo "---------------------------latest vs QA ---------------------------------"
                        EMAIL+="latest verison: \n"
                        EMAIL+=" $disc"

                        EMAIL+="\n "

                        echo "difference between latest tag and QA:"  >> Email.txt

                        diffsQ=$(git diff --stat $disc origin/QA)
                        echo $diffsQ
                        if [[ "$diffsQ" = *"insertions"* ||  "$diffsQ" = *"deletions"* ||  "$diffsQ" = *"insertion"* ||  "$diffsQ" = *"deletion"* ]];
                        then


                        EMAIL+="\n "
                          EMAIL+=$(git diff --stat-graph-width=1 $disc..origin/QA)
                        EMAIL+="\n "

                        else

                           EMAIL+="\n "
                           EMAIL+="There are no differences between latest tag and QA "
                          EMAIL+="\n "

                        fi


                        echo "-------------------------latest vs dev------------------------------------"
                          EMAIL+="\n "

                        EMAIL+="difference between latest tag and dev: \n"

                        diffsdev=$(git diff --stat $disc origin/dev)
                        echo $diffsdev
                        if [[ "$diffsdev" = *"insertions"* ||  "$diffsdev" = *"deletions"* ||  "$diffsdev" = *"insertion"* ||  "$diffsdev" = *"deletion"* ]];
                        then


                        EMAIL+="\n "
                        EMAIL+=$(git diff --stat-graph-width=1 $disc..origin/dev)
                        EMAIL+="\n "

                        else

                             EMAIL+="\n "
                           EMAIL+="There are no differences between latest tag and dev "
                            EMAIL+="\n "

                        fi

                        echo "-------------------------latest vs master------------------------------------"
                        #email section
                        EMAIL+="difference between latest tag and master:"

                        diffsM=$(git diff --stat $disc..origin/master)
                        echo $diffsM

                        if [[ "$diffsM" = *"insertions"* ||  "$diffsM" = *"deletions"* ||  "$diffsM" = *"insertion"* ||  "$diffsM" = *"deletion"* ]];
                        then


                        EMAIL+="\n "
                        EMAIL+=$(git diff --stat-graph-width=1 $disc..origin/master)
                        EMAIL+="\n "



                        else
                         EMAIL+="\n "
                         EMAIL+="There are no differences between latest tag and master "
                        EMAIL+="\n "


                        fi
                        EMAIL+=" ~~~~~~~~~~~~~~~~~~end of repo~~~~~~~~~~~~~~~~~~~~~~ "

                        echo "-------------------------------------------------------------------"
                        # get latest tag from all 3 branches then if master is not latest report where latest is , created a branch not from master
                        #if master is not most up to date then tag was created from not master

                        cd ..

                        done

                        echo $EMAIL

                        echo $EMAIL > Email.txt

                        '''


                        }







            }
        }

    }
    //CHOSE email
    post {
        always {
            emailext attachLog: true,
            attachmentsPattern: 'Email.txt',
            body:" attached is the email.txt ",
            recipientProviders: [[$class: 'DevelopersRecipientProvider'],
            [$class: 'RequesterRecipientProvider']],
            subject: "Jenkins pipeline Test Build Number: '${currentBuild.number}' "
        }
    }




}
