#!/bin/tcsh
module load python/3.9
python -m pip install -r config/python/requirements.txt
python -m coverage run --omit=test --source src --branch -m pytest --cache-clear --junitxml pytest_hello/pytest.xml test
python -m coverage html -d pytest_shell/coverage_html
python -m coverage xml -o pytest.xml