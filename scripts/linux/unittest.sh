#!/bin/bash
set echo
set -euxo pipefail
. /opt/Modules/init/bash

source_files=${source_files?"ERROR: Set the enviornment varaible as 1st input, eg src"}
sonar_python_reportPath=${sonar_python_reportPath?"ERROR: Set the enviornment varaible as 2nd input, eg reports/pytest.html"}
sonar_python_coverage_reportPath=${sonar_python_coverage_reportPath?"ERROR: Set the enviornment varaible as 3rd input, eg reports/coverage_html"}

module load python/3.9
python -m pip install -r config/python/requirements.txt
python -m coverage run --omit=test --source $source_files  --branch -m pytest --html=$sonar_python_reportPath --cache-clear --junitxml $sonar_python_reportPath test/unit-test
python -m coverage html -d $sonar_python_coverage_reportPath
python -m coverage xml -o $sonar_python_coverage_reportPath
