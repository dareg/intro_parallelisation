import numpy as np
import os, fnmatch
import multiprocessing as mp

from readGrib import readGrib

#### Fonctionnement du script ####
# list_grib: liste des chemins relatifs vers les fichiers gribs de temperature
# data: Numpy Array a 3 dimensions, avec les indices des echeances, des lattitudes et des longitudes, contenant la valeur de temperature.
# dataMean: Numpy Array a une dimension (indice d'echeance) contenant la moyenne par echeance
##################################

def nanmean2d(array):
  return np.nanmean(array)

############################################
#### A MODIFIER POUR LA PARALELLISATION ####
############################################
parallelRead=True
parallelCompute=True
nbProcessRead=52
nbProcessCompute=52
############################################
############################################

#### Lecture des fichiers GRIB2 ####
pattern = "T.*.grib"
list_grib=list()
for entry in os.listdir('.'):
  if fnmatch.fnmatch(entry, pattern):
    list_grib.append(entry)
list_grib.sort()

data=None
if parallelRead == False:
  # pas de lecture parallele
  print('Lecture de fichier non parallele')
  for i,grib in enumerate(list_grib):
    DictExtract=readGrib(grib) # on recupere DictExtract["step"] et DictExtrat["data"]

    # Lors de la premiere lecture, on cree le tableau data avec les dimensions du premier fichier lu
    if data is None:
      data=np.zeros((len(list_grib),DictExtract["data"].shape[0],DictExtract["data"].shape[1]))
    ## A VERIFIER DictExtract[data] est une sequence
    data[i]=DictExtract["data"]

else:
  # lecture en parallele

  print('Lecture de fichier parallele')
  poolRead=mp.Pool(nbProcessRead)
  list_dico=poolRead.map(readGrib,list_grib)
  # on recupere une liste de dico "step" et "data"
  poolRead.close()

  # on cree le tableau data avec les dimensions du premier fichier lu
  data=np.zeros((len(list_dico),list_dico[0]["data"].shape[0],list_dico[0]["data"].shape[1]))
  for i,dico in enumerate(list_dico):
    data[i]=dico["data"]

#### Fin de la lecture ####
print("Fin de la lecture")
#np.save('data',data)

#### Calcul de la moyenne pour chaque echeance ####
if parallelCompute == False:
  print('Calcul de la moyenne directement via numpy')
  dataMean=np.nanmean(data,axis=(1,2))

else:
  print('Calcul de la moyenne parallele')
  dataMean=np.zeros(len(list_grib))
  poolCompute=mp.Pool(nbProcessCompute)
  result=poolCompute.map(nanmean2d,data)
  for i,m in enumerate(result):
    dataMean[i]=m
  poolCompute.close()  

#### Fin du calcul de moyennes ####

print(f"Moyennes par echeance: {dataMean}")

#soit 2 array avec stepArray et dataArray
#for each dataArray
#map(np.mean,dataArray) boucle sur le premier iterable

#soit 1 dico avec data["step"]=data
#for each data.keys()
#map(np.mean,data.values())
