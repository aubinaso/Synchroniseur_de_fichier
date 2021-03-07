
nb_lignes1=`wc -l $1 | cut -d' ' -f1`
nb_lignes2=`wc -l $2 | cut -d' ' -f1`

#echo $nb_lignes1

if [ $nb_lignes1 -eq $nb_lignes2 ]
	then
		indice_ligne=1
		while [ $indice_ligne -le $nb_lignes1 ]
			do
				ligne_fic1=`head -$indice_ligne $1 | tail -1`
				ligne_fic2=`head -$indice_ligne $2 | tail -1`
				if [ "$ligne_fic1" != "$ligne_fic2" ]
				then
				#	echo "les deux fichiers $1 $2 ne possedent pas le meme contenu"
			     		exit 1
			     	fi

			indice_ligne=$(( $indice_ligne +1))
			done
		#	echo "les fichiers ont le meme contenu"
			exit 2
else
#	echo "les fichiers ne possedent pas le meme contenu"
	exit 1
fi

#EXIT 2 --> CONTENU IDENTIQUE
#EXIT 1 --> CONTENU DIFFERENT
