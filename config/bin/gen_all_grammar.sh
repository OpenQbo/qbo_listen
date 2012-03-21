#!/bin/bash
tmpfile=/var/tmp/juliusdialog.tmp
amdir=../AM/
lmdir=../LM/
tmpfile="tmpfile"
gengram=./gen_grammar.py

Ramdir=AM/
Rlmdir=LM/

preconfigfile=../configfile/default.jconf

finalconfigfile=../julius.jconf

function createConfFile {
IFS=$'\n'
> $tmpfile
languages=`ls -l $lmdir | grep -vi total | awk -F" " '{print $8}'`
for line in $languages; do
        echo "-AM $line" >> $tmpfile
        echo "-h $Ramdir$line/hmmdefs" >> $tmpfile
        echo "-hlist $Ramdir$line/tiedlist" >> $tmpfile
	echo "" >> $tmpfile
	LMs=`ls -l $lmdir$line | grep -vi total | awk -F" " '{print $8}'`
        for lm in $LMs; do
		echo "-LM $line$lm" >> $tmpfile

#		if [ $lm != "default" ]
#		then
		#	echo "-gram $Rlmdir$line/default/default" >> $tmpfile
#		fi

		echo "-gram $Rlmdir$line/$lm/$lm" >> $tmpfile
		echo "" >> $tmpfile
		echo "-SR "$line"_"$lm" "$line" "$line$lm >> $tmpfile
		echo "" >> $tmpfile
	done
        echo "" >> $tmpfile
        echo "" >> $tmpfile

done

cat $preconfigfile $tmpfile > $finalconfigfile
}



function compileLMs {
IFS=$'\n'

languages=`ls -l $amdir | grep -vi total | awk -F" " '{print $8}'`
for line in $languages; do
	LMs=`ls -l $lmdir$line | grep -vi total | awk -F" " '{print $8}'`
	for lm in $LMs; do
		echo "---------------------------------------------------------------------------------------------------------------"
		echo "Next To Process:"
		echo "  Language: $line"
		echo "  Grammar:  $lm"
                echo "---------------------------------------------------------------------------------------------------------------"
		YN="Null"
		while [ $YN = "Null" ]
		do
			echo "Do you want to compile this grammar?(y/n)"
                        if [ "$1" == "force" ]; then
                            YN="y"
                        else
       			    read YN
                        fi
			if [ "$YN" = "y" -o "$YN" = "Y" ]
			then
				$gengram $lmdir$line/$lm/sentences.conf $amdir$line/phonems $amdir$line/tiedlist $lmdir$line/$lm/$lm
			elif [ "$YN" = "n" -o "$YN" = "N" ]
			then
				echo "Continue with the next grammar..."
			else
				echo "Error"
				YN="Null"
			fi
		done
	done

done
}


cd "$QBO_ROS_PACKAGE_PATH/qbo_apps/qbo_listen/config/bin"
if [ "$1" == "-f" ]; then
    compileLMs "force"
else
    compileLMs
fi
createConfFile

