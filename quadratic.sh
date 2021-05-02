#!/bin/bash

solve () {
	
	#get vals
	a=$1
	b=$2
	c=$3

	#answer
	ans=()

	#for later
	re1='^[+-]?[0-9]+$'
	re2='^[0-9]+$'

	#handle issues
	#all vals must be supplied
	if [[ $a = "" ]] || [[ $b = "" ]] || [[ $c = ""  ]]; then
		printf "error: a, b, and c must all be supplied\n"
		return 1

	#a cannot be 0
	elif [[ $a = 0 ]]; then
		printf "error: a cannot be 0\n"
		return 1

	#all vals must be integers
	elif  [[ ! $a =~ $re1 ]] || [[ ! $b =~ $re1 ]] || [[ ! $c =~ $re1 ]]; then
		printf "error: a, b, and c must all be integers\n"
		return 1

	#all vals must be < 1,000,000,000
	elif [[ $a -gt 1000000000 ]] || [[ $b -gt 1000000000 ]] || [[ $c -gt 1000000000 ]]; then
		printf "error: a, b, and c must all be less than 1,000,000,000\n"
		return 1
	fi	

	#now on to the fun part

	#calculate bottom line
	bottom_line=$(( $a * 2 ))
	
	#calculate top line radical
	radical=$( source ./radicals.sh $(( ($b * $b) - (4 * $a * $c) )) )

	#calculate top lines
	#check if radical is int
	if [[ $radical =~ $re2 ]]; then
		top_line_plus=$(( ($b * -1) + $radical ))
		top_line_minus=$(( ($b * -1) - $radical ))

		echo $top_line_plus
		echo $top_line_minus

		if [[ $(( $top_line_plus % $bottom_line)) = 0 ]]; then
			ans+=( $(( $top_line_plus / $bottom_line)) )

		else
			ans+=( "$top_line_plus / $bottom_line" )
		fi
			
		if [[ $(( $top_line_minus % $bottom_line )) = 0 ]]; then
			ans+=( $(( $top_line_minus / $bottom_line)) )

		else
			ans+=( "$top_line_minus / $bottom_line" )
		fi

	else
		ans+=( "-$b + $radical / $bottom_line", "-$b - $radical / $bottom_line" )
	fi

	printf "%s" "${ans[@]}"
	return 0
}

printf "%s" $(solve $1 $2 $3)
printf "\n"