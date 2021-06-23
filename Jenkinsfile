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
dateAndTime=`date`

disc=$( git describe --tags `git rev-list --tags --max-count=1`)

#git checkout $disc

echo $disc


echo "---------------------------latest vs QA ---------------------------------"

#check update delete and create automerge

#email section

branch=$(git branch -r)

for i in $branch
do
  branArr+=($i)
done

echo "latest verison: "> Email.txt
echo $disc >> Email.txt
echo " " >> Email.txt
echo "Date and Time: " >> Email.txt
echo $dateAndTime >> Email.txt
echo " " >> Email.txt
echo "Branches: " >> Email.txt
for j in ${branArr[@]}
do
 echo $j >> Email.txt
done
echo " " >> Email.txt
echo "difference between latest tag and QA:"  >> Email.txt
echo "-                                               -" >> Email.txt
echo $(git diff --stat $disc..origin/QA) >> Email.txt
echo "-                                               -" >> Email.txt

diffs=$(git diff --stat $disc..origin/QA)
#try to merge

echo $diffs
if [[ "$diffs" = *"insertions"* ||  "$diffs" = *"deletions"* || "$diffs" = *"insertion"* || "$diffs" = *"deletion"* ]];
then

  echo "There is a difference between QA and the latest tag"
  git checkout origin/QA


  git fetch
  git merge $disc
  git push -f origin HEAD:QA

else
  echo "There is no difference between QA and the latest tag"
fi

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

  echo "There is a difference between dev and the latest tag"
  git checkout origin/dev
  git fetch
  git merge $disc
  test=$(git push -f origin HEAD:dev)


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
echo "latest branch commits" >> Email.txt
echo $(for branch in `git branch -r | grep -v HEAD`;do echo -e `git show --format="%ci %cr" $branch | head -n 1` \\t$branch; done | sort -r) >> Email.txt

diffsM=$(git diff --stat $disc..origin/master)
#try to merge

echo $diffs
if [[ "$diffsM" = *"insertions"* ||  "$diffsM" = *"deletions"* ||  "$diffsM" = *"insertion"* ||  "$diffsM" = *"deletion"* ]];
then

  echo "There is a difference between master and the latest tag"
  git checkout origin/master
  git fetch
  git merge $disc
  test=$(git push -f origin HEAD:master)


else
  echo "There is no difference between master and the latest tag"
fi





echo "-------------------------------------------------------------------"

# get latest from all 3 branches then if master is not latest report where latest is , created a branch not from master


'''

            }
        }

    }
    post {
        always {
            emailext attachLog: true, attachmentsPattern: 'Email.txt',body:" ", recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: "Jenkins pipeline Test Build Number: '${currentBuild.number}' repo: ${params.repo} "
        }
    }




}
