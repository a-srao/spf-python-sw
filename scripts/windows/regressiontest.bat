echo off

REM run this script to run the all available Python unittests
REM this script expects to the python packages pytest and coverage to be installed
REM for the Python interpreter which is active when this script is being run

python -m pip install -r config/python/requirements.txt
IF %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

python -m pytest --html=reports/regression.html --cache-clear --junitxml reports/regression.xml test\\regression-test
IF %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

@REM python -m coverage html -d reports/coverage_html
@REM python -m coverage xml -o reports/coverage.xml
