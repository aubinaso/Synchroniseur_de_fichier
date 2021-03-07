#!/bin/bash

#TRANSFORMATION DES DROITS EN CHIFFRES

	user=`echo $1 | sed 's/^\(...\).*/\1/g'`
	groupe=`echo $1 | sed 's/^...\(...\).*/\1/g'`
	other=`echo $1 | sed 's/......\(...\)$/\1/g'`
		u=0
		g=0
		o=0
		if test `echo $user | sed 's/^\(.\).*/\1/g'` = 'r'
		then
			u=$(($u+4))
		fi
		if test `echo $user | sed 's/^.\(.\).*/\1/g'` = 'w'
		then
			u=$(($u+2))
		fi
		if test `echo $user | sed 's/^..\(.\)$/\1/g'` = 'x'
		then
			u=$(($u+1))
		fi
		if test `echo $groupe | sed 's/^\(.\).*/\1/g'` = 'r'
		then
			g=$(($g+4))
		fi
		if test `echo $groupe | sed 's/^.\(.\).*/\1/g'` = 'w'
		then
			g=$(($g+2))
		fi
		if test `echo $groupe | sed 's/^..\(.\)$/\1/g'` = 'x'
		then
			g=$(($g+1))
		fi
		if test `echo $other | sed 's/^\(.\).*/\1/g'` = 'r'
		then
			o=$(($o+4))
		fi
		if test `echo $other | sed 's/^.\(.\).*/\1/g'` = 'w'
		then
			o=$(($o+2))
		fi
		if test `echo $other | sed 's/^..\(.\)$/\1/g'` = 'x'
		then
			o=$(($o+1))
		fi
echo $u$g$o > .droit-acc
exit 1
