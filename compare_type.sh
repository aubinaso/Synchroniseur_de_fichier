#!/bin/bash

#AFFICHE LE TYPE DU FICHIER EN PARAM


if [ -e $1 ]
then
	if [ -d $1 ]
	then
		exit 0
	else
		exit 1
	fi
else
	exit 2
fi

# exit 0 --> dossier
# exit 1 --> fichier
# exit 2 --> n'existe pas
