#!/bin/bash
#New functionality:
#	1- Find blocks.
#	2- Elimintae/Put lines or blocks.

#Proves
#if [ "$#" -lt "1" ]; then echo "At the last 1"; exit 1; fi

Patron='//[*].'
Object=$1

if [ "$2" != "" ]; then 
	Patron="$2"
fi

#functions
function getDoc
{
	file=$1
	Patron=$2
	finded=$(grep -nr "$Patron" $file)	 
	if [ "$finded" != "" ]; then 
	echo "$file:$finded"
	fi
	return 0
}

#Code
if [ -f "$Object" ]; then
	getDoc $Object $Patron
elif [ -d "$Object" ]; then
	for file in $(ls $Object); do
		getDoc "$Object/$file" $Patron
	done
elif [ "$Object" == "-h" ]; then

echo "$0 f <file> [<Grep_Reg_Exp> default='//*'] " 
echo "$0 d <dir> [<Grep_Reg_Exp> default='//*']"
echo "Write in stdrout:
	<filename>:
	line number>...o" 

else
while read $line; do
	finded=$(echo "$line" | grep "$Patron")
	if [ "$finded" != "" ]; then 
	echo "$finded"
	fi
done 
read $Object
fi
