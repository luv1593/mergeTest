pipeline {
    agent any

    parameters{
      choice(name: "repo",
            choices: ["mergeTest" ,"branchTest"],
            description: "choose repo to use.",)
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
                if ( "${params.repo}" == "mergeTest" ) {
                  git 'https://github.com/luv1593/mergeTest.git'

                } else {
                  git 'https://github.com/luv1593/branchTest.git'

                  }
            }



sh '''#!/bin/bash
echo "-------------------------------------------------------------------------"
branArr=()
onlyBran=()
devLst=${"origin/dev" "origin/develop" "origin/development" "origin/DEV" "origin/DEVELOP" "origin/DEVELOPMENT"}
mastLst=("origin/master" "origin/prod" "origin/production" "origin/main" "origin/MASTER" "origin/PROD" "origin/PRODUCTION" "origin/MAIN")
QALst=("origin/QA"
       "origin/qa"
      "origin/test"
      "origin/TEST")
dateAndTime=`date`
disc=$( git describe --tags `git rev-list --tags --max-count=1`)
#git checkout $disc
echo $disc
#latest --> QA
#do other way
#git pull so no local conflict
#fix looping
echo "-------------------------------------------------------------------------"
branch=$(git branch -r)
for i in $branch
do
  #echo $i
  branArr+=($i)
done
echo "---------------------------latest vs QA ---------------------------------"
echo "latest verison: "> Email.txt
echo $disc >> Email.txt
echo " " >> Email.txt
echo "Date and Time: " >> Email.txt
echo $dateAndTime >> Email.txt
echo " " >> Email.txt
echo "difference between latest tag and QA:"  >> Email.txt
echo "-                                               -" >> Email.txt
echo $(git diff --stat-graph-width=1 $disc..origin/QA) >> Email.txt
echo "-                                               -" >> Email.txt
diffs=$(git diff --stat $disc..origin/QA)
#take out merge sections
echo $diffs
echo "-------------------------latest vs dev------------------------------------"
#email section
echo "difference between latest tag and dev:"  >> Email.txt
echo "-                                               -" >> Email.txt
echo $(git diff --stat $disc..origin/dev) >> Email.txt
echo "-                                               -" >> Email.txt
diffsD=$(git diff --stat $disc..origin/dev)
#try to merge
echo $diffs
if [[ "$diffsD" = *"insertions"* ||  "$diffsD" = *"deletions"* ||  "$diffsD" = *"insertion"* ||  "$diffsD" = *"deletion"* ]];
then
  echo "checking latest --> dev"
  git checkout origin/dev
  git fetch
  git merge $disc
  echo "checking dev --> latest"
  git checkout $disc
  git fetch
  git merge origin/dev
  #git push origin HEAD:dev
else
  echo "There is no difference between QA and the latest tag"
fi
echo "-------------------------latest vs master------------------------------------"
#email section
echo "difference between latest tag and master:"  >> Email.txt
echo "-                                               -" >> Email.txt
echo $(git diff --stat $disc..origin/master) >> Email.txt
echo "-                                               -" >> Email.txt
echo " " >> Email.txt
#Can be a pick list:
# master prod production main
# QA test qa
# dev develop
#report if none are found
if [ $(git checkout origin/master) == *'error:'*];
then
  MorPbranch="origin/production"
  pushName="production"
else
  MorPbranch="origin/master"
  pushName="master"
fi
diffsM=$(git diff --stat $disc..$MorPbranch)
#try to merge
echo $diffs
if [[ "$diffsM" = *"insertions"* ||  "$diffsM" = *"deletions"* ||  "$diffsM" = *"insertion"* ||  "$diffsM" = *"deletion"* ]];
then
  echo "There is a difference between master/prod and the latest tag"
  echo "checking latest --> dev"
  git checkout origin/master
  git fetch
  git merge $disc
  echo "checking master --> latest"
  git checkout $disc
  git fetch
  git merge origin/master
else
  echo "There is no difference between master and the latest tag"
fi
echo "-------------------------------------------------------------------"
# get latest tag from all 3 branches then if master is not latest report where latest is , created a branch not from master
#if master is not most up to date then tag was created from not master
'''

            }
        }

    }
    post {
        always {
            emailext attachLog: true, attachmentsPattern: 'Email.txt',body:" attached is the email.txt ", recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: "Jenkins pipeline Test Build Number: '${currentBuild.number}' repo: ${params.repo} "
        }
    }




}
