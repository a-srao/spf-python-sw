#!/bin/bash
set -efxo pipefail
. /opt/Modules/init/bash

source_files=${source_files?"ERROR: Set the enviornment varaible as 1st input source dir, eg src"}
sonar_python_pylint_report=${sonar_python_pylint_report?"ERROR: Set the enviornment varaible as 2nd input source file, eg reports/pylint.xml"}

echo "input_source is $source_files"
echo "output_source is $sonar_python_pylint_report"
echo "This script to generate the static code analysis report using pylint"
echo "This script expects pylint python packages"
echo "Python interpreter should be set when script is executed"

echo "Setting up the enviornment"
module load python/3.9
python -m pip install -r config/python/requirements.txt

echo "Executing pylint for static code analysis report"
python -m pylint --load-plugins=pylint.extensions.mccabe --exit-zero -r n --msg-template="{path}:{line}: [{msg_id}({symbol}), {obj}] {msg}" $source_files > $sonar_python_pylint_report

