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


                        sh '''#!/bin/bash

                        echo "-------------------------------------------------------------------------"
                        declare -a REPO_LIST=( 'SysDev-MoneyCat'
                                               'CloudOps-standard-vpc'
                                              )

                        declare -a devLst=( 'origin/develop'
                                           'origin/dev'
                                           'origin/development'
                                           'origin/DEV'
                                           'origin/DEVELOP'
                                           'origin/DEVELOPMENT'
                                           )

                      declare -a mastLst=('origin/master'
                                            'origin/prod'
                                            'origin/production'
                                            'origin/main'
                                            'origin/MASTER'
                                            'origin/PROD'
                                            'origin/PRODUCTION'
                                            'origin/MAIN'
                                            'origon/stable'
                                            )

                      declare -a QALst=('origin/QA'
                                  'origin/qa'
                                  'origin/QAQHASsd'
                                  'origin/TEST'
                                  )



                        dateAndTime=`date`
                        EMAIL=$' \n'
                        EMAIL+=$'Date and Time: '
                        EMAIL+=$' \n'
                        EMAIL+=$dateAndTime


                      DEVSTR=""
                      QASTR=""
                      MASSTR=""



                      for i in "${REPO_LIST[@]}"
                      do
                        git clone https://github.com/NIT-Administrative-Systems/$i.git
                        cd "$i"
                        git pull

                        branArr=()
                        branch=$(git branch -r)

                        for k in $branch
                        do
                          branArr+=($k)
                        done




                      for l in "${branArr[@]}"
                      do
                        for j in "${devLst[@]}"
                        do
                        if [ "$j" == "$l" ];
                        then
                          DEVSTR=$j
                        fi
                        done
                      done




                      for q in "${branArr[@]}"
                      do
                        for w in "${mastLst[@]}"
                        do

                        if [ "$q" == "$w" ];
                        then
                          MASSTR=$q
                        fi
                        done
                      done


                      for o in "${branArr[@]}"
                      do
                        for p in "${QALst[@]}"
                        do

                        if [ "$o" == "$p" ];
                        then
                          QASTR=$o
                        fi
                        done
                      done




echo "QASTR: $QASTR"
echo "DEVSTR: $DEVSTR"
echo "MASSTR: $MASSTR"




                        echo "repo: $i"







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

                        disc=$( git ls-remote --tags --sort=v:committerdate https://github.com/NIT-Administrative-Systems/$i.git | grep -o 'v.*' | tail -1)
                        #fix so its chopped up right.
                        echo $disc


                        #if no release compare to master to other branches

                        echo "tag: $disc"
                        echo '---------------------------latest vs QA ---------------------------------'
                        EMAIL+='latest verison: \n'
                        EMAIL+=$disc

                        EMAIL+='\n '

                        EMAIL+='difference between latest tag and QA:'

                        #more branch names
                        diffsQ=$(git diff --stat $disc $QASTR)
                        echo $diffsQ
                        if [[ "$diffsQ" = *"insertions"* ||  "$diffsQ" = *"deletions"* ||  "$diffsQ" = *"insertion"* ||  "$diffsQ" = *"deletion"* ]];
                        then


                        EMAIL+=\n
                        EMAIL+=$(git diff --stat-graph-width=1 $disc..$QASTR)
                        EMAIL+='\n '

                        else

                           EMAIL+='\n '
                           EMAIL+='There are no differences between latest tag and QA '
                          EMAIL+='\n '

                        fi


                        echo '-------------------------latest vs dev------------------------------------'
                          EMAIL+='\n '

                        EMAIL+='difference between latest tag and dev: \n'

                        diffsdev=$(git diff --stat $disc $DEVSTR)
                        echo $diffsdev
                        if [[ "$diffsdev" = *"insertions"* ||  "$diffsdev" = *"deletions"* ||  "$diffsdev" = *"insertion"* ||  "$diffsdev" = *"deletion"* ]];
                        then


                        EMAIL+='\n '
                        EMAIL+=$(git diff --stat-graph-width=1 $disc..$DEVSTR)
                        EMAIL+='\n '

                        else

                             EMAIL+='\n '
                           EMAIL+='There are no differences between latest tag and dev '
                            EMAIL+='\n '

                        fi

                        echo '-------------------------latest vs master------------------------------------'
                        #email section
                        EMAIL+='difference between latest tag and master:'

                        diffsM=$(git diff --stat $disc..$MASSTR)
                        echo $diffsM

                        if [[ "$diffsM" = *"insertions"* ||  "$diffsM" = *"deletions"* ||  "$diffsM" = *"insertion"* ||  "$diffsM" = *"deletion"* ]];
                        then


                        EMAIL+='\n '
                        EMAIL+=$(git diff --stat-graph-width=1 $disc..$MASSTR)
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
