#!/usr/bin/bash
#SBATCH -J fetch
#SBATCH --partition=transfert
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=00:00:15
#SBATCH --ntasks-per-node=1
 
if [ -n $DATA_DIR ]
then
  cd $DATA_DIR
fi
 
cat $1 | ftget
# le ftget n'est pas lance avec l'option -q sinon le script s'arrete
# cela permet d'avoir COMPLETE le job slurm quand les fichiers sont bien presents dans le WORKDIR
 
# avant de finir le job, on verifie que les fichiers sont biens presents
for fichier in `cat $1 |  cut -d' ' -f2`
do
  test -f ${DATA_DIR}/${fichier}
  if [ $? != 0 ]
  then
    echo "ERREUR: fichier ${DATA_DIR}/${fichier} absent"
    exit 1
  fi
done
exit 0
