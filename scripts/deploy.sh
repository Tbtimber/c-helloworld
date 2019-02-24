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
echo '=======================Retrieving devices list==============='

deviceList=$(curl -X GET \
     -H "token":$remoteItAuthToken \
     -H "developerkey":"$REMOTEIT_DEVELOPER_KEY" \
     https://api.remot3.it/apv/v27/device/list/all |\
     jq ".devices")
echo "$deviceList"
echo '=======================Connecting to device==============='
echo $(jq '. - map(select(.devicealias[] | contains ("mainPI_ssh"))) | .[] .Id' deviceList)

echo '=======================Connecting to device==============='
curl -X POST \
     -H "token":$remoteItAuthTokens \
     -H "developerkey":"$REMOTEIT_DEVELOPER_KEY" \
     -d '{"wait":"true ","deviceaddress":"'$REMOTEIT_DEVICE_ADDRESS'"}' \
     https://api.remot3.it/apv/v27/device/connect
#After Authenticate :
