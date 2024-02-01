#!/bin/bash
YYYY='2024'
MM='01'
DD='20'
vapp='arome'
vconf='3dvarfr'
reseau='T0000P'
grille='eurw1s100'

ech_fin=51

out='liste_fichiers.txt'

# on supprime le fichier si il existe deja
if [ -f "$out" ]; then rm -f $out; fi


for (( step=0; step<=$ech_fin; step++))
do
  rep="/home/m/mxpt/mxpt001/vortex/${vapp}/${vconf}/OPER/${YYYY}/${MM}/${DD}/${reseau}/forecast"
  step2d=`printf "%02d" $step`
  file_hendrix="grid.${vapp}-forecast.${grille}+00${step2d}:00.grib"
  file_local="${vapp}-forecast.${grille}_${step2d}h.grib"

  echo "${rep}/${file_hendrix}" "${WORKDIR}/TP_TSM/${file_local}" >> $out
done

# le fichier liste_fichier.txt contient le nom du fichier sur hendrix et le nom du fichier local a telecharger
# on est le prestaging des fichiers a telecharger
module load hpss/1.0
cat $out | cut -d' ' -f1 > liste_prestage.tmp
hstage -f liste_prestage.tmp
rm -f liste_prestage.tmp

DATA_DIR=${WORKDIR}'/TP_TSM'
export DATA_DIR
mkdir $DATA_DIR
if [ -f "${DATA_DIR}/${out}" ]; then rm -f ${DATA_DIR}/${out} ; fi
cp -p $out ${DATA_DIR}/.
sbatch fetch.sh ${DATA_DIR}/${out}
