#!/bin/bash

#EXIT --> 1 SI $1 PLUS RECENT
#EXIT --> 2 SI $2 PLUS RECENT
#EXIT --> 0 ils ont les mêmes dates

#PREND DEUX DATES EN PARAMETRES

#POUR $1

mois1=`echo $1 | awk -F':' '{print$2}'`
heure1=`echo $1 | awk -F':' '{print$3}'`
jour1=`echo $1 | awk -F':' '{print$1}'`
minute1=`echo $1 | awk -F':' '{print$4}'`

#POUR $2
mois2=`echo $2 | awk -F':' '{print$2}'`
heure2=`echo $2 | awk -F':' '{print$3}'`
jour2=`echo $2 | awk -F':' '{print$1}'`
minute2=`echo $2 | awk -F':' '{print$4}'`

if [ "$mois1" -lt "$mois2" ]
then
	exit 2
elif [ "$mois1" -gt "$mois2" ]
then
	exit 1
else
	if test "$jour1" -lt "$jour2"
	then
		exit 2
	elif test "$jour1" -gt "$jour2"
	then
		exit 1
	else
		if test "$heure1" -lt "$heure2"
		then
			exit 2
		elif test "$heure1" -gt "$heure2"
		then 
			exit 1
		else 
			if test "$minute1" -lt "$minute2"
			then
				exit 2
			elif test "$minute1" -gt "$minute2"
			then
				exit 1
			else
				exit 0
			fi
		fi
	fi
fi
