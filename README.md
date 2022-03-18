# Project Structure Skeleton Python
[![Build Status](https://iosi-jenkins.vih.infineon.com/buildStatus/icon?job=eden-python-project-template%2Fmaster)](https://iosi-jenkins.vih.infineon.com/job/eden-python-project-template/job/master/)
[![SonarQube Coverage](https://sonar-ee.intra.infineon.com/api/project_badges/measure?project=eden-python-project-template&branch=master&metric=coverage)](https://sonar-ee.intra.infineon.com/component_measures/metric/coverage/list?id=eden-python-project-template&branch=master)
[![Quality Gate](https://sonar-ee.intra.infineon.com/api/project_badges/measure?project=eden-python-project-template&branch=master&metric=alert_status)](https://sonar-ee.intra.infineon.com/component_measures/metric/alert_status/list?id=eden-python-project-template&branch=master)


This template contains the sample Python project to demonstrate the EDEN Quality Criteria check.
It performs the following steps:
* Run the Unit tests 
* Generate the code coverage report
* Create sonar project (unless already existent) and apply the EDEN Quality gate and Quality profile
* Push the unit test and code coverage report to the SonarQube project
* The build is only passed if there is no Quality gate errors in the SonarQube project

## Author
Nabila Abdessaied (IFAG DES SDF FW)
Florent Vial (IFAG DES SDF FW)

## Pre-requisites
* Python installed on Jenkins slaves and local PC
* SonarQube Entreprise Instance configured on the Jenkins setup
* EDEN Quality Gate for Python defined in SonarQube
* EDEN Quality Profile for Python defined in SonarQube

## Installation

### Install required python packages on a local machine

Run the command:  

    python -m pip install -r config/python/requirements.txt
  
The above command will

* Install required Python packages (unless already installed)


## Usage

### Run the script on a local machine

Run the command:  

    python -m scripts/hello_world.py
  
The above command will print the 'hello world' statement

### Run unit tests on a local machine

Run the bat script:  

    runtests.bat
  
The above command will

* Install required Python packages (unless already installed)
* execute all unit tests implemented in tests folder
* generate HTML coverage reports

## Documentation
* Refer [Eden Quality Gate Jenkins interface](https://iosi-jenkins.vih.infineon.com/job/eden-jenkins-pipeline-library/job/develop/Documentation/) to get more details on the EDEN quality gate interface used on Jenkins file
* [Jenkins Job](https://iosi-jenkins.vih.infineon.com/job/eden-python-project-template/) ensuring the EDEN Quality Criteria check on this Python template project

