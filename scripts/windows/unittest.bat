echo off

REM run this script to run the all available Python unittests
REM this script expects to the python packages pytest and coverage to be installed
REM for the Python interpreter which is active when this script is being run
python -m pip install -r config/python/requirements.txt
coverage run --omit=*/test/* --source .\\src  --branch -m pytest --cache-clear --junitxml .\\test\\unit-test
coverage html -d build_pytest/coverage_html
coverage xml -o pytest.xml