#!/bin/bash

#COMPARAISON DU NOMBRE DE PARAMETRES
#$arg3=fichier p_A
#$arg4=fichier p_B
#$path=$2 est le path des fichier étant déjà dans un des dossier initiaux à comparer (p_A ou p_B)


if test $# -ne 4
then
#	echo "il faut 4 paramètres"
	 arg3=$2
	 arg4=$3
	 arg4=''
else
	 arg3=$3
	 arg4=$4
fi
if [ -z $2 ]
then
	path=$1
else
#	echo "le paramètre 4 est non vide il vaut $4"
#	echo "1=$1 2=$2 3=$3 4=$4"
	path=$2'/'$1
fi

#COMAPAISON DES DOSSIERS

#REDIRECTION DES LISTES 
./liste_fichier.sh $arg3'/'$path > $arg3'/'$path'/.fich1'

./liste_fichier.sh $arg4'/'$path > $arg4'/'$path'/.fich1'

#COMPARE CONTENU
./compare_contenu.sh $arg3'/'$path'/.fich1' $arg4'/'$path'/.fich1'

retour=`echo $?` #exit de compare_contenu

#SI IDENTIQUES

if [ $retour -eq 2 ]
then
	while read ligne
	do
	path2=`echo $path | sed 's/\//:/g'`	
	present=`cat .journal | grep $arg3':'$path2':'$ligne'$'`
	droit=`ls -ld $arg3'/'$path'/'$ligne | awk -F' ' '{print$1}' | sed 's/^.\(.*\)$/\1/g'`
	./compare_metadonnees.sh $droit
	droit1=`cat .droit-acc`
	droit=`ls -ld $arg4'/'$path'/'$ligne | awk -F' ' '{print$1}' | sed 's/^.\(.*\)$/\1/g'`
	./compare_metadonnees.sh $droit
	droit2=`cat .droit-acc`
	rm -r .droit-acc
	proprio1=`ls -ld $arg3'/'$path'/'$ligne | awk -F' ' '{print$3}'`
	proprio2=`ls -ld $arg4'/'$path'/'$ligne | awk -F' ' '{print$3}'`
	groupe1=`ls -ld $arg3'/'$path'/'$ligne | awk -F' ' '{print$4}'`
	groupe2=`ls -ld $arg4'/'$path'/'$ligne | awk -F' ' '{print$4}'`
	date1=`ls -ld $arg3'/'$path'/'$ligne | awk -F' ' '{printf$7" "$6" "$8}' | sed -f gestion_heure.sh`	
	date=`echo $date1 | sed 's/ /:/g'`
	date1=$date
	date2=`ls -ld $arg4'/'$path'/'$ligne | awk -F' ' '{printf$7" "$6" "$8}' | sed -f gestion_heure.sh`	
	date=`echo $date2 | sed 's/ /:/g'`
	date2=$date

	if test "$groupe1" != "$groupe2"
	then
		if  [ -z "$present" ]
		then
			./compare_date.sh $date1 $date2
			if test $? -eq 1
			then
				sudo chgrp $groupe1 $arg4'/'$path'/'$ligne
			else
				sudo chgrp $groupe2 $arg3'/'$path'/'$ligne
				remplacement=`ls -ld $arg3'/'$path'/'$ligne | sed 's/\//:/g'`
				sed -i "s/^.*$path3:$path2:$ligne$/$remplacement/g" .journal
			fi
		else
			groupe_journal=`cat .journal | grep $path3':'$path2':'$ligne'$' | awk -F' ' '{printf$4}'`	
			if test "$groupe1" == "$groupe_journal"
			then
				sudo chgrp $groupe2 $arg3'/'$path'/'$ligne
				remplacement=`ls -ld $arg3'/'$path'/'$ligne | sed 's/\//:/g'`
				sed -i "s/^.*$path3:$path2:$ligne$/$remplacement/g" .journal
			elif test "$groupe2" == "$groupe_journal"
			then
				sudo chgrp $groupe1 $arg4'/'$path'/'$ligne
			else
				./compare_date.sh $date1 $date2
				if test $? -eq 1
				then
					sudo chgrp $groupe1 $arg4'/'$path'/'$ligne
				else
					sudo chgrp $groupe2 $arg3'/'$path'/'$ligne
					remplacement=`ls -ld $arg3'/'$path'/'$ligne | sed 's/\//:/g'`
					sed -i "s/^.*$path3:$path2:$ligne$/$remplacement/g" .journal
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
				sudo chown $proprio1 $arg4'/'$path'/'$ligne
			else
				sudo chown $proprio2 $arg3'/'$path'/'$ligne
				remplacement=`ls -ld $arg3'/'$path'/'$ligne | sed 's/\//:/g'`
				sed -i "s/^.*$path3:$path2:$ligne$/$remplacement/g" .journal
			fi
		else
			proprio_journal=`cat .journal | grep $path3':'$path2':'$ligne'$' | awk -F' ' '{printf$3}'`	
			if test "$proprio1" == "$proprio_journal"
			then
				sudo chown $proprio2 $arg3'/'$path'/'$ligne
				remplacement=`ls -ld $arg3'/'$path'/'$ligne | sed 's/\//:/g'`
				sed -i "s/^.*$path3:$path2:$ligne$/$remplacement/g" .journal
			elif test "$proprio2" == "$proprio_journal"
			then
				sudo chown $proprio1 $arg4'/'$path'/'$ligne
			else
				./compare_date.sh $date1 $date2
				if test $? -eq 1
				then
					sudo chown $proprio1 $arg4'/'$path'/'$ligne
				else
					sudo chown $proprio2 $arg3'/'$path'/'$ligne
					remplacement=`ls -ld $arg3'/'$path'/'$ligne | sed 's/\//:/g'`
					sed -i "s/^.*$path3:$path2:$ligne$/$remplacement/g" .journal
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
				sudo chmod $droit1 $arg4'/'$path'/'$ligne
			else
				sudo chmod $droit2 $arg3'/'$path'/'$ligne
				remplacement=`ls -ld $arg3'/'$path'/'$ligne | sed 's/\//:/g'`
				sed -i "s/^.*$path3:$path2:$ligne$/$remplacement/g" .journal
			fi
		else
			droit=`cat .journal | grep $path3':'$path2':'$ligne'$' | awk -F' ' '{print$1}' | sed 's/^.\(.*\)$/\1/g'`
			./compare_metadonnees.sh $droit
			droit_journal=`cat .droit-acc`	
			rm -r .droit-acc
			if test "$droit1" == "$droit_journal"
			then
				sudo chmod $droit2 $arg3'/'$path'/'$ligne
				remplacement=`ls -ld $arg3'/'$path'/'$ligne | sed 's/\//:/g'`
				sed -i "s/^.*$path3:$path2:$ligne$/$remplacement/g" .journal
			elif test "$droit2" == "$droit_journal"
			then
				sudo chmod $droit1 $arg4'/'$path'/'$ligne
			else
				./compare_date.sh $date1 $date2
				if test $? -eq 1
				then
					sudo chmod $droit1 $arg4'/'$path'/'$ligne
				else
					sudo chmod $droit2 $arg3'/'$path'/'$ligne
					remplacement=`ls -ld $arg3'/'$path'/'$ligne | sed 's/\//:/g'`
					sed -i "s/^.*$path3:$path2:$ligne$/$remplacement/g" .journal
				fi
			fi
		fi
	fi


	if [ -z "$present" ]
	then	
		ls -ld $arg3'/'$path'/'$ligne | sed 's/\//:/g' | sed 's/  */\t/g' >> .journal
	fi
	
	date_journal=`cat .journal | grep $path3':'$path2':'$ligne'$' | awk -F' ' '{printf$7" "$6" "$8}' | sed -f gestion_heure.sh`	
	date=`echo $date_journal | sed 's/ /:/g'`
	date_journal=$date
	./compare_type.sh $arg3'/'$path'/'$ligne
	type1=`echo $?`	
	
	./compare_type.sh $arg4'/'$path'/'$ligne
	type2=`echo $?`

	if [ $type1 -eq $type2 ]
	then
		if [ $type1 -eq 1 ]
		then	
			#echo "comparaison des contenus de $arg3/$path/$ligne et $4/$path/$ligne"
                	./compare_contenu.sh $arg3'/'$path'/'$ligne $arg4'/'$path'/'$ligne
			if [ $? -eq 1 ]
			then
				#	./plus_recent.sh $path1'/'$ligne $path2'/'$ligne
				date_journal=`cat .journal | grep $path3':'$path2':'$ligne'$' | awk -F' ' '{printf$7" "$6" "$8}' | sed -f gestion_heure.sh`	
				
				date=`echo $date_journal | sed 's/ /:/g'`
				date_journal=$date
				date1=`ls -ld $arg3'/'$path'/'$ligne | awk -F' ' '{printf$7" "$6" "$8}' | sed -f gestion_heure.sh`	
				
				date=`echo $date1 | sed 's/ /:/g'`
				date1=$date
				date2=`ls -ld $arg4'/'$path'/'$ligne | awk -F' ' '{printf$7" "$6" "$8}' | sed -f gestion_heure.sh`	
				date=`echo $date2 | sed 's/ /:/g'`
				date2=$date
				
				#COMPARAISON DE DATE EN FONCTION DE DATE JOURNAL
				./compare_date.sh $date_journal $date1
				a_jour1=$?
				./compare_date.sh $date_journal $date2
				a_jour2=$?
	
				if [ "$a_jour1" -eq "$a_jour2" ]
				then
					echo ""
					echo "la difference entre les fichiers $arg3/$path/$ligne et $arg4/$path/$ligne est la suivante: pensez à réajuster les contenu"
					echo "----------------------------------"
					sudo diff $arg3'/'$path'/'$ligne $arg4'/'$path'/'$ligne #| sed -e 's/^</'$arg3'...'$ligne' </g' -e 's/^>/'$arg4'...'$ligne' >/g'
					echo "----------------------------------"


					./compare_date.sh $date1 $date2		
					choix=$?
					if [ $choix -eq 1 ]
					then
						#COPIE DE $arg3... dans $arg4 ET MISE A JOUR DU JOURNAL
						sudo cp $arg3'/'$path'/'$ligne $arg4'/'$path'/'$ligne
						sudo cp $arg4'/'$path'/'$ligne $arg3'/'$path'/'$ligne
						remplacement=`ls -ld $arg3'/'$path'/'$ligne | sed 's/\//:/g'`
						sed -i "s/^.*$path3:$path2:$ligne$/$remplacement/g" .journal
					elif [ $choix -eq 2 ]
					then
						#COPIE DE $arg4... dans $arg3 et MISE A JOUR DU JOURNAL
						sudo cp $arg4'/'$path'/'$ligne $arg3'/'$path'/'$ligne
						sudo cp $arg3'/'$path'/'$ligne $arg4'/'$path'/'$ligne
						remplacement=`ls -ld $arg3'/'$path'/'$ligne | sed 's/\//:/g'`
						sed -i "s/^.*$path3:$path2:$ligne$/$remplacement/g" .journal
					else
						#DIFFERENCE ENTRE LES FICHIERS 
						echo ""
						echo "Nous avons mis les différences du fichier $arg4/$path/$ligne dans $arg3/$path/$ligne"
						echo ""
						sudo cat -n $arg4'/'$path'/'$ligne > .fich4.txt
						sudo cat -n $arg3'/'$path'/'$ligne > .fich3.txt
						diff .fich4.txt .fich3.txt > .difference1.txt
						rm .fich4.txt .fich3.txt
						sed '/^[^><]/d' .difference1.txt > .difference.txt
						rm .difference1.txt
						#CONTENU QUE POSSEDE fich1 et non fich2
						sed -e 's/^< \(.*\)$/\1/g' -e '/^>.*/d' .difference.txt  > .difference_fich1.txt
						rm .difference.txt
						cat .difference_fich1.txt >> $arg3'/'$path'/'$ligne
						sudo cp $arg3'/'$path'/'$ligne $arg4'/'$path'/'$ligne
						sudo cp $arg4'/'$path'/'$ligne $arg3'/'$path'/'$ligne
						remplacement=`ls -ld $arg3'/'$path'/'$ligne | sed 's/\//:/g'`
						sed -i "s/^.*$path3:$path2:$ligne$/$remplacement/g" .journal
						rm .difference_fich1.txt
					fi
				#IF path1/ligne est plus recent
				else
					#ils n'ont pas la même date de dernière modification
					if test $a_jour1 -eq 0
					then
						#le fichier 1 est conforme au fichier journal
						sudo cp $arg4'/'$path'/'$ligne $arg3'/'$path'/'$ligne
						sudo cp $arg3'/'$path'/'$ligne $arg4'/'$path'/'$ligne
						remplacement=`ls -ld $arg3'/'$path'/'$ligne | sed 's/\//:/g'`
						sed -i "s/^.*$path3:$path2:$ligne$/$remplacement/g" .journal
					else
						#le fichier 2 est conforme au fichier journal
						sudo cp $arg3'/'$path'/'$ligne $arg4'/'$path'/'$ligne
						sudo cp $arg4'/'$path'/'$ligne $arg3'/'$path'/'$ligne
						remplacement=`ls -ld $arg3'/'$path'/'$ligne | sed 's/\//:/g'`
						sed -i "s/^.*$path3:$path2:$ligne$/$remplacement/g" .journal
					fi
				fi
			fi

		else
			if test -z "$path"
			then
				./compare_dossier.sh "$ligne" '' "$arg3" "$arg4"
			else
				./compare_dossier.sh "$ligne" "$path" "$arg3" "$arg4"
			fi
		fi

	else
		if [ $type1 -eq 1 ]
		then
				./compare_date.sh $date1 $date2
				recent=$?
			if test $recent -eq 1
			then
				sudo rm -r $arg4'/'$path'/'$ligne 
				sudo cp $arg3'/'$path'/'$ligne $arg4'/'$path'/'$ligne
				sudo rm -r $arg3'/'$path'/'$ligne 
				sudo cp $arg4'/'$path'/'$ligne $arg3'/'$path'/'$ligne
				sudo chown $proprio1 $arg4'/'$path'/'$ligne
				sudo chown $proprio1 $arg3'/'$path'/'$ligne
				sudo chgrp $groupe1 $arg4'/'$path'/'$ligne
				sudo chgrp $groupe1 $arg3'/'$path'/'$ligne
				sudo chmod $droit1 $arg4'/'$path'/'$ligne
				sudo chmod $droit1 $arg3'/'$path'/'$ligne
				remplacement=`ls -ld $arg3'/'$path'/'$ligne | sed 's/\//:/g'`
				sed -i "s/^.*$path3:$path2:$ligne$/$remplacement/g" .journal
			else
				sudo rm -r $arg3'/'$path'/'$ligne 
				sudo cp -r $arg4'/'$path'/'$ligne $arg3'/'$path'/'$ligne
				sudo rm -r $arg4'/'$path'/'$ligne 
				sudo cp -r $arg3'/'$path'/'$ligne $arg4'/'$path'/'$ligne
				sudo chown $proprio2 $arg3'/'$path'/'$ligne
				sudo chown $proprio2 $arg4'/'$path'/'$ligne
				sudo chgrp $groupe2 $arg3'/'$path'/'$ligne
				sudo chgrp $groupe2 $arg4'/'$path'/'$ligne
				sudo chmod $droit2 $arg3'/'$path'/'$ligne
				sudo chmod $droit2 $arg4'/'$path'/'$ligne
				remplacement=`ls -ld $arg3'/'$path'/'$ligne | sed 's/\//:/g'`
				sed -i "s/^.*$path3:$path2:$ligne$/$remplacement/g" .journal
			fi
		else
			./compare_date.sh $date1 $date2
			recent=$?
			if test $recent -eq 1
			then
				sudo rm -r $arg4'/'$path'/'$ligne 
				sudo cp -r $arg3'/'$path'/'$ligne $arg4'/'$path'/'$ligne
				sudo rm -r $arg3'/'$path'/'$ligne 
				sudo cp -r $arg4'/'$path'/'$ligne $arg3'/'$path'/'$ligne
				sudo chown $proprio1 $arg4'/'$path'/'$ligne
				sudo chown $proprio1 $arg3'/'$path'/'$ligne
				sudo chgrp $groupe1 $arg4'/'$path'/'$ligne
				sudo chgrp $groupe1 $arg3'/'$path'/'$ligne
				sudo chmod $droit1 $arg4'/'$path'/'$ligne
				sudo chmod $droit1 $arg3'/'$path'/'$ligne
				remplacement=`ls -ld $arg3'/'$path'/'$ligne | sed 's/\//:/g'`
				sed -i "s/^.*$path3:$path2:$ligne$/$remplacement/g" .journal
			else
				sudo rm -r $arg3'/'$path'/'$ligne 
				sudo cp -r $arg4'/'$path'/'$ligne $arg3'/'$path'/'$ligne
				sudo rm -r $arg4'/'$path'/'$ligne 
				sudo cp -r $arg3'/'$path'/'$ligne $arg4'/'$path'/'$ligne
				sudo chown $proprio2 $arg3'/'$path'/'$ligne
				sudo chown $proprio2 $arg4'/'$path'/'$ligne
				sudo chgrp $groupe2 $arg3'/'$path'/'$ligne
				sudo chgrp $groupe2 $arg4'/'$path'/'$ligne
				sudo chmod $droit2 $arg3'/'$path'/'$ligne
				sudo chmod $droit2 $arg4'/'$path'/'$ligne
				remplacement=`ls -ld $arg3'/'$path'/'$ligne | sed 's/\//:/g'`
				sed -i "s/^.*$path3:$path2:$ligne$/$remplacement/g" .journal
			fi
		fi
	fi

	done<$arg3'/'$path'/.fich1'
	rm $arg3'/'$path'/.fich1'
	rm $arg4'/'$path'/.fich1'
else

	#DIFFERENCE ENTRE LES FICHIERS 
	sudo diff $arg3'/'$path'/.fich1' $arg4'/'$path'/.fich1' > .difference1.txt
	sed '/^[^><]/d' .difference1.txt > .difference.txt
	rm -r .difference1.txt $arg3'/'$path'/.fich1' $arg4'/'$path'/.fich1'

	#CONTENU QUE POSSEDE fich2 et non fich1
	sed -e 's/^> \(.*\)$/\1/g' -e '/^<.*/d' .difference.txt | sed 's/^> //g' > .difference_fich2.txt 2>/dev/null
	cat .difference_fich2.txt

	#CONTENU QUE POSSEDE fich1 et non fich2
	sed 's/^< \(.*\)$/\1/g' -e '/^>.*/d' .difference.txt | sed 's/^< //g' > .difference_fich1.txt 2>/dev/null
	cat .difference_fich1.txt
	
	path2=`echo $path | sed 's/\//:/g'`	
	rm -r .difference.txt
	while read ligne
	do
		present=`cat .journal | grep $arg3':'$path2':'$ligne'$'`
		if [ -z "$present" ]
		then
			sudo cp -r $arg4'/'$path'/'$ligne $arg3'/'$path'/'$ligne
			sudo rm -r $arg4'/'$path'/'$ligne
			sudo cp -r $arg3'/'$path'/'$ligne $arg4'/'$path'/'$ligne
			remplacement=`ls -ld $arg3'/'$path'/'$ligne | sed 's/\//:/g'`
			echo  "$remplacement" >> .journal
		else
			sudo rm -r $arg4'/'$path'/'$ligne
			sed -i "/^.*$path3:$path2:$ligne$/d" .journal
		fi
	done<.difference_fich2.txt
	while read ligne
	do 
		present=`cat .journal | grep $arg3':'$path2':'$ligne'$'`
		if [ -z "$present" ]
		then
			sudo cp -r $arg3'/'$path'/'$ligne $arg4'/'$path'/'$ligne
			sudo rm -r $arg3'/'$path'/'$ligne
			sudo cp -r $arg4'/'$path'/'$ligne $arg3'/'$path'/'$ligne
			remplacement=`ls -ld $arg3'/'$path'/'$ligne | sed 's/\//:/g'`
			echo  "$remplacement" >> .journal
		else
			sudo rm -r $arg3'/'$path'/'$ligne
			sed -i "/^.*$path3:$path2:$ligne$/d" .journal
		fi
	done<.difference_fich1.txt
	if [ -e .difference_fich1.txt ]
	then
		rm -r .difference_fich1.txt 
	fi
	if [ -e .difference_fich2.txt ]
	then
		rm -r .difference_fich2.tx
	fi

	
	./compare_dossier.sh $1 $2 $arg3 $arg4
fi
exit 0


