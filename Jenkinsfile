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

                        declare -a devLst=( 'develop'
                                           ' dev'
                                           ' development'
                                           ' DEV'
                                           ' DEVELOP'
                                           ' DEVELOPMENT'
                                           )

                      declare -a mastLst=(' master'
                                            ' prod'
                                            ' production'
                                            ' main'
                                            ' MASTER'
                                            ' PROD'
                                            ' PRODUCTION'
                                            ' MAIN'
                                            )

                      declare -a QALst=(' QA'
                                  ' qa'
                                  ' test'
                                  ' TEST'
                                  )



                        dateAndTime=`date`
                        EMAIL=$' \n'
                        EMAIL+=$'Date and Time: '
                        EMAIL+=$' \n'
                        EMAIL+=$dateAndTime

                        branArr=()
                        branch=$(git branch -r)

                        for i in $branch
                        do
                          #echo $i
                          branArr+=($i)
                        done




                      for i in "${REPO_LIST[@]}"
                      do
                        git clone https://github.com/luv1593/$i.git
                        cd "$i"

                        ITT=0

                        for j in "${devLst[@]}"

                        do
                        echo $j
                        echo $ITT
                        echo ${branArr[$ITT]}
                        ((ITT=ITT+1))

                        if [ "$j" == "${branArr[ITT]}" ];
                        then
                          echo "RIGHT HERE"

                        fi

                        done

                        echo "repo: $i"


                        git pull




#open git repo here-> git ls-remote --tags --sort=v:refname https://github.com/luv1593/mergeTest.git (get last)
#local dir
#cant stop script in loop

#latest commit hash: git for-each-ref
#latest commit hash + changes: git show --pretty=format:"%H"

# git ls-remote --tags --sort=v:committerdate https://github.com/luv1593/mergeTest.git | grep -o 'v.1.*' | head -1
# git ls-remote --tags --sort=v:committerdate https://github.com/luv1593/mergeTest.git | grep -o 'v1.*' | tail -1


                          EMAIL+='\n'
                        EMAIL+='Email repo: '
                        EMAIL+=$i
                          EMAIL+='\n '

                      #  disc=$( git describe --tags `git rev-list --tags --max-count=1`)

                        disc=$( git ls-remote --tags --sort=v:committerdate https://github.com/luv1593/$i.git | grep -o '*' | tail -1)
                        #fix so its chopped up right.


                        #if no release compare to master to other branches

                        echo 'tag: $disc'
                        echo '---------------------------latest vs QA ---------------------------------'
                        EMAIL+='latest verison: \n'
                        EMAIL+=$disc

                        EMAIL+='\n '

                        EMAIL+='difference between latest tag and QA:'

                        #more branch names
                        diffsQ=$(git diff --stat $disc origin/QA)
                        echo $diffsQ
                        if [[ "$diffsQ" = *"insertions"* ||  "$diffsQ" = *"deletions"* ||  "$diffsQ" = *"insertion"* ||  "$diffsQ" = *"deletion"* ]];
                        then


                        EMAIL+=\n
                        EMAIL+=$(git diff --stat-graph-width=1 $disc..origin/QA)
                        EMAIL+='\n '

                        else

                           EMAIL+='\n '
                           EMAIL+='There are no differences between latest tag and QA '
                          EMAIL+='\n '

                        fi


                        echo '-------------------------latest vs dev------------------------------------'
                          EMAIL+='\n '

                        EMAIL+='difference between latest tag and dev: \n'

                        diffsdev=$(git diff --stat $disc origin/dev)
                        echo $diffsdev
                        if [[ "$diffsdev" = *"insertions"* ||  "$diffsdev" = *"deletions"* ||  "$diffsdev" = *"insertion"* ||  "$diffsdev" = *"deletion"* ]];
                        then


                        EMAIL+='\n '
                        EMAIL+=$(git diff --stat-graph-width=1 $disc..origin/dev)
                        EMAIL+='\n '

                        else

                             EMAIL+='\n '
                           EMAIL+='There are no differences between latest tag and dev '
                            EMAIL+='\n '

                        fi

                        echo '-------------------------latest vs master------------------------------------'
                        #email section
                        EMAIL+='difference between latest tag and master:'

                        diffsM=$(git diff --stat $disc..origin/master)
                        echo $diffsM

                        if [[ "$diffsM" = *"insertions"* ||  "$diffsM" = *"deletions"* ||  "$diffsM" = *"insertion"* ||  "$diffsM" = *"deletion"* ]];
                        then


                        EMAIL+='\n '
                        EMAIL+=$(git diff --stat-graph-width=1 $disc..origin/master)
                        EMAIL+='\n '



                        else
                         EMAIL+='\n '
                         EMAIL+='There are no differences between latest tag and master '
                        EMAIL+='\n '


                        fi
                        EMAIL+=' ~~~~~~~~~~~~~~~~~~end of repo~~~~~~~~~~~~~~~~~~~~~~ '

                        echo "-------------------------------------------------------------------"
                        # get latest tag from all 3 branches then if master is not latest report where latest is , created a branch not from master
                        #if master is not most up to date then tag was created from not master

                        cd ..

                        done

                        echo $EMAIL

                        echo $EMAIL > Email.html

                        '''


                        }







            }
        }

    }
    //move to bash
    post {
    //what are other options?
        always {
            emailext attachLog: true,
            attachmentsPattern: 'Email.html',
            body:" attached is the email.html ",
            recipientProviders: [[$class: 'DevelopersRecipientProvider'],
            [$class: 'RequesterRecipientProvider']],
            subject: "Jenkins pipeline Test Build Number: '${currentBuild.number}' "
        }
    }




}
