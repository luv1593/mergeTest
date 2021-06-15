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

echo "${branArr[@]}"

git checkout master
got compare master..Dev

log=$(git log)

last=$(git rev-parse HEAD)

echo $last

echo "-------------------------------latest vs QA ------------------------------------"

mvdDiff=$(git diff $last..QA)

if [ "$mvdDiff" = "fatal: ambiguous argument '8221d7c4d085f9f73e65ab3f3698adc53607af8f..QA': unknown revision or path not in the working tree.
Use '--' to separate paths from revisions, like this:
'git <command> [<revision>...] -- [<file>...]'" ];
then
  echo "latest and qa are the same"
else
  echo "latest and QA need to me merged"
  echo "trying to merge now"
  git merge $last QA
fi


echo "-------------------------------latest vs master -------------------------------"

mvmDiff=$(git diff $last..master)

if [ "$mvmDiff" = "Already up to date." ];
then
  echo "latest and master are the same"
else
  echo "latest and master need to me merged"
  echo "trying to merge now"
  git merge $last master
fi



echo "--------------------------------latest vs dev -----------------------------------"

mvmDiff=$(git diff $last..dev)

if [ "$mvmDiff" = "Already up to date." ];
then
  echo "latest and dev are the same"
else
  echo "latest and dev need to me merged"
  echo "trying to merge now"
  git merge $last dev
fi




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
}
