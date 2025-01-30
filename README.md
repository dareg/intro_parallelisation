# introduction-parallelisation


# TP d'introduction à la parallélisation (en Python)
Ce TP est préparé dans le cadre de la formation initiale TSM mais peut être repris dans un autre contre.
Son objectif est de présenter et d'illustrer les notions mises en oeuvre lorsque l'on souhaite paralléliser une tâche sur PC/serveur/super-calculateur.
Quelques rappels sur le fonctionnement d'un processeur et des processus sous Linux sont réalisés en introduction.
Pour rester sur une environnement facile à prendre en main, le TP est réalisé en Python en utilisant la librairie Multiprocessing.

## Contenu du dépôt
- [ ] IntroductionParallelisation.odp: Support de présentation
- [ ] 


## Environnement nécessaire
Lancer le script install.sh du dépôt git pour installer l'environnement et télécharger les données.
Ensuite il faut charger l'environnement virtuel python pour lancer le script main.py : source venv/bin/activate.

- [ ] Python 3.x
- [ ] EcCodes doit être installé
- [ ] Librairies Python: Numpy, Xarray et cfgrib (à installer via un pip install cfgrib sur les PC de l'ENM)
- [ ] Commandes Linux tar et curl pour récupérer les données
- [ ] Un accès internet vers nextcloud.meteo.fr

## Contenu du TP
Pour réaliser ce TP d'introduction à la parallélisation nous allons "juste" calculer la moyenne des champs de températures à 2m  pour l'ensemble des 52 échéances d'un réseau AROME.
Les fichiers grib de prévision AROME ont déjà été extraits et sont disponibles sur nextcloud (voir en dessous).

Pour calculer ces moyennes nous allons:
- lire chaque fichier GRIB grâce à la librairie xarray pour obtenir des DataSets puis Numpy Array. Chaque Numpy Array contient les valeurs de températures sur la grille EURW1S100.
- construire un seul Numpy Array avec tous les échéances
- calculer la moyenne sur chaque échéance

La librairie de parallélisation Python utilisée est Multiprocessing qui fait partie des librairies standards de Python.
Multiprocessing est utilisé pour paralléliser la lecture de fichier et/ou le calcul des moyennes.
L'activation de la parallélisation se fait à travers les 2 booléens "parallelRead" et "parallelCompute". Le nombre de processus parallèles utilisés peut être adapté via les valeurs "nbProcessRead" et "nbProcessCompute".

## Téléchargement des données AROME pour le TP
Pour ne pas occuper de la place sur newton, on dépose les fichiers AROME sur le disque local de la machine (/tmp).
```
mkdir /tmp/data
cd /tmp/data
curl -X GET -k -o data.tgz "https://nextcloud.meteo.fr/s/DE33Ds9jjjoCco3/download?path=%2FIntroduction-parallelisation&files=data_introduction-parallelisation.tgz"
tar -xvzf data.tgz
rm -f data.tgz
```

## Comment connaître le nombre de processeur sur la machine ?
```
cat /proc/cpuinfo | grep -i "^processor" | wc -l
```

## Mesurer le temps d'exécution et la consommation mémoire d'une commande
```
/usr/bin/time {commande}
```
- user: le temps CPU utilisé par la commande hors appels système, en cas de parallélisation nous avons la somme sur l'ensemble des CPU
- system: le temps CPU utilisé pour des appels systèmes (accès disque par exemple)
- elasped: la durée d'exécution de la commande
- CPU: le taux d'occupation des processeurs par la commande, une valeur supérieure à 100% indique que la commande a été parallélisée
- maxresident: la consommation mémoire maximum du processus au cours de son exécution

Exemple pour main.py
```
/usr/bin/time python3 main.py
Lecture de fichier parallele
Lecture du fichier /tmp/data/T.eurw1s100_00h.grib
[...]
Fin de la lecture
Calcul de la moyenne parallele
Moyennes par echeance:
[...]
220.44user 33.95system 0:31.39elapsed 810%CPU (0avgtext+0avgdata 3362524maxresident)k
0inputs+16outputs (3major+13510326minor)pagefaults 0swaps
```
La commande a mis 31.39 secondes a s'exécuter.
Comme la parallélisation était activé nous avons une occupation CPU supérieure à 100% (810%), et le "temps CPU intégré" côté utilisateur (220.44sec) est supérieur à la durée de la commande. Les 33.95sec du systèmes sont liés à la lecture des fichiers sur disque.
Dans cette configuration la commande a utilisé au maximum 3362524 ko de mémoire RAM.
