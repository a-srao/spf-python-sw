#!/bin/tcsh
set echo
set -euxo pipefail
. /opt/Modules/init/bash

module load python/3.9
python -m pip install -r config/python/requirements.txt
python -m coverage run --omit=test --source src  --branch -m pytest --html=reports/pytest.html --cache-clear --junitxml reports/pytest.xml test/unit-test
python -m coverage html -d reports/coverage_html
python -m coverage xml -o reports/coverage.xml
