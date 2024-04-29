#!/bin/bash
set -efxo pipefail
. /opt/Modules/init/bash


SONAR_TOKEN=${SONAR_TOKEN?"ERROR: Set the enviornment variable for SONAR_TOKEN, eg SONAR_TOKEN"}

SONAR_HOST_URL=${SONAR_HOST_URL?"ERROR: Set the enviornment variable for SONAR_HOST_URL, eg https://sonar.intra.infineon.com"}

sonar_projectName=${sonar_projectName?"ERROR: Set the enviornment variable for sonar_projectName, eg des-spf-python-sw"}
sonar_projectKey=${sonar_projectKey?"ERROR: Set the enviornment variable for SONAR_HOST_URL, eg des-spf-python-sw"}

JENKINS_URL=${JENKINS_URL?"ERROR: Set the enviornment variable for JENKINS_URL, eg https://spf-jenkins.icp.infineon.com"}

sonar_qualityProfile=${sonar_qualityProfile?"ERROR: Set the enviornment variable for sonar_qualityProfile, eg DES-SPF"}
sonar_qualityGate=${sonar_qualityGate?"ERROR: Set the enviornment variable for sonar_qualityGate, eg des-spf"}

BitBucket_projectName=${BitBucket_projectName?"ERROR: Set the enviornment variable for BitBucket project name, eg DESSPF"}
repo_name=${repo_name?"ERROR: Set the enviornment variable for BitBucket repository name, eg spf-python-sw"}


echo "SONAR_HOST_URL is $SONAR_HOST_URL"
echo "sonar_projectName is $sonar_projectName"
echo "sonar_projectKey is $sonar_projectKey"
echo "JENKINS_URL is $JENKINS_URL"
echo "sonar_qualityProfile is $sonar_qualityProfile"
echo "sonar_qualityGate is $sonar_qualityGate"
echo "BitBucket_projectName is $BitBucket_projectName"
echo "SONAR_TOKEN is $SONAR_TOKEN"
echo "repo_name is $repo_name"


curl -u "${SONAR_TOKEN}" -X POST "${SONAR_HOST_URL}/api/projects/create?name=${sonar_projectName}&project=${sonar_projectKey}"

# Fetch the list of existing webhooks for the project
EXISTING_WEBHOOKS=$(curl -s -u "${SONAR_TOKEN}" "${SONAR_HOST_URL}/api/webhooks/list?project=${sonar_projectName}" | jq -r '.webhooks[] | select(.url == "'"${JENKINS_URL}sonarqube-webhook/"'")')

# Check if the desired webhook URL is already in the list of webhooks for the project
if [[ -n "${EXISTING_WEBHOOKS}" ]]; then
    echo "Webhook already exists. Using existing webhook..."
else
    # Create webhook
    curl -u "${SONAR_TOKEN}" -X POST "${SONAR_HOST_URL}/api/webhooks/create?name=jenkins&project=${sonar_projectKey}&url=${JENKINS_URL}sonarqube-webhook/"
    echo "Webhook created successfully."
fi

curl -u "${SONAR_TOKEN}" -X POST -d language=py -d project=${sonar_projectKey} -d qualityProfile=${sonar_qualityProfile} "${SONAR_HOST_URL}/api/qualityprofiles/add_project"
curl -u "${SONAR_TOKEN}" -X POST -d gateName=${sonar_qualityGate} -d projectKey=${sonar_projectKey} ${SONAR_HOST_URL}/api/qualitygates/select
curl -u "${SONAR_TOKEN}" -X POST -d "almSetting=Bitbucket Server" -d "repository=${BitBucket_projectName}" -d "project=${sonar_projectName}" -d "slug=${repo_name}" -d "monorepo=false" "${SONAR_HOST_URL}/api/alm_settings/set_bitbucket_binding"
