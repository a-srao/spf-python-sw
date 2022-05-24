#!/bin/tcsh
set echo
module load python/3.9
python -m pip install -r config/python/requirements.txt
python -m pytest --html=reports/regression.html --cache-clear --junitxml reports/regression.xml test/regression-test