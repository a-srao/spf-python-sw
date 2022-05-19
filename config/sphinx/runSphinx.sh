#!/bin/tcsh

echo "Setting up the enviornment"

module load python/3.9

echo "Run this script to generate the Technical Doc"
echo "This script expects sphinx and sphinx-rtd-theme python packages"
echo "Python interpreter should be set when script is executed"

echo "Setting up the enviornments for SPHINX"
python -m pip install -r config/python/requirements.txt

pushd `pwd`
cd config/sphinx
echo  "Generate and edit reStructured text (.rst) files"
sphinx-apidoc  -f  -o  source  ../../src

echo "Generate the Technical Doc in HTML format"
make html
popd

