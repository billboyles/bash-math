#!/bin/bash

factor () {

	#get number to be factorized
	n=$1

	#a surprise tool that will help us later
	re='^[0-9]+$'

	#check for valid arguments
	#check if variable to be factored was supplied
	if [[ $n = "" ]]; then
		printf "error: number to be factorized must be supplied\n"
		return 1

	#check to make sure variable is a postitive integer
	elif ! [[ $n =~ $re ]] ; then
	   printf "error: value to factor must be a postitive integer\n"
	   return 1

	#check if number is too large
	elif [[ $n -gt 1000000000 ]]; then
		printf "error: number to be factorized must be less than 1,000,000,000\n"
		return 1

	#handle trivial cases
	elif [[ $n = 0  ]] || [[ $n = 1 ]]; then
		printf "$n\n"
		return 1
	fi

	#now for the good stuff

	#initialize array for factors
	factors=()

	#get ceiling of n/2 - this is the possibility space for factors
	cel=$(( ($n + 1) / 2 ))

	#loop each potential factor
	for ((i=1; i <= $cel; i++))
	do
		#test if potential factor divides evenly into n
		if [[ $(( $n % $i )) = 0 ]]; then
			#if it does, test if it is already in the factors array
			if [[ ! " ${factors[@]} " =~ " $i " ]]; then
	    		#if it isn't, add it
	    		factors+=($i)
			fi
		fi
	done

	#add n to the factors array (we do this last to ensure proper ordering
	factors+=($n)

	#print out factors array
	printf "%s\n" ${factors[@]}
	return 0
}

printf "%s\n" $(factor $1)
