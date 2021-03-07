#!/bin/bash


#CE SCRIPT RENVOI LE RESULTAT DE LA COMMANDE LS DANS UN FICHIER .txt

#resultat=`cat intermediaire.txt`	

ls -al $1 > intermediaire.txt

sed 's/  */ /g' intermediaire.txt | cut -d' ' -f9 > liste.txt
sed '1,3d' liste.txt > intermediaire.txt
sed '/^intermediaire.txt$/d' intermediaire.txt > liste.txt
sed '/^liste.txt$/d' liste.txt > intermediaire.txt
sed '/^.fich1.txt$/d' intermediaire.txt > liste.txt

cat liste.txt

rm -r intermediaire.txt liste.txt
	
