#!/usr/bin/env bash

DIRECTORY="src/main/resources"
PASSWORD_FILE="$DIRECTORY/password.txt"

#read -p "Enter your certificate password : " PASSWORD
#echo "The password is: $PASSWORD"
PASSWORD=changeit

if [ ! -d "$DIRECTORY" ]; then
    mkdir ${DIRECTORY}
fi

if [ -d "$DIRECTORY" ]; then
    rm -rf ${DIRECTORY}/*
fi

echo ${PASSWORD} >> ${PASSWORD_FILE}

# generate the certificates
keytool -genkey -alias server-alias -keyalg RSA -keypass ${PASSWORD} -storepass ${PASSWORD} -keystore ${DIRECTORY}/keystore.jks

# Export the generated certificate to server.cer file.
keytool -export -alias server-alias -storepass ${PASSWORD} -file ${DIRECTORY}/server.cer -keystore ${DIRECTORY}/keystore.jks

# Add the certificate to the trust store file
keytool -import -v -trustcacerts -alias server-alias -file ${DIRECTORY}/server.cer -keystore ${DIRECTORY}/cacerts.jks -keypass ${PASSWORD} -storepass ${PASSWORD}

# Verify if the certificate was successfully added into the keystore.
keytool -list -v -keystore ${DIRECTORY}/keystore.jks

# Validate if the certificate was successfully added into the trust store.
keytool -list -keystore ${DIRECTORY}/cacerts.jks