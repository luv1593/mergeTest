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

branch=$(git branch -a)

for i in $branch
do
  branArr+=($i)
done
echo "-------------------------------------------------------------------------"

echo "${branArr[@]}"
echo "-------------------------------------------------------------------------"


for e in "${branArr[@]}"
do
if [[ ! " ${branArr[@]} " == *"remotes/origin/"* ]]; then
    onlyBran+=( ${branArr[e]} )
fi
done

echo "${onlyBran[@]}"

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
