#!/bin/bash

# Clear screen
clear
main_directory=$('pwd')
IFS='
'

###############################################
#  Convert id3 tag info of files in folder X  #
###############################################
function id3_tag_convert_folder(){
	clear
	album=""
	genre=""
	echo "============================="
	echo "= Select a folder to modify ="
	echo "============================="
	echo "0. Back"
	echo "1. Spinning"
	echo "2. Rock"
	echo "3. Classic"
	echo "4. BSO"
	echo "5. Retro"
	echo ""
	echo -n "Option: "
	read option
	case $option in
		0)
			id3_tag
			;;
		1)
			album="Spinning"
			genre="52"
			;;
		2)
			album="Rock"
			genre="17"
			;;
		3)
			album="Classic"
			genre="32"
			;;
		4)
			album="BSO"
			genre="24"
			;;
		5)
			album="Retro"
			genre="76"
			;;
		*)
			id3_tag_convert_folder
			;;
	esac
	
	directory=$main_directory"/mp3/$album/"

	Files=$(ls $directory | grep .mp3)
	max_basename_length=0
	for File in $Files
	do
		name=`echo "$File" | sed -e "s/.mp3$//g"`
		basename=`echo "$name" | cut -d'.' -f1`
		basename_length=`echo $basename | wc -m`
		if (( $basename_length > $max_basename_length ))
		then
			max_basename_length=$basename_length
		fi
	done
		
	for File in $Files
	do
		name=`echo "$File" | sed -e "s/.mp3$//g"`
		basename=`echo "$name" | cut -d'.' -f1`
		basename_length=`echo $basename | wc -m`

		points="${name//[^.]}"
		slash="${name//[^-]}"
		if (( ${#points} == 0 ))
		then
			if (( ${#slash} == 1 ))
			then
				# Select the artist and the track (cut = select id3 tag | sed = remove leading or trailing spaces)
				artist=`echo "$basename" | cut -d'-' -f1  | sed 's/ *$//'`
				track=`echo "$basename" | cut -d'-' -f2 | sed 's/^ *//'`

				#~ echo "Artista: $artist - Track: $track - Album: $album"
				
				#Extract and put id3 info
				# id3tool --set-title=$track --set-album=$album --set-artist=$artist
				status="[  OK  ]"
				id3v2 --artist "$artist" --song "$track" --album "$album" -y "2015" -g "$genre" $directory$File
				if (( $? != 0 ))
				then
					status="[FAILED]"
				fi
				sep=$max_basename_length-$basename_length+4
				echo
				echo -n $basename
				for (( i=0; i<$sep; i++))
				do
					echo -n " "
				done
				echo -n $status
			else
				echo ""
				echo "The name of the file have more than 1 slash delimiter"
				echo "$name	[FAILED]"
				echo ""
			fi
		else
			echo ""
			echo "The name of the file have more than 1 point delimiter"
			echo "$name	[FAILED]"
			echo ""
		fi
	done
	echo ""
	echo ""
	echo "Press Intro to continue"
	read
	id3_tag
}

##############################
#  List id3 tag info
##############################
function id3_tag_list(){
	clear
	album=""
	echo "============================="
	echo "= Select a folder to modify ="
	echo "============================="
	echo "0. Back"
	echo "1. Spinning"
	echo "2. Rock"
	echo "3. Classic"
	echo "4. BSO"
	echo "5. Retro"
	echo ""
	echo -n "Option: "
	read option
	case $option in
		0)
			id3_tag
			;;
		1)
			album="Spinning"
			;;
		2)
			album="Rock"
			;;
		3)
			album="Classic"
			;;
		4)
			album="BSO"
			;;
		5)
			album="Retro"
			;;
		*)
			id3_tag_list
			;;
	esac
	
	directory=$main_directory"/mp3/$album/"
	Files=$(ls $directory | grep .mp3)

	max_basename_length=0
	for File in $Files
	do
		name=`echo "$File" | sed -e "s/.mp3$//g"`
		basename=`echo "$name" | cut -d'.' -f1`
		basename_length=`echo $basename | wc -m`
		if (( $basename_length > $max_basename_length ))
		then
			max_basename_length=$basename_length
		fi
	done

	for File in $Files
	do
		# Basename of the file
		name=`echo "$File" | sed -e "s/.mp3$//g"`
		for (( i=0; i<$max_basename_length; i++))
		do
			echo -n "="
		done
		echo ""
		id3v2 -l $directory$File
	done
	echo ""
	echo ""
	echo "Press Intro to continue"
	read
	id3_tag	
}

##############################
# id3 interface function
##############################
function id3_tag(){
	clear
	echo "===================="
	echo "= Id3 tag of files ="
	echo "===================="
	echo "0. Back"
	echo "1. List id3 tag info file"
	echo "2. Modify id3 tag info files of a folder"
	echo ""
	echo -n "Option: "
	read option
	case $option in
		0)
			menu
			;;
		1)
			id3_tag_list
			;;
		2)
			id3_tag_convert_folder
			;;
		*)
			id3_tag
			;;
	esac
}

##############################
# Convert mp4 to mp3 files
##############################
function convert_files(){
	clear
	mp4ConvertedDirectory=$main_directory"/mp4/Converted/"
	mp4NoConvertedDirectory=$main_directory"/mp4/NoConverted/"
	mp3Directory=$main_directory"/mp3/"

	for extension in ".mp4"
	do
		Files=$(ls $mp4NoConvertedDirectory | grep $extension)
		for File in $Files
		do 
			name=`echo "$File" | sed -e "s/.mp4$//g"`
			
			#Convert mp4 to mp3
			#~ ffmpeg -i $File -b:a 192K -vn ./mp3f/$name.mp3
			#~ ffmpeg -i $i -f mp3 -ab 192000 -vn ./mp3f/`basename "$i" .mp4`.mp3
			echo "$name"
			avconv -y -i $mp4NoConvertedDirectory$File -vn -ar 44100 -ac 2 -ab 160K -f mp3 -loglevel quiet $mp3Directory$name.mp3
			if (($? > 0)); then
				echo "Fail to convert $name"
			else
				#Reallocate file
				mv $mp4NoConvertedDirectory$File $mp4ConvertedDirectory
			fi
		done
	done
	
	back_to_menu
}

###############################
# Make the directorys to work #
###############################
function directorys(){
	directorys=("/mp3/Spinning" "/mp3/Rock" "/mp3/Classic" "/mp3/BSO" "/mp3/Retro" "/mp4/NoConverted" "/mp4/Converted")
	for dir in ${directorys[@]}
	do
		if  ! [ -d $main_directory$dir ]
		then
			mkdir -p $main_directory$dir
		fi
	done
}


#####################
# Back to main menu #
#####################
function back_to_menu(){
	echo ""
	echo ""
	echo "Press Intro to continue"
	read
	menu
}

#################
# Test function #
#################
function test_function(){
	echo -n "Proceed?[Y/n]] "
	read option
	case $option in
		"n" | "no" | "nO" | "N" | "NO" | "No")
			echo "Perfect, press intro"
			read
			menu
			;;
		*)
			menu
			;;
	esac
	menu
}

##############################
# Menu function
##############################
function menu(){
	clear
	cd $main_directory
	echo "========"
	echo "= Menu ="
	echo "========"
	echo "0. Exit"
	echo "1. mp4 -> mp3"
	echo "2. Tag mp3's"
	echo "3. Test example"
	echo ""
	echo -n "Option: "
	read option
	case $option in
		0)
			clear
			exit
			;;
		1)
			convert_files
			;;
		2)
			id3_tag
			;;
		3)
			test_function
			;;
		*)
			menu
			;;
	esac
}

# Start script creating the directorys to work
directorys
menu
IFS=''

# +-- MainDirectoryStructure
# 	+-- resample.sh
# 	+-- mp3
# 		+-- Spinning
# 		+-- Rock
# 		+-- BSO
# 		+-- Classic
# 		+-- Retro
#		Directory where its located the files that have been converted to mp3, after that move the file to the corresponding directory/genre
# 	+-- mp4
# 		+-- Converted
#			Here will be moved all the files that have been converted
# 		+-- NoConverted
#			And here must be the files you want to convert