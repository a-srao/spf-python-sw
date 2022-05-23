[![Build Status](https://spf-jenkins.icp.infineon.com/buildStatus/icon?job=spf-python-sw%2Fmaster)](https://spf-jenkins.icp.infineon.com/job/spf-python-sw/job/master/)
[![SonarQube Coverage](https://sonar-ee.intra.infineon.com/api/project_badges/measure?project=spf-python-sw&branch=master&metric=coverage)](https://sonar-ee.intra.infineon.com/component_measures/metric/coverage/list?id=spf-python-sw&branch=master)
[![Quality Gate](https://sonar-ee.intra.infineon.com/api/project_badges/measure?project=spf-python-sw&branch=master&metric=alert_status)](https://sonar-ee.intra.infineon.com/component_measures/metric/alert_status/list?id=spf-python-sw&branch=master)
[]

# Introduction
This template contains the sample Python project to demonstrate the SPF Capabilities for Python.
It performs the following steps:
* Run the Unit tests 
* Generate the code coverage report
* Create sonar project (unless already existent) and apply the SPF Quality gate and Quality profile
* Push the unit test and code coverage report to the SonarQube project
* The build is only passed if there is no Quality gate errors in the SonarQube project

# Author
Kumar Amit (IFIN DES TCP SW)
Gupta Sandeep (IFIN DES SDF SCS)

# Pre-requisites
* Python installed on Jenkins slaves and local PC
* SonarQube Entreprise Instance configured on the Jenkins setup
* SPF Quality Gate for Python defined in SonarQube
* SPF Quality Profile for Python defined in SonarQube

# Installation

## Install required python packages on a local machine

Run the command:  
```
python -m pip install -r config/python/requirements.txt
```
  
The above command will

* Install required Python packages (unless already installed)

# Usage

## Run the script on a local machine

### Run the command:  
```
python -m src/hello_world.py
```
### Result:  
* The above command will print the 'Hello World!' statement

## Run unit tests on a local machine

Ready-to-use scripts can be used to execute unit tests.

### On windows, Run the bat script:  
```bat
scripts\windows\unittest.bat
```
### On Linux, Run the shell script (tcsh)
```bash
scripts/linux/unittest.sh
```
  
The above command will

* Install required Python packages (unless already installed)
* Execute all unit tests implemented in ***test/unit-test*** folder
* Generate all reports in ***reports*** directory
  * coverage report (coverage.xml, coverage_html)
  * test report (pytest.xml, pytest.html)

## Documentation