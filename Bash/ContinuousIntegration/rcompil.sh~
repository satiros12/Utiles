#!/bin/bash
#AUTOR: Stan
#VERSION: 0.1
#DATE: 14/09/2014
#Continuous integration daemon.
#--------------------------!!!!!! NOTHING WAS TESTED !!!!!------------------------
#With LOG.

#EXECUTION: drcompil.sh [<DIRECTORY>]
#EXAMPLES:
#1: drcompil.sh --> Will get current firectory with pwd.
#2: drcompil.sh /mnt --> Will use the "/mnt" directory
.--------------------------------------------------------------------------------
#VARIABLES


#CONSTANT_NAMES
PROGAM_NAME="rcompil"
TEMPORARY_FILE_NAME="/temp/.${PROGAM_NAME}_" #.drcompil_<dir>.dat --> Deleted if the owner wants.
CONFIGURATION_FILE_NAME="$PROGAM_NAME.conf" #Basic configuration file --> destination, head file, 
EXCLUDE_FILE_NAME="exclude.conf" #Exclusion file --> grep regular expresions by line in order to exclude files from send.
LOG="/var/log/${PROGAM_NAME}.log"  #Log file

#---CONFIGURATION_FILES
CHARACTER_CUT="="
WORD_PROGRAM_SENDING="PROG_SEMD"
WORD_AVIABLE_PROGRAM_SENDING="scp" #List of aviable programs for file sending.
WORD_PROGRAM_CONTROL="PROG_CONTROL"
WORD_AVIABLE_PROGRAM_CONTROL="ssh" #List of aviable programs for remote control.

WORD_DESTINATION="DEST"

WORD_COMAND="COMAND"
WORD_OPTIONS="OPTIONS"

WORD_HEAD="HEAD"
 
#PROGRAMS
SENDER_PROGRAM="" #Selected program for file sending.
CONTROL_PROGRAM="" #Selected program for remote control.
PWD="$(which pwd)"
GREP="$(which grep)"
STAT="$(which stat)"
COMAND=""

#GLOBAL_VARIABLES
DIRECTORY=""
EXCLUDED_FILES="$TEMPORARY_FILE_NAME $CONFIGURATION_FILE_NAME $ECLUDE_FILE_NAME" #Files for grep exclusion.
HEAD="" #separated by space
DESTINATION=""
OPTIONS=""

WATCH_PERIOD="1"

LAST_MODIFICATION_TIME=""

APPLY_SEND=1

--------------------------------------------------------------------------------
#FUNCTIONS
function logi
{
if [ -f $LOG ]; then
echo "[INFO] [$DIRECTORY] [$(date +%x-%X)] $1" >> LOG
fi
}

function logw
{
if [ -f $LOG ]; then
echo "[WARNING] [$DIRECTORY] [$(date +%x-%X)] $1" >> LOG
fi
}

function loge
{
if [ -f $LOG ]; then
echo "[ERROR] [$DIRECTORY] [$(date +%x-%X)] $1" >> LOG
fi
}

function error_exit
{	
		
	
	if [ $# > 1 ]; then
		case $1 in
			1)
				loge "Program argumnet, is not a directory"
				exit 1
				;;
			*)
				loge "UNKNOWN ERROR"
				exit 200
		esac
	else
		exit 200
	fi
}

function verify_destination
{
	logw "<<Verify_destination>> is unimplemented.!!!"
	return 0
}

function verify_configuration
{

if ! [ -f ${DIRECTORY}/${CONFIGURATION_FILE_NAME} ]; then
#If not exist
  logw "Configuration file do not exist -- Genering new base file ${DIRECTORY}/${CONFIGURATION_FILE_NAME}"
   echo "
${WORD_PROGRAM_SENDING}${CHARACTER_CUT}scp
${WORD_PROGRAM_CONTROL}${CHARACTER_CUT}ssh
${WORD_DESTINATION}${CHARACTER_CUT}
${WORD_COMAND}${CHARACTER_CUT}
${WORD_OPTIONS}${CHARACTER_CUT}
${WORD_HEAD}${CHARACTER_CUT}
" > ${DIRECTORY}/${CONFIGURATION_FILE_NAME}

  APPLY_SEND=1
else
#if exist


  logi "Starting parsing data from configuration file ${DIRECTORY}/${CONFIGURATION_FILE_NAME}"
  while read line
  do
    case $(echo $line | cut -d${CHARACTER_CUT} -f1) in
	$WORD_PROGRAM_SENDING )
		SENDER_PROGRAM="$(echo $line | cut -d${CHARACTER_CUT} -f2)"
		SENDER_PROGRAM="$(which $SENDER_PROGRAM)"
		logw "SENDER_PROGRAM = $SENDER_PROGRAM"
	;;
	$WORD_PROGRAM_CONTROL )
		CONTROL_PROGRAM="$(echo $line | cut -d${CHARACTER_CUT} -f2)"
		CONTROL_PROGRAM="$(which $CONTROL_PROGRAM)"
		logw "CONTROL_PROGRAM = $CONTROL_PROGRAM"
	;;	
	$WORD_DESTINATION )
		DESTINATION="$(echo $line | cut -d${CHARACTER_CUT} -f2)"
		logw "DESTINATION = $DESTINATION"
	;;
	$WORD_COMAND )
		COMAND="$(echo $line | cut -d${CHARACTER_CUT} -f2)"
		COMAND="$(which $COMAND)"
		logw "COMAND = $COMAND"
	;;
	${WORD_OPTIONS} )
		OPTIONS="$(echo $line | cut -d${CHARACTER_CUT} -f2)"
		logw "OPTIONS = $OPTIONS"
	;;
	$WORD_HEAD )
		HEAD="$(echo $line | cut -d${CHARACTER_CUT} -f2)"
		logw "HEAD = $HEAD"
	;;
	* )
	#Do nothing	
    esac
  done < ${DIRECTORY}/${CONFIGURATION_FILE_NAME}
  #Verifi reden configurations -- You can send without execution of a command in destiny.
  #Must to be the sender and control programs, destination with directory and a head file.
  if [ -f $(which $SENDER_PROGRAM) -a -f $(which $CONTROL_PROGRAM) -a verify_destination $DESTINATION -a -f ${DIRECTORY}/${HEAD} ]; then
	APPLY_SEND=0 #We can send files.
  else
	APPLY_SEND=1 #We can not send files, configuration is not finalized.
  fi
fi

}

function verify_exclusion
{

if [ -f ${DIRECTORY}/${EXCLUDE_FILE_NAME} ]; then
  #Exist exclusion files

  logi "Starting parsing data from exclusion file ${DIRECTORY}/${CONFIGURATION_FILE_NAME}"
  while read line
  do
    EXCLUDED_FILES="${EXCLUDED_FILES} $line"
  done < ${DIRECTORY}/${EXCLUDE_FILE_NAME}
  logw "New exclusion list: $EXCLUDED_FILES"

else
#Not exist exclusion file

  logw "No Exclusion file"

fi;

}

function verify_programs
{

if ! [ -f $PWD ]; then
	loge "There is no PWD program."
	exit 100
fi
if ! [ -f $GREP ]; then
	loge "There is no GREP program."
	exit 100
fi
if ! [ -f $STAT ]; then
	loge "There is no STAT program."
	exit 100
fi
if ! [ -f $SENDER_PROGRAM ]; then
	loge "There is no SENDER_PROGRAM program."
	exit 100
fi
if ! [ -f $CONTROL_PROGRAM ]; then
	loge "There is no CONTROL_PROGRAM program."
	exit 100
fi
if ! [ -f $COMAND ]; then
	loge "There is no PWD program."
	exit 100
fi

}

function send_files_and_execute_comand
{
	#Here we will send files and then, execute the command. --- ONLY FOR CURRENT DIRECTORY
	files_to_send=$(ls ${DIRECTORY})
	for filter in $EXCLUDED_FILES; do
		files_to_send="$(echo $files_to_send | grep -v $filter)" 2> LOG	
	done
	logi "Files to send $files_to_send"
	$SENDER_PROGRAM $files_to_send $DESTINATION
	logi "Command is executing in remote machine : $COMAND"
	$CONTROL_PROGRAM $(echo $DESTINATION | cut -d ':' -f1) "$COMAND"
}
--------------------------------------------------------------------------------
#CODE
#1.Verify the arguments.
#2.Verify the configuration files (3) and installed programs.
#				--> If not exist, generate one.
#				--> If user try to send without well configured service, send error to log and do nothing.
#3.Verify is exist the temporal file --> I
#-NO--3.Save hash codes in a temporary file --> $TEMP/.$MYNAME_$(date)
#4.Every 1 second do:

#5.Verify last head files modification time --> If nothing new --> wait more.
#				            --> If some new, stop waiting.
#6. If stop waiting, get new files, send to the server and execute remoteli the compilation.
#7. Send results to last compilation file in Objective Directory of HEAD file.

#CREATION OF BASIC FILES
if ! [ -f $LOG ]; then
touch $LOG
fi

#VERIFICATIONS

#--ARGUMENTS--
#There is only one argument
if [ $# > 0 ]; then
	if [ -d $1 ]; then
		DIRECTORY=$1
	else
		error_exit 1
	fi
else
	DIRECTORY="$(pwd)"
fi


TEMPORARY_FILE_NAME="${TEMPORARY_FILE_NAME}$(echo $DIRECTORY | tr / _)"
#--TEMPORARY FILE--	REQUEST 1
if [ -f $TEMPORARY_FILE_NAME ]; then
	if [ $(ps -e | grep $(cat $TEMPORARY_FILE_NAME)) != "" ]; then
		loge "There is a demosn with that directory"
		exit 300							#----- EXIT	
	fi
fi
echo $$ > $TEMPORARY_FILE_NAME

#--CONFIGURATION FILES--
verify_configuration
verify_exclusion
verify_programs

#stat -c %x Hello.log
LAST_MODIFICATION_TIME="$(stat -c %x ${DIRECTORY}/${HEAD})"
logi "Starting with last modification in $LAST_MODIFICATION_TIME"
while true; do
sleep $WATCH_PERIOD

if [ -f ${DIRECTORY}/${HEAD} ]; then
	if [ "$LAST_MODIFICATION_TIME" != "$(stat -c %x ${DIRECTORY}/${HEAD})" ]; then
		LAST_MODIFICATION_TIME="$(stat -c %x ${DIRECTORY}/${HEAD})"
		logi "New modification $LAST_MODIFICATION_TIME -- sending and eecuting the command."
		#send_files_and_execute_comand
	fi
fi

done
