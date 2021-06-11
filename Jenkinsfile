pipline{

  agent any
  
  stages {
     stage("build") {
        steps {
              echo "-------------------------------------------------------------------------"

git branch

echo "-------------------------------------------------------------------------"

branch=$(git symbolic-ref --short -q HEAD)
if [ "$branch" != "$version" ]; then
  git checkout $version
fi

git update-index -q --refresh
if ! git diff-index --quiet HEAD --; then
  echo "Working directory not clean, please commit your changes first"
  exit
fi

git checkout master
git merge $version --no-ff --no-edit

npm version $version
git push
git push --tags

git checkout dev
git merge master --no-ff --no-edit
git push

git branch -D $version
git push origin --delete $version

echo "-------------------------------------------------------------------------"
echo "Release $version complete"
echo "-------------------------------------------------------------------------"
        
        }
      }
      
   stages {
     stage("test") {
        steps {
        }
      }
      
   stages {
     stage("deploy") {
        steps {
        }
      }
      
