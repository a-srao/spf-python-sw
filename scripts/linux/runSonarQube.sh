#!/bin/bash
set -efxo pipefail
. /opt/Modules/init/bash


SONAR_TOKEN=${1?"ERROR: please pass 1st input as SONAR_TOKEN, eg SONAR_TOKEN"}

SONAR_HOST_URL=${2?"ERROR: please pass 2nd input as SONAR_HOST_URL, eg https://sonar.intra.infineon.com"}

sonar_projectName=${3?"ERROR: please pass 3rd input as sonar_projectName, eg des-spf-python-sw"}
sonar_projectKey=${4?"ERROR: please pass 4th input as SONAR_HOST_URL, eg des-spf-python-sw"}

JENKINS_URL=${5?"ERROR: please pass 5th input as JENKINS_URL, eg https://spf-jenkins.icp.infineon.com"}

sonar_qualityProfile=${6?"ERROR: please pass 6th input as sonar_qualityProfile, eg DES-SPF"}
sonar_qualityGate=${7?"ERROR: please pass 7th input as sonar_qualityGate, eg des-spf"}

BitBucket_projectName=${8?"ERROR: please pass 8th input as BitBucket project name, eg DESSPF"}
repo_name=${9?"ERROR: please pass 9th input as BitBucket repository name, eg spf-python-sw"}


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
