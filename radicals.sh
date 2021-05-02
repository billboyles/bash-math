#!/bin/bash

simplify () {

	#housekeeping vars
	is_neg=false
	remove=""
	re='^[+-]?[0-9]+$'

	#get radical to be simplified
	n=$1

	#check for valid arguments
	#check if variable to be simplified was supplied
	if [[ $n = "" ]]; then
		printf "error: radical to be simplified must be supplied\n"
		return 1

	#check to make sure variable is an integer
	elif ! [[ $n =~ $re ]] ; then
	   printf "error: radical to simplify must be an integer\n"
	   return 1

	#check if number is too large
	elif [[ $n -gt 1000000000 ]]; then
		printf "error: radical to be simplified must be less than 1,000,000,000\n"
		return 1
	fi

	#handle negatives
	if [[ $n -lt 0 ]]; then
		((n *= -1)) 
		is_neg=true
	fi

	#handle trivial cases
	if [[ $n = 0 ]]; then
		printf "0\n"
		return 0
	fi

	if [[ $n = 1 ]]; then
		#check if val was negative
		if $is_neg; then
			#if so, use i
			printf "i\n"
		else
			#else answer is 1
			printf "1\n"
		fi
	return 0
	fi

	#now back to the good part
	
	#get factors
	factors=($(source ./factors.sh $n))

	#handle perfect squares
	#if number of factors is odd, we have a perfect square with sqrt equal to the middle factor
	if [ ! $(( ${#factors[@]} % 2 )) -eq 0 ]; then
		#check if neg
		if $is_neg; then
			#if so, get middle val + i
			printf "%si\n" ${factors[ $(( ${#factors[@]} / 2 )) ]}
		else
			#else just get middle val
			printf "%s\n" ${factors[ $(( ${#factors[@]} / 2 )) ]}
		fi
	return 0
	fi

	#if not perfect square, simplify

	#first, get prime factors via recursion
	primes=()

	#for factor in ${factors[@]:1:$(( $(( ${#factors[@]} - 2 )) ))}

	while [ ${#factors[@]} -gt 2 ]
	do
		#slice off ends of factor_list
		factors=(${factors[@]:1:$(( $(( ${#factors[@]} - 2 )) ))})
		
		#add new lowest to primes
		primes+=(${factors[0]})

		#factor new highest, repeat until only 2 factors left
		factors=($(source ./factors.sh ${factors[-1]}))
	
	done

	#add last factor
	primes+=(${factors[-1]})

	declare -A counts

	for prime in "${primes[@]}"
	do
		if [[ -v "counts[$prime]" ]] ; then
  			counts["$prime"]=$((counts["$prime"] + 1))
  		else
  			counts["$prime"]=1
  		fi
	done

	removes=()
	remainders=()

	for n in "${!counts[@]}"
	do 
		i="${counts[$n]}"

		while [[ $i > 1 ]]
		do
			removes+=($n)
			i=$(($i-2))
		done

		if [[ $i = 1 ]]; then
			remainders+=($n)
		fi
	done

	removed=1
	remainder=1

	for r in "${removes[@]}"
	do
		removed=$(($removed * $r))
	done

	for r in "${remainders[@]}"
	do
		remainder=$(($remainder * $r))
	done

	#and here's our result

	#if negative, need to add i
	if $is_neg; then
		if [[ removed -gt 1 ]]; then
			printf "%si\u221A%s\n" $removed $remainder
		else
			printf "i\u221A%s\n" $remainder
		fi
	else
		if [[ removed -gt 1 ]]; then
			printf "%s\u221A%s\n" $removed $remainder
		#this means it cannot be simplified
		else
			printf "\u221A%s cannot be simplified\n" $remainder
		fi		
	fi
	return 0
}

printf "%s\n" $(simplify $1)

