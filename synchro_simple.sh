#!/bin/bash

#COMPARAISON DU NOMBRE DE PARAMETRES
#$3=fichier p_A
#$4=fichier p_B
#$path=$2 est le path des fichier étant déjà dans un des dossier initiaux à comparer (p_A ou p_B)

if [ ! -e .journal ]
then 
	touch .journal
fi

if [ $# -eq 2 ]
then
	path=""
	present=`cat .journal | grep ' '$1'$'`
	if [ -z "$present" ]
	then 
		ls -ld $1 | sed 's/  */\t/g' | sed 's/\//:/g' >> .journal
	fi
	present=`cat .journal | grep ' '$2'$'`
	if [ -z "$present" ]
	then
		ls -ld $2 | sed 's/  */\t/g' | sed 's/\//:/g' >> .journal
	fi
else
	exit 1
fi


#COMPARAISON METADONNEES 
	droit=`ls -ld $1 | awk -F' ' '{print$1}' | sed 's/^.\(.*\)$/\1/g'`
	./compare_metadonnees.sh $droit
	droit1=`cat .droit-acc`
	droit=`ls -ld $2 | awk -F' ' '{print$1}' | sed 's/^.\(.*\)$/\1/g'`
	./compare_metadonnees.sh $droit
	droit2=`cat .droit-acc`
	rm -r .droit-acc
	proprio1=`ls -ld $1 | awk -F' ' '{print$3}'`
	proprio2=`ls -ld $2 | awk -F' ' '{print$3}'`
	groupe1=`ls -ld $1 | awk -F' ' '{print$4}'`
	groupe2=`ls -ld $2 | awk -F' ' '{print$4}'`
	date1=`ls -ld $1 | awk -F' ' '{printf$7" "$6" "$8}' | sed -f gestion_heure.sh`	
	date2=`ls -ld $2 | awk -F' ' '{printf$7" "$6" "$8}' | sed -f gestion_heure.sh`	

	if test "$groupe1" != "$groupe2"
	then
		groupe_journal=`cat .journal | grep $path3':'$ligne'$' | awk -F' ' '{printf$4}'`	
		if test "$groupe1" == "$groupe_journal"
		then
			sudo chgrp $groupe2 $1'/'$ligne
			remplacement=`ls -ld $1'/'$ligne | sed 's/\//:/g'`
			sed -i "s/.* $path3:$ligne$/$remplacement/g".journal
		elif test "$groupe2" == "$groupe_journal"
		then
			sudo chgrp $groupe1 $2'/'$ligne
		else
			./compare_date.sh $date1 $date2
			if test $? -eq 1
			then
				sudo chgrp $groupe1 $2'/'$ligne
			else
				sudo chgrp $groupe2 $1'/'$ligne
				remplacement=`ls -ld $1'/'$ligne | sed 's/\//:/g'`
				sed -i "s/.* $path3:$ligne$/$remplacement/g".journal
			fi
		fi
	fi
	if test "$proprio1" != "$proprio2"
	then
		proprio_journal=`cat .journal | grep $path3':'$ligne'$' | awk -F' ' '{printf$3}'`	
		if test "$proprio1" == "$proprio_journal"
		then
			sudo chown $proprio2 $1'/'$ligne
			remplacement=`ls -ld $1'/'$ligne | sed 's/\//:/g'`
			sed -i "s/.* $path3:$ligne$/$remplacement/g".journal
		elif test "$proprio2" == "$proprio_journal"
		then
			sudo chown $proprio1 $2'/'$ligne
		else
			./compare_date.sh $date1 $date2
			if test $? -eq 1
			then
				sudo chown $proprio1 $2'/'$ligne
			else
				sudo chown $proprio2 $1'/'$ligne
				remplacement=`ls -ld $1'/'$ligne | sed 's/\//:/g'`
				sed -i "s/.* $path3:$ligne$/$remplacement/g".journal
			fi
		fi
	fi
	if test $droit1 -ne $droit2
	then
		droit=`cat .journal | grep $path3':'$ligne'$' | awk -F' ' '{print$1}' | sed 's/^.\(.*\)$/\1/g'`
		./compare_metadonnees.sh $droit
		droit_journal=`cat .droit-acc`	
		rm -r .droit-acc
		if test "$droit1" == "$droit_journal"
		then
			sudo chmod $droit2 $1'/'$ligne
			remplacement=`ls -ld $1'/'$ligne | sed 's/\//:/g'`
			sed -i "s/.* $path3:$ligne$/$remplacement/g".journal
		elif test "$droit2" == "$droit_journal"
		then
			sudo chmod $droit1 $2'/'$ligne
		else
			./compare_date.sh $date1 $date2
			if test $? -eq 1
			then
				sudo chmod $droit1 $2'/'$ligne
			else
				sudo chmod $droit2 $1'/'$ligne
				remplacement=`ls -ld $1'/'$ligne | sed 's/\//:/g'`
				sed -i "s/.* $path3:$ligne$/$remplacement/g".journal
			fi
		fi
	fi

path3=`echo $1 | sed 's/\//:/g'`




#COMAPAISON DES DOSSIERS

#REDIRECTION DES LISTES 
./liste_fichier.sh $1 > $1'/.fich1'

./liste_fichier.sh $2 > $2'/.fich1'

#COMPARE CONTENU
./compare_contenu.sh $1'/.fich1' $2'/.fich1'

retour=`echo $?` #exit de compare_contenu

#SI IDENTIQUES

if [ $retour -eq 2 ]
then
	while read ligne
	do
	path2=`echo $path | sed 's/\//:/g'`	
	present=`cat .journal | grep $1':'$ligne'$'`
	droit=`ls -ld $1'/'$ligne | awk -F' ' '{print$1}' | sed 's/^.\(.*\)$/\1/g'`
	./compare_metadonnees.sh $droit
	droit1=`cat .droit-acc`
	droit=`ls -ld $2'/'$ligne | awk -F' ' '{print$1}' | sed 's/^.\(.*\)$/\1/g'`
	./compare_metadonnees.sh $droit
	droit2=`cat .droit-acc`
	rm -r .droit-acc
	proprio1=`ls -ld $1'/'$ligne | awk -F' ' '{print$3}'`
	proprio2=`ls -ld $2'/'$ligne | awk -F' ' '{print$3}'`
	groupe1=`ls -ld $1'/'$ligne | awk -F' ' '{print$4}'`
	groupe2=`ls -ld $2'/'$ligne | awk -F' ' '{print$4}'`
	date1=`ls -ld $1'/'$ligne | awk -F' ' '{printf$7" "$6" "$8}' | sed -f gestion_heure.sh`	
	date2=`ls -ld $2'/'$ligne | awk -F' ' '{printf$7" "$6" "$8}' | sed -f gestion_heure.sh`	

	if test "$groupe1" != "$groupe2"
	then
		if  [ -z "$present" ]
		then
			./compare_date.sh $date1 $date2
			if test $? -eq 1
			then
				sudo chgrp $groupe1 $2'/'$ligne
			else
				sudo chgrp $groupe2 $1'/'$ligne
				remplacement=`ls -ld $1'/'$ligne | sed 's/\//:/g'`
				sed -i "s/.* $path3:$ligne$/$remplacement/g".journal
			fi
		else
			groupe_journal=`cat .journal | grep $path3':'$ligne'$' | awk -F' ' '{printf$4}'`	
			if test "$groupe1" == "$groupe_journal"
			then
				sudo chgrp $groupe2 $1'/'$ligne
				remplacement=`ls -ld $1'/'$ligne | sed 's/\//:/g'`
				sed -i "s/.* $path3:$ligne$/$remplacement/g".journal
			elif test "$groupe2" == "$groupe_journal"
			then
				sudo chgrp $groupe1 $2'/'$ligne
			else
				./compare_date.sh $date1 $date2
				if test $? -eq 1
				then
					sudo chgrp $groupe1 $2'/'$ligne
				else
					sudo chgrp $groupe2 $1'/'$ligne
					remplacement=`ls -ld $1'/'$ligne | sed 's/\//:/g'`
					sed -i "s/.* $path3:$ligne$/$remplacement/g".journal
				fi
			fi
		fi

	fi
	if test "$proprio1" != "$proprio2"
	then
		if  [ -z "$present" ]
		then
			./compare_date.sh $date1 $date2
			if test $? -eq 1
			then
				sudo chown $proprio1 $2'/'$ligne
			else
				sudo chown $proprio2 $1'/'$ligne
				remplacement=`ls -ld $1'/'$ligne | sed 's/\//:/g'`
				sed -i "s/.* $path3:$ligne$/$remplacement/g".journal
			fi
		else
			proprio_journal=`cat .journal | grep $path3':'$ligne'$' | awk -F' ' '{printf$3}'`	
			if test "$proprio1" == "$proprio_journal"
			then
				sudo chown $proprio2 $1'/'$ligne
				remplacement=`ls -ld $1'/'$ligne | sed 's/\//:/g'`
				sed -i "s/.* $path3:$ligne$/$remplacement/g".journal
			elif test "$proprio2" == "$proprio_journal"
			then
				sudo chown $proprio1 $2'/'$ligne
			else
				./compare_date.sh $date1 $date2
				if test $? -eq 1
				then
					sudo chown $proprio1 $2'/'$ligne
				else
					sudo chown $proprio2 $1'/'$ligne
					remplacement=`ls -ld $1'/'$ligne | sed 's/\//:/g'`
					sed -i "s/.* $path3:$ligne$/$remplacement/g".journal
				fi
			fi
		fi
	fi
	if test $droit1 -ne $droit2
	then
		if  [ -z "$present" ]
		then
			./compare_date.sh $date1 $date2
			if test $? -eq 1
			then
				sudo chmod $droit1 $2'/'$ligne
			else
				sudo chmod $droit2 $1'/'$ligne
				remplacement=`ls -ld $1'/'$ligne | sed 's/\//:/g'`
				sed -i "s/.* $path3:$ligne$/$remplacement/g".journal
			fi
		else
			droit=`cat .journal | grep $path3':'$ligne'$' | awk -F' ' '{print$1}' | sed 's/^.\(.*\)$/\1/g'`
			./compare_metadonnees.sh $droit
			droit_journal=`cat .droit-acc`	
			rm -r .droit-acc
			if test "$droit1" == "$droit_journal"
			then
				sudo chmod $droit2 $1'/'$ligne
				remplacement=`ls -ld $1'/'$ligne | sed 's/\//:/g'`
				sed -i "s/.* $path3:$ligne$/$remplacement/g".journal
			elif test "$droit2" == "$droit_journal"
			then
				sudo chmod $droit1 $2'/'$ligne
			else
				./compare_date.sh $date1 $date2
				if test $? -eq 1
				then
					sudo chmod $droit1 $2'/'$ligne
				else
					sudo chmod $droit2 $1h'/'$ligne
					remplacement=`ls -ld $1'/'$ligne | sed 's/\//:/g'`
					sed -i "s/.* $path3:$ligne$/$remplacement/g".journal
				fi
			fi
		fi
	fi


	if [ -z "$present" ]
	then	
		ls -ld $1'/'$ligne | sed 's/\//:/g' | sed 's/  */\t/g' >> .journal
	fi
	
	date_journal=`cat .journal | grep $path3':'$ligne'$' | awk -F' ' '{printf$7" "$6" "$8}' | sed -f gestion_heure.sh`	
	./compare_type.sh $1'/'$ligne
	type1=`echo $?`	
	
	./compare_type.sh $2'/'$ligne
	type2=`echo $?`

	if [ $type1 -eq $type2 ]
	then
		if [ $type1 -eq 1 ]
		then	
                	./compare_contenu.sh $1'/'$ligne $2'/'$ligne
			if [ $? -eq 1 ]
			then
				echo "Les fichiers $1/$ligne et $2/$ligne ne sont pas pareil"
				#	./plus_recent.sh $path1'/'$ligne $path2'/'$ligne
				date_journal=`cat .journal | grep $path3':'$ligne'$' | awk -F' ' '{printf$7" "$6" "$8}' | sed -f gestion_heure.sh`	
				date1=`ls -ld $1'/'$ligne | awk -F' ' '{printf$7" "$6" "$8}' | sed -f gestion_heure.sh`	
				date2=`ls -ld $2'/'$ligne | awk -F' ' '{printf$7" "$6" "$8}' | sed -f gestion_heure.sh`	

				#COMPARAISON DE DATE EN FONCTION DE DATE JOURNAL
				./compare_date.sh $date_journal $date1
				a_jour1=$?
				./compare_date.sh $date_journal $date2
				a_jour2=$?
	
				if [ "$a_jour1" -eq "$a_jour2" ]
				then
					echo "la difference entre les fichiers $1/$ligne et $2/$ligne est la suivante: pensez à réajuster les contenu"
					diff $1'/'$ligne $2'/'$ligne | sed -e 's/^</'$1'/'$ligne' </g' -e 's/^>/'$2'/'$ligne' >/g'
					echo "Veuillez selectionner le fichier dont vous voulez conserver les modifications:
					1. fichier $1/$ligne
					2. fichier $2/$ligne
					3. Ajouter la difference de $1/$ligne dans $2/$ligne
					4. Ajouter la difference de $2/$ligne dans $1/$ligne"

					i=0	
					while [ $i -eq 0 ]
					do
						read choix
						if [ $choix -lt 1 -o $choix -gt 4 ]
						then
							i=0
						else
							i=1
						fi
					done

					if [ $choix -eq 1 ]
					then
						#COPIE DE $3... dans $4 ET MISE A JOUR DU JOURNAL
						cp $1'/'$ligne $2'/'$ligne
						cp $2'/'$ligne $1'/'$ligne
						remplacement=`ls -ld $1'/'$ligne | sed 's/\//:/g'`
						sed -i "s/.* $path3:$ligne$/$remplacement/g".journal
					elif [ $choix -eq 2 ]
					then
						#COPIE DE $4... dans $3 et MISE A JOUR DU JOURNAL
						cp $2'/'$ligne $1'/'$ligne
						cp $1'/'$ligne $2'/'$ligne
						remplacement=`ls -ld $1'/'$ligne | sed 's/\//:/g'`
						sed -i "s/.* $path3:$ligne$/$remplacement/g" .journal
					elif [ $choix -eq 3 ]
					then
						#DIFFERENCE ENTRE LES FICHIERS 
						diff $1'/'$ligne $2'/'$ligne > difference1.txt
						sed '/^[^><]/d' difference1.txt > difference.txt
						rm -r difference1.txt

						#CONTENU QUE POSSEDE fich1 et non fich2
						sed -e 's/^< \(.*\)$/\1/g' -e '/^>.*/d' difference.txt  > difference_fich1.txt
						cat difference_fich1.txt >> $2'/'$ligne
						cp $2'/'$ligne $1'/'$ligne
						remplacement=`ls -ld $1'/'$ligne | sed 's/\//:/g'`
						sed -i "s/.* $path3:$ligne$/$remplacement/g".journal
						rm difference_fich1.txt
					else
						#DIFFERENCE ENTRE LES FICHIERS 
						diff $2'/'$ligne $1'/'$ligne > difference1.txt
						sed '/^[^><]/d' difference1.txt > difference.txt
						rm difference1.txt
						#CONTENU QUE POSSEDE fich1 et non fich2
						sed -e 's/^< \(.*\)$/\1/g' -e '/^>.*/d' difference.txt  > difference_fich1.txt
						cat difference_fich1.txt >> $1'/'$ligne
						cp $1'/'$ligne $2'/'$ligne
						remplacement=`ls -ld $1'/'$ligne | sed 's/\//:/g'`
						sed -i "s/.* $path3:$ligne$/$remplacement/g" .journal
						rm difference_fich1.txt
					fi
				#IF path1/ligne est plus recent
				else
					#ils n'ont pas la même date de dernière modification
					if test $a_jour1 -eq 0
					then
						#le fichier 1 est conforme au fichier journal
						cp $2'/'$ligne $1'/'$ligne
						cp $1'/'$ligne $2'/'$ligne
						remplacement=`ls -ld $1'/'$ligne | sed 's/\//:/g'`
						sed -i "s/.* $path3:$ligne$/$remplacement/g" .journal
					else
						#le fichier 2 est conforme au fichier journal
						cp $1'/'$ligne $2'/'$ligne
						cp $2'/'$ligne $1'/'$ligne
						remplacement=`ls -ld $1'/'$ligne | sed 's/\//:/g'`
						sed -i "s/.* $path3:$ligne$/$remplacement/g" .journal
					fi
				fi
			fi

		else
			if test -z $path
			then
				./compare_dossier.sh "$ligne" '' "$1" "$2"
			else
				./compare_dossier.sh "$ligne" "$path" "$1" "$2"
			fi
		fi

	else
		if [ $type -eq 1 ]
		then
				./compare_date.sh $date1 $date2
				recent=$?
			if test $recent -eq 1
			then
				rm -r $2'/'$ligne 
				touch $2'/'$ligne
				cp $1'/'$ligne $2'/'$ligne
				cp $2'/'$ligne $1'/'$ligne
				sudo chown $proprio1 $2'/'$ligne
				sudo chgrp $groupe1 $2'/'$ligne
				sudo chmod $droit1 $2'/'$ligne
				remplacement=`ls -ld $1'/'$ligne | sed 's/\//:/g'`
				sed -i "s/.* $path3:$ligne$/$remplacement/g".journal
			else
				rm -r $1'/'$ligne 
				touch $1'/'$ligne
				cp $2'/'$ligne $1'/'$ligne
				cp $1'/'$ligne $2'/'$ligne
				sudo chown $proprio2 $1'/'$ligne
				sudo chgrp $groupe2 $1'/'$ligne
				sudo chmod $droit2 $1'/'$ligne
				remplacement=`ls -ld $1'/'$ligne | sed 's/\//:/g'`
				sed -i "s/.* $path3:$ligne$/$remplacement/g".journal
			fi
		else
			./compare_date.sh $date1 $date2
			recent=$?
			if test $recent -eq 1
			then
				rm -r $2'/'$ligne 
				mkdir $2'/'$ligne
				cp -r $1'/'$ligne $2'/'$ligne
				cp -r $2'/'$ligne $1'/'$ligne
				sudo chown $proprio1 $2'/'$ligne
				sudo chgrp $groupe1 $2'/'$ligne
				sudo chmod $droit1 $2'/'$ligne
				remplacement=`ls -ld $1'/'$ligne | sed 's/\//:/g'`
				sed -i "s/.* $path3:$ligne$/$remplacement/g".journal
			else
				rm -r $1'/'$ligne 
				mkdir $1'/'$ligne
				cp -r $2'/'$ligne $1'/'$ligne
				cp -r $1'/'$ligne $2'/'$ligne
				sudo chown $proprio2 $1'/'$ligne
				sudo chgrp $groupe2 $1'/'$ligne
				sudo chmod $droit2 $1'/'$ligne
				remplacement=`ls -ld $1'/'$ligne | sed 's/\//:/g'`
				sed -i "s/.* $path3:$ligne$/$remplacement/g".journal
			fi
		fi
	fi

	done<$1'/.fich1'
	rm $1'/.fich1'
	rm $2'/.fich1'
else
	echo "Les dossiers $1 et $2 ne sont pas identique"

	#DIFFERENCE ENTRE LES FICHIERS 
	diff $1'/.fich1' $2'/.fich1' > .difference1.txt
	sed '/^[^><]/d' .difference1.txt > .difference.txt
	rm -r .difference1.txt $1'/.fich1' $2'/.fich1'

	#CONTENU QUE POSSEDE fich2 et non fich1
	sed -e 's/^> \(.*\)$/\1/g' -e '/^<.*/d' .difference.txt | sed 's/^> //g' > .difference_fich2.txt 2>/dev/null

	#CONTENU QUE POSSEDE fich1 et non fich2
	sed 's/^< \(.*\)$/\1/g' -e '/^>.*/d' .difference.txt | sed 's/^< //g' > .difference_fich1.txt 2>/dev/null
	rm -r .difference.txt
	while read ligne
	do
		present=`cat .journal | grep $path3':'$ligne'$'`
		if [ -z "$present" ]
		then
			cp -r $2'/'$ligne $1'/'$ligne
		else
			rm -r $2'/'$ligne
		fi
	done<.difference_fich2.txt
	while read ligne
	do 
		present=`cat .journal | grep $path3':'$ligne'$'`
		if [ -z "$present" ]
		then
			cp -r $1'/'$ligne $2'/'$ligne
		else
			rm -r $1'/'$ligne
		fi
	done<.difference_fich1.txt
	if test -e .difference_fich1.txt
	then
		rm -r .difference_fich1.txt 
	fi
	if test -e .difference_fich2.txt
	then
		rm -r .difference_fich2.txt
	fi	
	./synchro_simple.sh $1 $2
fi

echo "la synchronisation a réussi sans souci"
exit 0


