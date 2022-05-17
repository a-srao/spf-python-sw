echo off

set source_files=%1
set sonar_python_pylint_report=%2

REM "This script to generate the static code analysis report using pylint"
REM "This script expects pylint python packages"
REM "Python interpreter should be set when script is executed"

REM "Setting up the enviornment"
python -m pip install -r config/python/requirements.txt

REM "Executing pylint for static code analysis report"
python -m pylint -r n --msg-template="{path}:{line}: [{msg_id}({symbol}), {obj}] {msg}" %source_files% > %sonar_python_pylint_report%

