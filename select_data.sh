#!/bin/bash
module load intel eccodes

cd "${WORKDIR}/TP_TSM/"

for file in `ls -f arome-forecast*`
do
  step=`echo $file | cut -d '_' -f2 | cut -d '.' -f1`
  grille=`echo $file | cut -d '_' -f1 | cut -d '.' -f2`
  # pour AROME
  grib_copy -w parameterNumber=0,discipline=0,parameterCategory=0,typeOfLevel=heightAboveGround,level=2 $file "T.${grille}_${step}.grib"
  # pour ARPEGE  
  #grib_copy -w parameterNumber=0,discipline=0,parameterCategory=0,typeOfLevel=heightAboveGround,level=2,productDefinitionTemplateNumber=1 $file "T.${grille}_${step}.grib"
done
