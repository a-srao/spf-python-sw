#!/bin/bash
set echo
set -efxo pipefail
. /opt/Modules/init/bash

source_files=${1?"ERROR: please pass 1st input as input source dir, eg src"}
sonar_python_pylint_report=${2?"ERROR: please pass 2nd input as output source file, eg reports/pytest.xml"}

echo "source is $source_files"
echo "source is $sonar_python_pylint_report"
echo "This script to generate the static code analysis report using pylint"
echo "This script expects pylint python packages"
echo "Python interpreter should be set when script is executed"

echo "Setting up the enviornment"
module load python/3.9
python -m pip install -r config/python/requirements.txt

echo "Executing pylint for static code analysis report"
python -m pylint --load-plugins=pylint.extensions.mccabe --exit-zero -r n --msg-template="{path}:{line}: [{msg_id}({symbol}), {obj}] {msg}" $source_files > $sonar_python_pylint_report

