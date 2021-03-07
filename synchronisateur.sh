#!/bin/bash

#COMPARAISON DU NOMBRE DE PARAMETRES
#$3=fichier p_A
#$4=fichier p_B
#$path=$arg2 est le path des fichier étant déjà dans un des dossier initiaux à comparer (p_A ou p_B)

arg1=`echo $1 | sed 's/^\(.*\)\/$/\1/g'`
arg2=`echo $2 | sed 's/^\(.*\)\/$/\1/g'`

if [ ! -e .journal ]
then 
	touch .journal
fi

if [ $# -eq 2 ]
then
	path=""
	present=`cat .journal | grep $arg1'$'`
	if [ -z "$present" ]
	then 
		ls -ld $arg1 | sed 's/  */\t/g' | sed 's/\//:/g' >> .journal
	fi
	present=`cat .journal | grep $arg2'$'`
	if [ -z "$present" ]
	then
		ls -ld $arg2 | sed 's/  */\t/g' | sed 's/\//:/g' >> .journal
	fi
else
	exit 1
fi


#COMPARAISON METADONNEES 
	droit=`ls -ld $arg1 | awk -F' ' '{print$1}' | sed 's/^.\(.*\)$/\1/g'`
	./compare_metadonnees.sh $droit
	droit1=`cat .droit-acc`
	droit=`ls -ld $arg2 | awk -F' ' '{print$1}' | sed 's/^.\(.*\)$/\1/g'`
	./compare_metadonnees.sh $droit
	droit2=`cat .droit-acc`
	rm -r .droit-acc
	proprio1=`ls -ld $arg1 | awk -F' ' '{print$3}'`
	proprio2=`ls -ld $arg2 | awk -F' ' '{print$3}'`
	groupe1=`ls -ld $arg1 | awk -F' ' '{print$4}'`
	groupe2=`ls -ld $arg2 | awk -F' ' '{print$4}'`
	date1=`ls -ld $arg1 | awk -F' ' '{printf$7" "$6" "$8}' | sed -f gestion_heure.sh`	
	date=`echo $date1 | sed 's/ /:/g'`
	date1=$date
	date2=`ls -ld $arg2 | awk -F' ' '{printf$7" "$6" "$8}' | sed -f gestion_heure.sh`	
	date=`echo $date2 | sed 's/ /:/g'`
	date2=$date

	
	if test "$groupe1" != "$groupe2"
	then
		groupe_journal=`cat .journal | grep $path3':'$ligne'$' | awk -F' ' '{printf$4}'`	
		if test "$groupe1" == "$groupe_journal"
		then
			sudo chgrp $groupe2 $arg1'/'$ligne
			remplacement=`ls -ld $arg1'/'$ligne | sed 's/\//:/g'`
			sed -i "s/^.*$path3:$ligne$/$remplacement/g" .journal
		elif test "$groupe2" == "$groupe_journal"
		then
			sudo chgrp $groupe1 $arg2'/'$ligne
		else
			./compare_date.sh $date1 $date2
			if test $? -eq 1
			then
				sudo chgrp $groupe1 $arg2'/'$ligne
			else
				sudo chgrp $groupe2 $arg1'/'$ligne
				remplacement=`ls -ld $arg1'/'$ligne | sed 's/\//:/g'`
				sed -i "s/^.*$path3:$ligne$/$remplacement/g" .journal
			fi
		fi
	fi
	if test "$proprio1" != "$proprio2"
	then
		proprio_journal=`cat .journal | grep $path3':'$ligne'$' | awk -F' ' '{printf$3}'`	
		if test "$proprio1" == "$proprio_journal"
		then
			sudo chown $proprio2 $arg1'/'$ligne
			remplacement=`ls -ld $arg1'/'$ligne | sed 's/\//:/g'`
			sed -i "s/^.*$path3:$ligne$/$remplacement/g" .journal
		elif test "$proprio2" == "$proprio_journal"
		then
			sudo chown $proprio1 $arg2'/'$ligne
		else
			./compare_date.sh $date1 $date2
			if test $? -eq 1
			then
				sudo chown $proprio1 $arg2'/'$ligne
			else
				sudo chown $proprio2 $arg1'/'$ligne
				remplacement=`ls -ld $arg1'/'$ligne | sed 's/\//:/g'`
				sed -i "s/^.*$path3:$ligne$/$remplacement/g" .journal
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
			sudo chmod $droit2 $arg1'/'$ligne
			remplacement=`ls -ld $arg1'/'$ligne | sed 's/\//:/g'`
			sed -i "s/^.*$path3:$ligne$/$remplacement/g" .journal
		elif test "$droit2" == "$droit_journal"
		then
			sudo chmod $droit1 $arg2'/'$ligne
		else
			./compare_date.sh $date1 $date2
			if test $? -eq 1
			then
				sudo chmod $droit1 $arg2'/'$ligne
			else
				sudo chmod $droit2 $arg1'/'$ligne
				remplacement=`ls -ld $arg1'/'$ligne | sed 's/\//:/g'`
				sed -i "s/^.*$path3:$ligne$/$remplacement/g" .journal
			fi
		fi
	fi

path3=`echo $arg1 | sed 's/\//:/g'`




#COMAPAISON DES DOSSIERS

#REDIRECTION DES LISTES 
./liste_fichier.sh $arg1 > $arg1'/.fich1'

./liste_fichier.sh $arg2 > $arg2'/.fich1'

#COMPARE CONTENU
./compare_contenu.sh $arg1'/.fich1' $arg2'/.fich1'

retour=`echo $?` #exit de compare_contenu

#SI IDENTIQUES

if [ $retour -eq 2 ]
then
while read ligne
do
path2=`echo $path | sed 's/\//:/g'`	
present=`cat .journal | grep $arg1':'$ligne'$'`
droit=`ls -ld $arg1'/'$ligne | awk -F' ' '{print$1}' | sed 's/^.\(.*\)$/\1/g'`
./compare_metadonnees.sh $droit
droit1=`cat .droit-acc`
droit=`ls -ld $arg2'/'$ligne | awk -F' ' '{print$1}' | sed 's/^.\(.*\)$/\1/g'`
./compare_metadonnees.sh $droit
droit2=`cat .droit-acc`
rm -r .droit-acc
proprio1=`ls -ld $arg1'/'$ligne | awk -F' ' '{print$3}'`
proprio2=`ls -ld $arg2'/'$ligne | awk -F' ' '{print$3}'`
groupe1=`ls -ld $arg1'/'$ligne | awk -F' ' '{print$4}'`
groupe2=`ls -ld $arg2'/'$ligne | awk -F' ' '{print$4}'`
date1=`ls -ld $arg1'/'$ligne | awk -F' ' '{printf$7" "$6" "$8}' | sed -f gestion_heure.sh`	
date=`echo $date1 | sed 's/ /:/g'`
date1=$date
date2=`ls -ld $arg2'/'$ligne | awk -F' ' '{printf$7" "$6" "$8}' | sed -f gestion_heure.sh`	
date=`echo $date2 | sed 's/ /:/g'`
date2=$date


	if test "$groupe1" != "$groupe2"
	then
		if  [ -z "$present" ]
		then
			./compare_date.sh $date1 $date2
			if test $? -eq 1
			then
				sudo chgrp $groupe1 $arg2'/'$ligne
			else
				sudo chgrp $groupe2 $arg1'/'$ligne
				remplacement=`ls -ld $arg1'/'$ligne | sed 's/\//:/g'`
				sed -i "s/^.*$path3:$ligne$/$remplacement/g" .journal
			fi
		else
			groupe_journal=`cat .journal | grep $path3':'$ligne'$' | awk -F' ' '{printf$4}'`	
			if test "$groupe1" == "$groupe_journal"
			then
				sudo chgrp $groupe2 $arg1'/'$ligne
				remplacement=`ls -ld $arg1'/'$ligne | sed 's/\//:/g'`
				sed -i "s/^.*$path3:$ligne$/$remplacement/g" .journal
			elif test "$groupe2" == "$groupe_journal"
			then
				sudo chgrp $groupe1 $arg2'/'$ligne
			else
				./compare_date.sh $date1 $date2
				if test $? -eq 1
				then
					sudo chgrp $groupe1 $arg2'/'$ligne
				else
					sudo chgrp $groupe2 $arg1'/'$ligne
					remplacement=`ls -ld $arg1'/'$ligne | sed 's/\//:/g'`
					sed -i "s/^.*$path3:$ligne$/$remplacement/g" .journal
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
				sudo chown $proprio1 $arg2'/'$ligne
			else
				sudo chown $proprio2 $arg1'/'$ligne
				remplacement=`ls -ld $arg1'/'$ligne | sed 's/\//:/g'`
				sed -i "s/^.*$path3:$ligne$/$remplacement/g" .journal
			fi
		else
			proprio_journal=`cat .journal | grep $path3':'$ligne'$' | awk -F' ' '{printf$3}'`	
			if test "$proprio1" == "$proprio_journal"
			then
				sudo chown $proprio2 $arg1'/'$ligne
				remplacement=`ls -ld $arg1'/'$ligne | sed 's/\//:/g'`
				sed -i "s/^.*$path3:$ligne$/$remplacement/g" .journal
			elif test "$proprio2" == "$proprio_journal"
			then
				sudo chown $proprio1 $arg2'/'$ligne
			else
				./compare_date.sh $date1 $date2
				if test $? -eq 1
				then
					sudo chown $proprio1 $arg2'/'$ligne
				else
					sudo chown $proprio2 $arg1'/'$ligne
					remplacement=`ls -ld $arg1'/'$ligne | sed 's/\//:/g'`
					sed -i "s/^.*$path3:$ligne$/$remplacement/g" .journal
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
				sudo chmod $droit1 $arg2'/'$ligne
			else
				sudo chmod $droit2 $arg1'/'$ligne
				remplacement=`ls -ld $arg1'/'$ligne | sed 's/\//:/g'`
				sed -i "s/^.*$path3:$ligne$/$remplacement/g" .journal
			fi
		else
			droit=`cat .journal | grep $path3':'$ligne'$' | awk -F' ' '{print$1}' | sed 's/^.\(.*\)$/\1/g'`
			./compare_metadonnees.sh $droit
			droit_journal=`cat .droit-acc`	
			rm -r .droit-acc
			if test "$droit1" == "$droit_journal"
			then
				sudo chmod $droit2 $arg1'/'$ligne
				remplacement=`ls -ld $arg1'/'$ligne | sed 's/\//:/g'`
				sed -i "s/^.*$path3:$ligne$/$remplacement/g" .journal
			elif test "$droit2" == "$droit_journal"
			then
				sudo chmod $droit1 $arg2'/'$ligne
			else
				./compare_date.sh $date1 $date2
				if test $? -eq 1
				then
					sudo chmod $droit1 $arg2'/'$ligne
				else
					sudo chmod $droit2 $arg1h'/'$ligne
					remplacement=`ls -ld $arg1'/'$ligne | sed 's/\//:/g'`
					sed -i "s/^.*$path3:$ligne$/$remplacement/g" .journal
				fi
			fi
		fi
	fi


	if [ -z "$present" ]
	then	
		ls -ld $arg1'/'$ligne | sed 's/\//:/g' | sed 's/  */\t/g' >> .journal
	fi
	
	date_journal=`cat .journal | grep $path3':'$ligne'$' | awk -F' ' '{printf$7" "$6" "$8}' | sed -f gestion_heure.sh`	
	date=`echo $date_journal | sed 's/ /:/g'`
	date_journal=$date

	./compare_type.sh $arg1'/'$ligne
	type1=`echo $?`	
	
	./compare_type.sh $arg2'/'$ligne
	type2=`echo $?`

	if [ $type1 -eq $type2 ]
	then
		if [ $type1 -eq 1 ]
		then	
                	./compare_contenu.sh $arg1'/'$ligne $arg2'/'$ligne
			if [ $? -eq 1 ]
			then
				#echo "Les fichiers $arg1/$ligne et $arg2/$ligne ne sont pas pareil"
				#	./plus_recent.sh $path1'/'$ligne $path2'/'$ligne
				date_journal=`cat .journal | grep $path3':'$ligne'$' | awk -F' ' '{printf$7" "$6" "$8}' | sed -f gestion_heure.sh`	
				date=`echo $date_journal | sed 's/ /:/g'`
				date_journal=$date
				date1=`ls -ld $arg1'/'$ligne | awk -F' ' '{printf$7" "$6" "$8}' | sed -f gestion_heure.sh`	
				date=`echo $date1 | sed 's/ /:/g'`
				date1=$date
				date2=`ls -ld $arg2'/'$ligne | awk -F' ' '{printf$7" "$6" "$8}' | sed -f gestion_heure.sh`	
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
					echo "la difference entre les fichiers $arg1/$ligne et $arg2/$ligne est la suivante: pensez à réajuster les contenu"
					echo "----------------------------------------"
					diff $arg1'/'$ligne $arg2'/'$ligne #| sed -e 's/^</'$arg1'/'$ligne' </g' -e 's/^>/'$arg2'/'$ligne' >/g'
					echo "----------------------------------------"
					./compare_date.sh $date1 $date2
					choix=$?
					if [ $choix -eq 1 ]
					then
						#COPIE DE $3... dans $4 ET MISE A JOUR DU JOURNAL
						sudo cp $arg1'/'$ligne $arg2'/'$ligne
						sudo cp $arg2'/'$ligne $arg1'/'$ligne
						remplacement=`ls -ld $arg1'/'$ligne | sed 's/\//:/g'`
						sed -i "s/^.*$path3:$ligne$/$remplacement/g" .journal
					elif [ $choix -eq 2 ]
					then
						#COPIE DE $4... dans $3 et MISE A JOUR DU JOURNAL
						sudo cp $arg2'/'$ligne $arg1'/'$ligne
						sudo cp $arg1'/'$ligne $arg2'/'$ligne
						remplacement=`ls -ld $arg1'/'$ligne | sed 's/\//:/g'`
						sed -i "s/^.*$path3:$ligne$/$remplacement/g" .journal
					else
						#DIFFERENCE ENTRE LES FICHIERS 
						sudo cat -n $arg2'/'$ligne > .fich4.txt
						sudo cat -n $arg1'/'$ligne > .fich3.txt

						echo ""
						echo "Nous avons mis les difference du fichier $arg2/$ligne dans $arg1/$ligne"
						echo ""
						diff .fich4.txt .fich3.txt > .difference1.txt
						rm .fich4.txt .fich3.txt
						sed '/^[^><]/d' .difference1.txt > .difference.txt
						rm .difference1.txt
						#CONTENU QUE POSSEDE fich1 et non fich2
						sed -e 's/^< \(.*\)$/\1/g' -e '/^>.*/d' .difference.txt  > .difference_fich1.txt
						sudo cat .difference_fich1.txt >> $arg1'/'$ligne
						sudo cp $arg1'/'$ligne $arg2'/'$ligne
						sudo cp $arg2'/'$ligne $arg1'/'$ligne
						remplacement=`ls -ld $arg1'/'$ligne | sed 's/\//:/g'`
						sed -i "s/^.*$path3:$ligne$/$remplacement/g" .journal
						rm .difference_fich1.txt
					fi
				#IF path1/ligne est plus recent
				else
					#ils n'ont pas la même date de dernière modification
					if test $a_jour1 -eq 0
					then
						#le fichier 1 est conforme au fichier journal
						sudo cp $arg2'/'$ligne $arg1'/'$ligne
						sudo cp $arg1'/'$ligne $arg2'/'$ligne
						remplacement=`ls -ld $arg1'/'$ligne | sed 's/\//:/g'`
						sed -i "s/^.*$path3:$ligne$/$remplacement/g" .journal
					else
						#le fichier 2 est conforme au fichier journal
						sudo cp $arg1'/'$ligne $arg2'/'$ligne
						sudo cp $arg2'/'$ligne $arg1'/'$ligne
						remplacement=`ls -ld $arg1'/'$ligne | sed 's/\//:/g'`
						sed -i "s/^.*$path3:$ligne$/$remplacement/g" .journal
					fi
				fi
			fi

		else
			if test -z $path
			then
				./compare_dossier.sh "$ligne" '' "$arg1" "$arg2"
			else
				./compare_dossier.sh "$ligne" "$path" "$arg1" "$arg2"
			fi
		fi

	else
		if [ $type1 -eq 1 ]
		then
				./compare_date.sh $date1 $date2
				recent=$?
			if test $recent -eq 1
			then
				sudo rm -r $arg2'/'$ligne 
				sudo cp $arg1'/'$ligne $arg2'/'$ligne
				sudo rm -r $arg1'/'$ligne 
				sudo cp $arg2'/'$ligne $arg1'/'$ligne
				sudo chown $proprio1 $arg2'/'$ligne
				sudo chown $proprio1 $arg1'/'$ligne
				sudo chgrp $groupe1 $arg2'/'$ligne
				sudo chgrp $groupe1 $arg1'/'$ligne
				sudo chmod $droit1 $arg2'/'$ligne
				sudo chmod $droit1 $arg1'/'$ligne
				remplacement=`ls -ld $arg1'/'$ligne | sed 's/\//:/g'`
				sed -i "s/^.*$path3:$ligne$/$remplacement/g" .journal
			else
				sudo rm -r $arg1'/'$ligne 
				sudo cp -r $arg2'/'$ligne $arg1'/'$ligne
				sudo rm -r $arg2'/'$ligne 
				sudo cp -r $arg1'/'$ligne $arg2'/'$ligne
				sudo chown $proprio2 $arg1'/'$ligne
				sudo chown $proprio2 $arg2'/'$ligne
				sudo chgrp $groupe2 $arg1'/'$ligne
				sudo chgrp $groupe2 $arg2'/'$ligne
				sudo chmod $droit2 $arg1'/'$ligne
				sudo chmod $droit2 $arg2'/'$ligne
				remplacement=`ls -ld $arg1'/'$ligne | sed 's/\//:/g'`
				sed -i "s/^.*$path3:$ligne$/$remplacement/g" .journal
			fi
		else
			./compare_date.sh $date1 $date2
			recent=$?
			if test $recent -eq 1
			then
				sudo rm -r $arg2'/'$ligne 
				sudo cp -r $arg1'/'$ligne $arg2'/'$ligne
				sudo rm -r $arg1'/'$ligne 
				sudo cp -r $arg2'/'$ligne $arg1'/'$ligne
				sudo chown $proprio1 $arg2'/'$ligne
				sudo chown $proprio1 $arg1'/'$ligne
				sudo chgrp $groupe1 $arg2'/'$ligne
				sudo chgrp $groupe1 $arg1'/'$ligne
				sudo chmod $droit1 $arg2'/'$ligne
				sudo chmod $droit1 $arg1'/'$ligne
				remplacement=`ls -ld $arg1'/'$ligne | sed 's/\//:/g'`
				sed -i "s/^.*$path3:$ligne$/$remplacement/g" .journal
			else
				sudo rm -r $arg1'/'$ligne 
				sudo cp -r $arg2'/'$ligne $arg1'/'$ligne
				sudo rm -r $arg2'/'$ligne 
				sudo cp -r $arg1'/'$ligne $arg2'/'$ligne
				sudo chown $proprio2 $arg1'/'$ligne
				sudo chown $proprio2 $arg2'/'$ligne
				sudo chgrp $groupe2 $arg1'/'$ligne
				sudo chgrp $groupe2 $arg2'/'$ligne
				sudo chmod $droit2 $arg1'/'$ligne
				sudo chmod $droit2 $arg2'/'$ligne
				remplacement=`ls -ld $arg1'/'$ligne | sed 's/\//:/g'`
				sed -i "s/^.*$path3:$ligne$/$remplacement/g" .journal
			fi
		fi
	fi

	done<$arg1'/.fich1'
	rm $arg1'/.fich1'
	rm $arg2'/.fich1'
else

	#DIFFERENCE ENTRE LES FICHIERS 
	sudo diff $arg1'/.fich1' $arg2'/.fich1' > .difference1.txt
	sed '/^[^><]/d' .difference1.txt > .difference.txt
	rm -r .difference1.txt $arg1'/.fich1' $arg2'/.fich1'

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
			sudo cp -r $arg2'/'$ligne $arg1'/'$ligne
			sudo rm -r $arg2'/'$ligne
			sudo cp -r $arg1'/'$ligne $arg2'/'$ligne
			remplacement=`ls -ld $arg1'/'$ligne | sed 's/\//:/g'`
			echo "$remplacement" >> .journal
		else
			sudo rm -r $arg2'/'$ligne
			sed -i "/^.*$path3:$ligne$/d" .journal
		fi
	done<.difference_fich2.txt
	while read ligne
	do 
		present=`cat .journal | grep $path3':'$ligne'$'`
		if [ -z "$present" ]
		then
			sudo cp -r $arg1'/'$ligne $arg2'/'$ligne
			sudo rm -r $arg1'/'$ligne
			sudo cp -r $arg2'/'$ligne $arg1'/'$ligne
			remplacement=`ls -ld $arg1'/'$ligne | sed 's/\//:/g'`
			echo "$remplacement" >> .journal
		else
			sudo rm -r $arg1'/'$ligne
			sed -i "/^.*$path3:$ligne$/d" .journal
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
	./synchronisateur.sh $arg1 $arg2
fi

echo "la synchronisation a réussi sans souci"
exit 0


