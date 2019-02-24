#!/bin/bash


echo '=====================Deployment=============================='
#Authenticate with https://api.remot3.it/apv/v27/user/login
#Param is -H dev KEY (passed as env variable from Travis CI)
#Param is -B username (passed as env variable from Travis CI)
#PAram is -B Password (passed as env variable from Travis CI)

#On failure return with null
echo '=======================Authentication with remoteIt==========='
remoteItAuthToken=$(curl -X POST \
     -H "developerkey":"$REMOTEIT_DEVELOPER_KEY" \
     -d '{"username":"'$REMOTEIT_USERNAME'","password":"'$REMOTEIT_PASSWORD'"}' \
     https://api.remot3.it/apv/v27/user/login |\
     jq ".token")
echo '=============Authentication over========================'
echo "$remoteItAuthToken"
remoteItAuthToken="${remoteItAuthToken%\"}"
remoteItAuthToken="${remoteItAuthToken#\"}"
echo "$remoteItAuthToken"
echo '=======================Connecting to device==============='
conectionResponse=$(curl -X POST \
     -H "token:$remoteItAuthToken" \
     -H "developerkey:$REMOTEIT_DEVELOPER_KEY" \
     -d '{"wait":"true ","deviceaddress":"'$PI_SSH_ADDRESS'"}' \
     https://api.remot3.it/apv/v27/device/connect |\
     jq '.')
echo '====================Connection to device done===================='

echo "$conectionResponse"
conectionResponse="${conectionResponse%\"}"
conectionResponse="${conectionResponse#\"}"
proxyPort=$(echo "$conectionResponse" | jq '.connection.proxyport')
echo 'proxyPort is : $proxyPort'
remoteIp=$(echo "$conectionResponse" | jq '.connection.proxyserver.ip')
echo 'remoteIp is : $remoteIp'


#After Authenticate :
