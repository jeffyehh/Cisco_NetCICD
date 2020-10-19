#!/bin/bash
echo "***********************************"
echo "Start clean" 
echo "***********************************"
docker-compose down

sudo rm -rf gitea/data/*
sudo rm -rf jenkins/data/*
sudo rm -rf jenkins/data/.*
sudo rm -rf jenkins/config/*
sudo rm -rf jenkins/docker/*
sudo rm -rf jenkins/sock*
sudo rm -rf nexus/data/*
sudo chown -r $USER:$USER postgres/data
sudo rm -rf postgres/data/*
echo " " 
echo "***********************************"
echo "Create containers"
echo "***********************************"
docker-compose up -d --build
echo " " 
echo "***********************************"
echo "Use docker-compose up -d next time"
echo "***********************************"
echo " " 
echo "***********************************"
echo "Now go to http://localhost:3000 and"
echo " "
echo "Press install... you may need to " 
echo " "
echo " login to see install" 
echo " "
echo "***********************************"

read -p "Press any key to continue... " -n1 -s

echo " " 
echo "**********************************"
echo "Create gituser"
echo "**********************************"
docker exec -it gitea sh -c "su git -c '/usr/local/bin/gitea admin create-user --username netcicd --password netcicd --admin --email netcicd@netcicd.nl --access-token'" > netcicd_token 
docker exec -it gitea sh -c "su git -c '/usr/local/bin/gitea admin create-user --username git-jenkins --password netcicd --admin --email git-jenkins@netcicd.nl --access-token'" > git_jenkins_token 

token1=`cat netcicd_token | awk '/Access token was successfully created... /{print $NF}' netcicd_token`
echo "netcicd_token is: " $token1

token2=`cat git_jenkins_token | awk '/Access token was successfully created... /{print $NF}' git_jenkins_token`
echo "git_jenkins_token is: " $token2

curl --user netcicd:netcicd -X POST "http://localhost:3000/api/v1/repos/migrate" -H  "accept: application/json" -H  "Content-Type: application/json" -d "{  \"auth_password\": \"string\",  \"auth_token\": \"string\",  \"auth_username\": \"string\",  \"clone_addr\": \"https://github.com/Devoteam/NetCICD.git\",  \"description\": \"string\",  \"issues\": true,  \"labels\": true,  \"milestones\": true,  \"mirror\": true,  \"private\": true,  \"pull_requests\": true,  \"releases\": true,  \"repo_name\": \"netcicd\",  \"repo_owner\": \"netcicd\",  \"service\": \"git\",  \"uid\": 0,  \"wiki\": true}"
curl --user netcicd:netcicd -X POST "http://localhost:3000/api/v1/repos/netcicd/netcicd/branches" -H  "accept: application/json" -H  "Content-Type: application/json" -d "{  \"new_branch_name\": \"develop\"}"
curl --user netcicd:netcicd -X PUT "http://localhost:3000/api/v1/repos/netcicd/netcicd/collaborators/git-jenkins" -H  "accept: application/json" -H  "Content-Type: application/json" -d "{  \"permission\": \"write\"}"