#!/bin/bash

cat woorden.txt | sort | uniq > woorden.txt.tmp
mv -f woorden.txt.tmp woorden.txt

COUNTER=0
DUTCH_WORDS=0
DUTCH_CORRECT=0
ENGLISH_WORDS=0
ENGLISH_CORRECT=0
while true
do
	line=`shuf -n 1 woorden.txt`
	dutch=`echo $line | cut -d'|' -f1`
	english=`echo $line | cut -d'|' -f2`

	if [ $(( $COUNTER % 2 )) -eq 0 ]; then
		echo 'Dutch:   ' $dutch
	else
		echo 'English: ' $english
	fi

	sleep 1.5

	if [ $(( $COUNTER % 2 )) -eq 0 ]; then
		echo 'English: ' $english
	else
		echo 'Dutch:   ' $dutch
	fi

	key=
	while true
	do
		read -n1 -r -s key

		case $key in
		y)
			if [ $(( $COUNTER % 2 )) -eq 0 ]; then
				DUTCH_WORDS=$((DUTCH_WORDS + 1))
				DUTCH_CORRECT=$((DUTCH_CORRECT + 1))
			else
				ENGLISH_WORDS=$((ENGLISH_WORDS + 1))
				ENGLISH_CORRECT=$((ENGLISH_CORRECT + 1))
			fi

			break
			;;
		n)
			if [ $(( $COUNTER % 2 )) -eq 0 ]; then
				DUTCH_WORDS=$((DUTCH_WORDS + 1))
			else
				ENGLISH_WORDS=$((ENGLISH_WORDS + 1))
			fi

			break
			;;
		q)
			break
			;;
		esac
	done

	if [ $key = 'q' ]; then
		break
	fi

	echo ''

	COUNTER=$((COUNTER + 1))
done



echo ''
echo ''
echo ''
echo ''
awk -v correct="$DUTCH_CORRECT" -v words="$DUTCH_WORDS" 'BEGIN{printf "Dutch:   %.0f%\n", correct/words * 100}'
awk -v correct="$ENGLISH_CORRECT" -v words="$ENGLISH_WORDS" 'BEGIN{printf "English: %.0f%\n", correct/words * 100}'
echo ''

