//Author Lucas Verrilli July 15, 2021 Email: lucas.verrilli@northwestern.edu
//This program will check the status of the repos in a list in order to tell the user
//if they are all up to date with the latest tag.


pipeline {
    agent any

    //These are the choices for parameters for the Cron patterns.
    parameters{
      choice(name: "Schedule",
            choices: ['never', 'week','day', 'hour', "9am Everyday"],
            description: "How often would you like the pipeline to run?")

    }


    //The Cron pattern is chosen based on the users choice
    triggers {
        parameterizedCron('''
            */1 * 31 2 * %Schedule="never"
            */1 1 * * 1 %Schedule="week"
            */1 1 1 * * %Schedule="day"
            */1 1 * * * %Schedule="hour"
            0 9 * * * %Schedule="9am Everyday"

        ''')
    }


    //These are the stages of the build
    stages {

        //This stage finds the branches are compares them to the latest tag
        stage('build') {
            steps {
              script {

                //The WorkSpace is cleared before the script is run so no old versions of the repos are viewed.
                cleanWs()

                        //Bash script for git comparisons
                        sh '''#!/bin/bash

                        echo "-------------------------------------------------------------------------"

                        #This is the list of the repos that will be looked at. This list can be added to as more repos are made.
                        #NOTE: The repo must be in the NIT-Administrative-Systems GitHub site.
                        declare -a REPO_LIST=( 'SysDev-MoneyCat'
                                               'dynamic-forms'
                                               'JST-Skills-Inventory'
                                              )

                        #This list is the check list for the development branch, any new names for the development branch can be
                        #added here or the github branch name can be changed.
                        declare -a devLst=( 'origin/develop'
                                           'origin/dev'
                                           'origin/development'
                                           'origin/DEV'
                                           'origin/DEVELOP'
                                           'origin/DEVELOPMENT'
                                           )


                      #This list is the check list for the master/production branch, any new names for the master/production branch can be
                      #added here or the github branch name can be changed.
                      declare -a mastLst=('origin/master'
                                            'origin/prod'
                                            'origin/production'
                                            'origin/main'
                                            'origin/MASTER'
                                            'origin/PROD'
                                            'origin/PRODUCTION'
                                            'origin/MAIN'
                                            'origin/stable'
                                            )


                      #This list is the check list for the QA branch, any new names for the QA branch can be
                      #added here or the github branch name can be changed.
                      declare -a QALst=('origin/QA'
                                  'origin/qa'
                                  'origin/QAQHASsd'
                                  'origin/TEST'
                                  )


                        #adds date and time to email
                        dateAndTime=`date`
                        EMAIL=$' \n'
                        EMAIL+=$'Date and Time: '
                        EMAIL+=$' \n'
                        EMAIL+=$dateAndTime





                      #Goes through each repo in the list
                      for i in "${REPO_LIST[@]}"
                      do
                        #clones sets the directory and pulls the repo so all the information is up to date.
                        git clone https://github.com/NIT-Administrative-Systems/$i.git
                        cd "$i"
                        git pull


                        #gets all of the branches in the repo into an array
                        branArr=()
                        branch=$(git branch -r)

                        for k in $branch
                        do
                          branArr+=($k)
                        done


                        #assigens default values to the strings that will become the branch names
                        #this is done so that if there is no match it will say so.
                        DEVSTR="None"
                        QASTR="None"
                        MASSTR="None"


                      #finds the dev branch and saves that name
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



                      #Finds the master branch and saves the name
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


                      #finds the QA branch and saves the name
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



                      #prints out all of the strings for user to see
                      echo "QASTR: $QASTR"
                      echo "DEVSTR: $DEVSTR"
                      echo "MASSTR: $MASSTR"



                      #prints the repo being looked at
                      echo "repo: $i"







#open git repo here-> git ls-remote --tags --sort=v:refname https://github.com/luv1593/mergeTest.git (get last)
#local dir
#cant stop script in loop

#latest commit hash: git for-each-ref
#latest commit hash + changes: git show --pretty=format:"%H"

# git ls-remote --tags --sort=v:committerdate https://github.com/luv1593/mergeTest.git | grep -o 'v.1.*' | head -1
# git ls-remote --tags --sort=v:committerdate https://github.com/luv1593/mergeTest.git | grep -o 'v1.*' | tail -1
# git ls-remote --tags --sort=v:committerdate https://github.com/NIT-Administrative-Systems/$i.git | grep -o 'v.*' | tail -1

                        #adds repo name to the email
                        EMAIL+='\n'
                        EMAIL+='Email repo: '
                        EMAIL+=$i
                        EMAIL+='\n '

                        #command to get the latest tag from the  repo
                        CHKPOINT=$(git describe --tags `git rev-list --tags --max-count=1`)
                        disc=""


                        #what if no tag/ what if no tag and no master?

                        if [[ "$CHKPOINT" = *"fatal:"* ]];
                        then
                          disc=$MASSTR

                        else
                          disc=$(git describe --tags `git rev-list --tags --max-count=1`)

                        fi


                        #disc=$( git describe --tags `git rev-list --tags --max-count=1` )


                        #if no release compare to master to other branches

                        echo "tag: $disc"

                        #QA comparison section
                        echo '---------------------------latest vs QA ---------------------------------'
                        EMAIL+='latest verison: \n'
                        EMAIL+=$disc

                        EMAIL+='\n '

                        EMAIL+='difference between latest tag and QA:'

                      #If there is no branch that matched a name in the QA check list then it says there is no match
                      #If a match is found the branch is compared to the latest version
                      #If there is a difference between the 2 then the differences are put in the email, if not it says "no differences"
                      if [ "$QASTR" != "None" ];
                      then


                        diffsQ=$(git diff --stat $disc $QASTR)
                        echo $diffsQ
                        if [[ "$diffsQ" = *"insertions"* ||  "$diffsQ" = *"deletions"* ||  "$diffsQ" = *"insertion"* ||  "$diffsQ" = *"deletion"* ]];
                        then


                        EMAIL+=\n
                        EMAIL+=$(git diff --stat-graph-width=1 $disc..$QASTR | tail -1)
                        EMAIL+='\n '

                        else

                           EMAIL+='\n '
                           EMAIL+='There are no differences between latest tag and QA '
                           EMAIL+='\n '

                        fi

                      else

                      EMAIL+='\n '
                      EMAIL+='There is no branch matching QA. (If there is a QA branch check the name and make sure its on the pick list)'
                      EMAIL+='\n '

                      fi


                        #DEVELOPMENT compare section works the same as the QA section
                        echo '-------------------------latest vs dev------------------------------------'
                        EMAIL+='\n '

                        EMAIL+='difference between latest tag and dev: \n'

                        if [ "$DEVSTR" != "None" ];
                        then

                          diffsdev=$(git diff --stat $disc $DEVSTR)
                          echo $diffsdev
                          if [[ "$diffsdev" = *"insertions"* ||  "$diffsdev" = *"deletions"* ||  "$diffsdev" = *"insertion"* ||  "$diffsdev" = *"deletion"* ]];
                          then


                          EMAIL+='\n '
                          EMAIL+=$(git diff --stat-graph-width=1 $disc..$DEVSTR | tail -1)
                          EMAIL+='\n '

                          else

                               EMAIL+='\n '
                             EMAIL+='There are no differences between latest tag and dev '
                              EMAIL+='\n '

                          fi

                        else

                        EMAIL+='\n '
                        EMAIL+='There is no branch matching development. (If there is a development branch check the name and make sure its on the pick list)'
                        EMAIL+='\n '

                        fi



                        #master compare section works the same as the QA and development section
                        echo '-------------------------latest vs master------------------------------------'
                        #email section
                        EMAIL+='difference between latest tag and master:'


                        if [ "$MASSTR" != "None" ];
                        then

                          diffsM=$(git diff --stat $disc..$MASSTR)
                          echo $diffsM

                          if [[ "$diffsM" = *"insertions"* ||  "$diffsM" = *"deletions"* ||  "$diffsM" = *"insertion"* ||  "$diffsM" = *"deletion"* ]];
                          then


                          EMAIL+='\n '
                          EMAIL+=$(git diff --stat-graph-width=1 $disc..$MASSTR | tail -1)
                          EMAIL+='\n '



                          else
                           EMAIL+='\n '
                           EMAIL+='There are no differences between latest tag and master '
                          EMAIL+='\n '


                          fi

                        else

                        EMAIL+='\n '
                        EMAIL+='There is no branch matching master. (If there is a master branch check the name and make sure its on the pick list)'
                        EMAIL+='\n '

                        fi


                        EMAIL+=' ~~~~~~~~~~~~~~~~~~end of repo~~~~~~~~~~~~~~~~~~~~~~ '

                        echo "-------------------------------------------------------------------"

                        #steps back so the next repo is not created in the current repo folder
                        cd ..

                        done

                        echo $EMAIL

                        echo $EMAIL > Email.txt

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
            attachmentsPattern: 'Email.txt',
            body:" attached is the email.txt ",
            recipientProviders: [[$class: 'DevelopersRecipientProvider'],
            [$class: 'RequesterRecipientProvider']],
            subject: "Jenkins pipeline Test Build Number: '${currentBuild.number}' "
        }
    }




}
