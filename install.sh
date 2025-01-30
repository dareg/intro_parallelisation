#!/bin/bash
p=$(pwd)
python3 -m venv venv
source venv/bin/activate
pip install cfgrib
pip install xarray
mkdir /tmp/data
cd /tmp/data
curl -X GET -k -o data.tgz "https://nextcloud.meteo.fr/s/DE33Ds9jjjoCco3/download?path=%2FIntroduction-parallelisation&files=data_introduction-parallelisation.tgz"
tar -xvzf data.tgz
rm -f data.tgz
cd $p
