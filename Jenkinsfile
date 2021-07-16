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

    //police blotter cron (so no plugin)

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


                        comparison () {
                                                #QA comparison section
                                                EMAIL+='---------------------------latest vs '$1' ---------------------------------'


                                                EMAIL+='\n '

                                                EMAIL+="difference between latest tag and '$1':"

                                              #If there is no branch that matched a name in the QA check list then it says there is no match
                                              #If a match is found the branch is compared to the latest version
                                              #If there is a difference between the 2 then the differences are put in the email, if not it says "no differences"
                                              if [ "$1" != "None" ];
                                              then


                                                diffs=$(git diff --stat $disc $1)
                                                echo $diffs
                                                if [[ "$diffs" = *"insertions"* ||  "$diffs" = *"deletions"* ||  "$diffs" = *"insertion"* ||  "$diffs" = *"deletion"* ]];
                                                then


                                                EMAIL+=\n
                                                EMAIL+=$(git diff --stat-graph-width=1 $disc..$1 | tail -1)
                                                EMAIL+='\n '

                                                else

                                                   EMAIL+='\n '
                                                   EMAIL+="There are no differences between latest tag and '$1'"
                                                   EMAIL+='\n '

                                                fi

                                              else

                                              EMAIL+='\n '
                                              EMAIL+='There is no branch matching '$1'. (If there is a '$1' branch check the name and make sure its on the pick list)'
                                              EMAIL+='\n '

                                              fi

                        }

                        #Make into a function ^^^^^^ Output (EmailSTR)


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


                        disc=$(git describe --tags `git rev-list --tags --max-count=1`)

                        if [ "$disc" == "" ];
                        then
                          disc=$MASSTR
                          if [ "$disc" == "None" ];
                          then
                            disc=$QASTR
                            if [ "$disc" == "None" ];
                              then
                              disc=$DEVSTR

                            fi
                          fi
                        fi


                        #prints out all of the strings for user to see
                        echo "tag: $disc"
                        echo "QASTR: $QASTR"
                        echo "DEVSTR: $DEVSTR"
                        echo "MASSTR: $MASSTR"



                        #prints the repo being looked at
                        echo "repo: $i"

                        declare -a branchARR=( "$MASSTR"
                                               "$DEVSTR"
                                               "$QASTR"
                                               )

                       EMAIL+='latest verison: \n'
                       EMAIL+=$disc
                       for g in "${branchARR[@]}"
                       do
                         comparison "$g"
                       done
                       EMAIL+=~~~~~~~~~~~~~~~~~~ End of Repo ~~~~~~~~~~~~~~~~~~


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
