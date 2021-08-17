#!/bin/bash

#date and time to be printed at the start of the script
dateAndTime=`date`

#sends the date and time to the webhook location
curl -i -X POST -H "Content-Type: application/json" -d "{\"text\":\"Date and Time: \", \"text\":\"$dateAndTime\"}" $TEAMS_WEBHOOK_URL

#function for the comparison of the branches and the creation of the NOTIFICATION.
comparison () {

  #adds tag and branch name to the notification
  NOTIFICATION+="<h1 Style='text-decoration:underline'> <b> $disc </b> vs <b> $1</b>: </h1>"

  #If there is no branch that matched a name in the branch check list then it says there is no match
  #If a match is found the branch is compared to the latest version
  #If there is a difference between the 2 then the differences are put in the NOTIFICATION, if not it says "no differences"
  if [ "$1" != "None" ];
  then

    #HOW OLD IS THE TAG ()



    #quick check to see if there is a difference between the branch and the tag
    diffs=$(git diff --stat-graph-width=1 $disc $1)
    echo $diffs
    if [[ "$diffs" = *"insertions"* ||  "$diffs" = *"deletions"* ||  "$diffs" = *"insertion"* ||  "$diffs" = *"deletion"* ]];
    then

      #This is the notification that is sent if the branch is not in sync
      NOTIFICATION+="<p style='color:red'>⛔ $(git diff --stat-graph-width=1 $disc..$1 | tail -1)  </p>"

      echo "WORKS?"
      if [ "$1" = "$DEVSTR" ];
      then
        git config --global push.default simple

        #gets tags date
        TAGTIMESTAMP=$(git log -1 --format=%ai $disc)

        CURRDATE=$(date --date='-3 month' +%F)

        echo "tag date:"
        echo "${TAGTIMESTAMP: 0:10}"
        echo "curr date"
        echo $CURRDATE

        TAGDATE=$(date -d ${TAGTIMESTAMP: 0:10} +%s)



        if [ $CURRDATE -gt $TAGDATE ];
        then
          echo "DATE COMPARE"
        else
          echo "Date 2"
        fi


        git checkout $DEVSTR
        #do checks
        git merge $MASSTR

        git push origin HEAD:$DEVSTR
        #add conflict

      fi

    else
      #This is the notification that is sent if the branch is in sync
      NOTIFICATION+="<p style='color:green'>✅ No differences between $disc and '$1'  </p>"
      BRANCHK=$(expr $BRANCHK + 1)


    fi

  else
    #This is the notification that is sent if there is no branch
    NOTIFICATION+="<p style='color:red'>⛔There is no branch matching '$1'. (If there is a '$1' branch check the name and make sure its on the pick list) </p>"


  fi

}

#if the ALL checkbox is on all of the repos will be looked at.
if [ $All_Repos == true ];
then
#This is the list of the repos that will be looked at. This list can be added to as more repos are made.
#NOTE: The repo must be in the NIT-Administrative-Systems GitHub site.
  declare -a REPO_LIST=( 'mergeTest'
                          'branchTest'
                )

#if the All is not checked then it will go through and add each repo that was checked to the list. (look into dynamic option)
else
  declare -a REPO_LIST=()

  if [ $MoneyCat == true  ];
  then
    REPO_LIST+=("mergeTest")
  fi

  if [ $FRS == true  ];
  then
    REPO_LIST+=("branchTest")
  fi

fi

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
          'origin/TEST'
          )

#list to save the repos that are all up to date
declare -a GoodREPO=()

#</br> tag to add newline to the notification
newline="</br>"

#Goes through each repo in the list
for i in "${REPO_LIST[@]}"
do

  #clones sets the directory and pulls the repo so all the information is up to date.
  git clone https://$GITHUB_USERNAME:$GITHUB_PASSWORD@github.com/luv1593/$i.git

  #REPO CHECK IF EXISTS if still in pwd mergeTest
  cd "$i"

  #pwd string after cd to check if we are in the repo.
  pwdSTR=$(pwd)

  #git pull any new info from the repo
  git pull

  #gets all of the branches in the repo into an array
  branArr=()
  branch=$(git branch -r)

  #adds branches to the branch array to be checked later
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


  #gets latest tag from the repo
  disc=$(git describe --tags `git rev-list --tags --max-count=1`)

  #if no latest tag then use the master branch
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

  #saves branches in an array
  declare -a branchARR=( "$MASSTR"
             "$DEVSTR"
             "$QASTR"
            )

  #notification info
  NOTIFICATION+="latest verison: <b>$disc</b>"
  NOTIFICATION+=${newline}

  #branch check variable to check if the repo is completely up to date
  declare -i BRANCHK=0

  #compares all branches to the latest tag
  for g in "${branchARR[@]}"
  do
    comparison "$g"
  done

  #if the CD is still in the mergeTest gives error MessageCard
  if [ "${pwdSTR: -20}" = "SysDev-RepoSynchrony" ];
  then

  curl --location --request POST $TEAMS_WEBHOOK_URL \
--header 'Content-Type: application/json' \
-d "{
    \"@type\": \"MessageCard\",
    \"themeColor\": \"800080\",
    \"summary\": \"Repo Compare Info\",
    \"title\": \"$i\",
    \"text\": \"<p style='color:red'>⛔ERROR: This repo was not read correctly. Please make sure you have access to this repo.</p>\",
    \"potentialAction\": [{
            \"@type\": \"OpenUri\",
            \"name\": \"View Repo\",
            \"targets\": [{
                \"os\": \"default\",
                \"uri\": \"http://github.com/NIT-Administrative-Systems/$i\"
            }]
    }]
}"

else
  #only sends notification if less than 3 branches are not up to date.
  if [ $BRANCHK != 3 ];
  then
      #curl command to send webhook MessageCard

      #BUILD  large string and send in 1 webhook
      curl --location --request POST $TEAMS_WEBHOOK_URL \
    --header 'Content-Type: application/json' \
    -d "{
    \"@type\": \"MessageCard\",
    \"themeColor\": \"800080\",
    \"summary\": \"Repo Compare Info\",
    \"title\": \"$i\",
    \"text\": \"$NOTIFICATION\",
    \"potentialAction\": [
        {
            \"@type\": \"OpenUri\",
            \"name\": \"View Repo\",
            \"targets\": [
                {
                    \"os\": \"default\",
                    \"uri\": \"http://github.com/NIT-Administrative-Systems/$i\"
                }
            ]
        },
        {
            \"@type\": \"OpenUri\",
            \"name\": \"View Prod\",
            \"targets\": [
                {
                    \"os\": \"default\",
                    \"uri\": \"http://github.com/NIT-Administrative-Systems/$i/compare/${MASSTR:7}...$disc\"
                }
            ]
        },
        {
            \"@type\": \"OpenUri\",
            \"name\": \"View Dev\",
            \"targets\": [
                {
                    \"os\": \"default\",
                    \"uri\": \"http://github.com/NIT-Administrative-Systems/$i/compare/${DEVSTR:7}...$disc\"
                }
            ]
        },
        {
            \"@type\": \"OpenUri\",
            \"name\": \"View QA\",
            \"targets\": [
                {
                    \"os\": \"default\",
                    \"uri\": \"http://github.com/NIT-Administrative-Systems/$i/compare/${QASTR:7}...$disc\"
                }
            ]
        }
    ]
}"

    else
      #if all 3 branchs are good the repo is added to the Good list
      GoodREPO+="$i,</br> "
  fi
fi

  #notification is clearned for next MessageCard
  NOTIFICATION=" "


  #steps back so the next repo is not created in the current repo folder
  cd ..

done

#final curl command sends the list of repos that are in the good list
curl -i -X POST -H "Content-Type: application/json" -d "{\"title\":\"Up to date repos as of $dateAndTime: \", \"text\":\"${GoodREPO[@]}\"}" $TEAMS_WEBHOOK_URL
