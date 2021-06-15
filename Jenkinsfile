pipeline {
    agent any

    stages {
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }

        stage('build') {
            steps {


git 'https://github.com/luv1593/mergeTest.git'

sh '''#!/bin/bash


echo "-------------------------------------------------------------------------"

#branches = git ls-remote

branArr=()
onlyBran=()

branch=$(git branch -r)

for i in $branch
do
  branArr+=($i)
done



last=$(git rev-parse HEAD)

disc=$(git describe --tags)

echo $disc


echo "-------------------------------latest vs QA ------------------------------------"


mvdDiff=$(git diff $disc..origin/QA)

#if [ "$mvdDiff" = " " ];
#then
#  echo "latest and qa are the same"
#else
#  echo "latest and QA need to me merged"
#  echo "trying to pull request now"
#  git request-pull https://github.com/luv1593/mergeTest.git QA
#fi

echo $disc > Email.txt
echo "--------difference between latest tag and QA-----------" >> Email.txt
echo $(git diff $disc..origin/QA) >> Email.txt
echo "-------------------------------------------------------" >> Email.txt


echo "-------------------------------latest vs master -------------------------------"

mvmDiff=$(git diff $disc..origin/master)

if [ "$mvmDiff" = "Already up to date." ];
then
  echo "latest and master are the same"
else
  echo "latest and master need to me merged"
  echo "trying to merge now"
  git merge $last origin/master
fi

echo "test 2" >> Email.txt


echo "--------------------------------latest vs dev -----------------------------------"

mvmDiff=$(git diff $disc..origin/dev)

if [ "$mvmDiff" = "Already up to date." ];
then
  echo "latest and dev are the same"
else
  echo "latest and dev need to me merged"
  echo "trying to merge now"
  git merge $last origin/dev
fi

echo echo $(git diff $disc..origin/dev) >> Email.txt


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
branch=$(git symbolic-ref --short -q HEAD)
if [ "$branch" != "$version" ]; then
  git checkout $version
fi

# Ensure working directory in version branch clean
git update-index -q --refresh
if ! git diff-index --quiet HEAD --; then
  echo "Working directory not clean, please commit your changes first"
  exit
fi

# Checkout master branch and merge version branch into master
git checkout master
git merge $version --no-ff --no-edit

# Run version script, creating a version tag, and push commit and tags to remote
npm version $version
git push
git push --tags

# Checkout dev branch and merge master into dev (to ensure we have the version)
git checkout Dev
git merge master --no-ff --no-edit
git push

# Delete version branch locally and on remote
git branch -D $version
git push origin --delete $version

# Success
echo "-------------------------------------------------------------------------"
echo "Release $version complete"'''

            }
        }

    }

    post {
        always {
            emailext attachLog: true, attachmentsPattern: 'Email.txt',body:"hello", recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: 'Jenkins pipeline Test'
        }
    }




}
