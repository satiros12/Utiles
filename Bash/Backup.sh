#Make Backup of $2 and put in file $3  -> Use full path names.
#Unpack backup from a $2 and put here .
Backup="$(which $0)"
case $1 in
      c)
		tar cf - ./* | 7z a -m0=lzma2 -mx -md15m -si "$2"
		;;
      d)
		cd "$2"
		#echo "$Backup"		
		$Backup c "$3"
		;;
      e)       
		7z x -so "$2" | tar xf "$3"
		;;
      h)
		echo "Make simply backup"
		echo "Options:"
		echo "		c) To make a file.tar.7z (2) of ./* files"
		echo "		d) To make a file.tar.7z (3) of <Directory>/* (2) files"
		echo "		e) To extract form file.tar.7z (2) in Direcotry/. (3)"
		echo "		h) This message."
		;;
      *) 
		echo "Error: 'c' | 'd' | 'e' -- arg0: <src_dir> arg1 <dst_dir>"
esac
#tar cf - ./Suse/* | 7z a -m0=lzma2 -mx -md15m -si /home/alberto/Suse_BackUp_26_05_14.tar.7z
#7z x -so /mnt/Backup/Suse_BackUp_27_05_14.tar.7z | tar xf 
