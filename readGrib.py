import xarray as xr
import numpy as np

def readGrib(file):
  print(f"Lecture du fichier {file}")
  x=xr.open_dataset(file,engine='cfgrib',backend_kwargs={"indexpath":""})
  param=[i for i in x.data_vars]
  dico=dict()
  # le step est en nano-seconde, on le convertit en heure
  dico["step"]=str(x[param[0]].step/np.timedelta64(1,'h'))
  dico["data"]=x[param[0]].values
  return dico
