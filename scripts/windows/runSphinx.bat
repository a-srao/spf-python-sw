echo off

REM Run this script to generate the Technical Doc
REM This script expects sphinx and sphinx-rtd-theme python packages
REM Python interpreter should be set when script is executed

REM Setting up the enviornments for SPHINX
python -m pip install -r config/python/requirements.txt
pushd "%cd%"

cd config/sphinx
REM Generate and edit reStructured text (.rst) files
sphinx-apidoc  -f  -o  ./source  ../../src

REM Generate the Technical Doc in HTML format
make html
popd
