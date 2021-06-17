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
                  echo "-----------mergeTest---------------!!"
                } else {
                  git 'https://github.com/luv1593/branchTest.git'
                  echo "-----------branchTest---------------!!"
                  }
            }



sh '''#!/bin/bash


echo "-------------------------------------------------------------------------"

branArr=()
onlyBran=()

branch=$(git branch -r)

for i in $branch
do
  branArr+=($i)
done



#last=$(git rev-parse HEAD)

#latest branch in all not

disc=$(git describe --tags)

echo $disc


echo "-------------------------------latest vs QA ------------------------------------"



diffs=$(git diff --stat $disc..origin/QA)
#try to merge

echo $diffs
if [[ "$diffs" = *"insertions"* ||  "$diffs" = *"deletions"* ]];
then
  echo "There is a difference between QA and the latest tag"
  git checkout origin/QA
  git merge $disc
  echo "merge completed"
  git add .
  echo "add completed"
  git commit -m "commit on jenkins"
  echo "commiy completed"
  git push origin QA:QA
  echo "push completed"
else
  echo "There is no difference between QA and the latest tag"
fi



#email section

echo "latest verison: "> Email.txt
echo $disc >> Email.txt
echo "difference between latest tag and QA:"  >> Email.txt
echo "-                                               -" >> Email.txt
echo $(git diff --stat $disc..origin/QA) >> Email.txt
echo "-                                               -" >> Email.txt


echo "-------------------------------latest vs master -------------------------------"

diffsM=$(git diff --stat $disc..origin/master)
#try to merge

if [[ "$diffsM" = *"insertions"* ||  "$diffsM" = *"deletions"* ]];
then
  echo "There is a difference between master and the latest tag"
  git checkout origin/master
  git merge $disc
  git add .
  git commit -m "commit on jenkins"
  git push origin master
else
  echo "There is no difference between master and the latest tag"
fi



#echo format?
echo "difference between latest tag and master:"  >> Email.txt
echo "-                                               -" >> Email.txt
echo $(git diff --stat $disc..origin/master) >> Email.txt
echo "-                                               -" >> Email.txt


echo "--------------------------------latest vs dev -----------------------------------"

diffsD=$(git diff --stat $disc..origin/dev)
#try to merge

echo $diffsD
if [[ "$diffsD" = *"insertions"* ||  "$diffsD" = *"deletions"* ]];
then
  echo "There is a difference between dev and the latest tag"
  git checkout origin/dev
  git commit -a -m  "commit on jenkins"
  git checkout origin/master
  git checkout -b hotfix
  git commit -a -m 'hotfix commit'
  git checkout origin/master
  git merge hotfix
  git branch -d hotfix
  git checkout origin/dev
  git commit -a -m 'finished hotfix commit'
  git checkout origin/master
  git merge origin/dev

  git push -u origin master
else
  echo "There is no difference between dev and the latest tag"
fi

echo "difference between latest tag and dev:"  >> Email.txt
echo $(git diff --stat $disc..origin/dev) >> Email.txt
echo "-                                               -" >> Email.txt


#not empty = diff
#only master(prod)(check) dev QA

#2 dots vs 3 dots diff

#(later) pull request

#email:
#repo name, branch diff, all branches present, merged(yes or no)(version #'s)


echo "-------------------------------------------------------------------------"





# Assuming you have a master and dev branch, and that you make new
# release branches named as the version they correspond to, e.g. 1.0.3
# Usage: ./release.sh 1.0.3

# Get version argument and verify
#version=$1
#if [ -z "$version" ]; then
#  echo "Please specify a version"
#  exit
#fi

# Output
#echo "Releasing version $version"
#echo "-------------------------------------------------------------------------"

# Get current branch and checkout if needed
#branch=$(git symbolic-ref --short -q HEAD)
#if [ "$branch" != "$version" ]; then
#  git checkout $version
#fi

# Ensure working directory in version branch clean
#git update-index -q --refresh
#if ! git diff-index --quiet HEAD --; then
#  echo "Working directory not clean, please commit your changes first"
#  exit
#fi

# Checkout master branch and merge version branch into master
#git checkout master
#git merge $version --no-ff --no-edit

# Run version script, creating a version tag, and push commit and tags to remote
#npm version $version
#git push
#git push --tags

# Checkout dev branch and merge master into dev (to ensure we have the version)
#git checkout Dev
#git merge master --no-ff --no-edit
#git push

# Delete version branch locally and on remote
#git branch -D $version
#git push origin --delete $version

# Success
#echo "-------------------------------------------------------------------------"
#echo "Release $version complete"'''

            }
        }

    }

    post {
        always {
            emailext attachLog: true, attachmentsPattern: 'Email.txt',body:"hello", recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: "Jenkins pipeline Test. Build Number: '${currentBuild.number}'"
        }
    }




}
