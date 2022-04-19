#!/bin/bash
echo "Hello World"
python -m pip install -r config/python/requirements.txt
coverage run --omit=*/test/* --source src,src/Hello --branch -m pytest --cache-clear --junitxml pytest_shell/pytest.xml test
coverage html -d pytest_shell/coverage_html
coverage xml -o pytest.xml
