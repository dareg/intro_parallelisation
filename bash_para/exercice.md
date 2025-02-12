# Parallélisation avec bash

Téléchargez toutes les images du dossier imagesoftheday sur votre PC

Faire un script qui:
- Converti les fichiers png en fichier jpg (à l'aide de la commande convert)
- Ne garde que la date dans le nom du fichier
- Déplace toutes les images jpg dans un dossier nommé png
- Crée un fichier tar.gz de ce dossier

Mesurer le temps pris par ce script

Faites une copie du script et modifier tel que:
- les conversion de png vers jpg soit faites en parallèle
- le script ne quitte que lorsque toutes les conversions sont terminés

Mesurer le temps pris et le comparer avec la solution séquentielle
