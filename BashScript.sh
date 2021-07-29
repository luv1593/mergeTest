#!/bin/bash


echo $All

dateAndTime=`date`

curl -i -X POST -H "Content-Type: application/json" -d "{\"text\":\"Date and Time: \", \"text\":\"$dateAndTime\"}" $TEAMS_WEBHOOK_URL

comparison () {

#reduce info on the post
#bold on verson


  NOTIFICATION+="<h1 Style='text-decoration:underline'> <b> $disc </b> vs <b> $1</b>: </h1>"

  #If there is no branch that matched a name in the QA check list then it says there is no match
  #If a match is found the branch is compared to the latest version
  #If there is a difference between the 2 then the differences are put in the NOTIFICATION, if not it says "no differences"
  if [ "$1" != "None" ];
  then


    diffs=$(git diff --stat-graph-width=1 $disc $1)
    echo $diffs
    if [[ "$diffs" = *"insertions"* ||  "$diffs" = *"deletions"* ||  "$diffs" = *"insertion"* ||  "$diffs" = *"deletion"* ]];
    then

      #not in sync
      NOTIFICATION+="<p style='color:red'>⛔ $(git diff --stat-graph-width=1 $disc..$1 | tail -1)  </p>"

    else
      #in sync
      NOTIFICATION+="<p style='color:green'>✅ No differences between $disc and '$1'  </p>"
      BRANCHK=$(expr $BRANCHK + 1)


    fi

  else
    #no branch
    NOTIFICATION+="<p style='color:red'>⛔There is no branch matching '$1'. (If there is a '$1' branch check the name and make sure its on the pick list) </p>"


  fi

}



#This is the list of the repos that will be looked at. This list can be added to as more repos are made.
#NOTE: The repo must be in the NIT-Administrative-Systems GitHub site.
declare -a REPO_LIST=( 'SysDev-MoneyCat'
               'SysDev-FRS'
               'SysDev-URG'
               'SysDev-GSTS'
               'ecats-api'
               'ecats-ui'
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
          'origin/TEST'
          )

 declare -a GoodREPO=()

newline="</br>"


#Goes through each repo in the list
for i in "${REPO_LIST[@]}"
do

  #clones sets the directory and pulls the repo so all the information is up to date.
  git clone https://$GITHUB_USERNAME:$GITHUB_PASSWORD@github.com/NIT-Administrative-Systems/$i.git
  #git clone git@github.com:NIT-Administrative-Systems/\$i.git

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

  #command to get the latest tag from the  repo

  #only master

  echo "repo: '$i'"
  disc=$(git describe --tags `git rev-list --tags --max-count=1`)
  echo "repo:"

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

  NOTIFICATION+="latest verison: <b>$disc</b>"
  NOTIFICATION+=${newline}

  declare -i BRANCHK=0

  for g in "${branchARR[@]}"
  do
    comparison "$g"
  done


  #conditional send
  #neat

  #only sends notification if less than 3 branches are not up to date.
  if [ $BRANCHK != 3 ];
  then
    #curl command to send webhook MessageCard
    curl --location --request POST $TEAMS_WEBHOOK_URL \
  --header 'Content-Type: application/json' \
  -d "{
      \"@type\": \"MessageCard\",
      \"themeColor\": \"800080\",
      \"summary\": \"hello\",
      \"title\": \"$i\",
      \"text\": \"$NOTIFICATION\",
      \"potentialAction\": [{
              \"@type\": \"OpenUri\",
              \"name\": \"View Repo\",
              \"targets\": [{
                  \"os\": \"default\",
                  \"uri\": \"http://github.com/NIT-Administrative-Systems/$i\"
              }]
      } , {
            \"@type\": \"OpenUri\",
            \"name\": \"View Comparison\",
            \"targets\": [{
                \"os\": \"default\",
                \"uri\": \"http://github.com/NIT-Administrative-Systems/$i/compare\"
              }]
      }]
  }"


  else
    #if all 3 branchs are good the repo is added to the Good list
    GoodREPO+="$i,</br> "

  fi

  #notification is clearned for next MessageCard
  NOTIFICATION=" "


  #steps back so the next repo is not created in the current repo folder
  cd ..

done

#final curl command sends the list of repos that are in the good list
curl -i -X POST -H "Content-Type: application/json" -d "{\"title\":\"Up to date repos as of $dateAndTime: \", \"text\":\"${GoodREPO[@]}\"}" $TEAMS_WEBHOOK_URL
