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


echo "---------------------------latest vs QA ---------------------------------"



diffs=$(git diff --stat $disc..origin/QA)
#try to merge

echo $diffs
if [[ "$diffs" = *"insertions"* ||  "$diffs" = *"deletions"* ]];
then

  echo "There is a difference between QA and the latest tag"
  git checkout origin/QA
  git fetch
  git merge $disc
  echo "merge completed"
  git push origin QA:QA







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

echo "-------------------------------------------------------------------------"

'''

            }
        }

    }

    post {
        always {
            emailext attachLog: true, attachmentsPattern: 'Email.txt',body:"hello", recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: "Jenkins pipeline Test. Build Number: '${currentBuild.number}'"
        }
    }




}
