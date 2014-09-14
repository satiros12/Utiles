Autor: Stanislav	Version: 0.0.1		Fecha: 14/09/2014

FICHERO DE ARRANQUE: rcompil.sh
DEMONIO CONTROLADOR: drcompil.sh
Comprovodar de ficheros en una carpeta y durante su modificacion se enviarán a un servidor destino y se podrán compilar.
	--> Al arrancar espera a la primera modificación del archivo y solo podrá haber

Los ficheros deben de estar en una carpeta concreta y el servicio debe de funcionar como un demonio.
Al arrancar el demonio, se le indica la carpeta que debe de vigilar.
En la carpeta, habrá ficheros de configuración del demonio.
El demónio, leera esos ficheros siempre cuando vaya a enviar o ralizar alguna acción. 
En el fichero de configuración, aparecerán distintas partes:
	1. Configuración principal:
		Programas a utilizar de envío y de ejecución remota --> Por defecto es el "scp" y "ssh".
		Direccion + Directorio destino
		Comando a ejecutar tras el envío en la carpeta de forma remóta
		The head file --> File, after what change the daemon will perform that's functions.
	2. Archivos y Directorios que no se enviarán:
		Expresión regular de grep que se apliccarán en orden linea por linea.

Requests:
	1. Only one daemon can watch a directory situation.
		 LOCK FILE : New proces will watch the lock file content in /temp directory and, 
			if there is a proces watching about that directory, then this proces will auto finish.
			In other case it's write that's pid in to that file.
	2. There must to be at the last one HEAD file.
		HEAD file, is the file abouth what the daemon y active watching.
	3. User can specify the period of HEAD file integrity verification. -- (LOW LEVEL)
	4. The files seding must to get sub foder files that are not in the exclusion file to.
	5. Script, can not send files that are filtred by "grep" using the exclusion file lines 
		in down order of filter aplication and the configuration files of script.




Future steps:
	1. Include verification of files, if they changed or not in order to send them (by now, it is not necesary).
	2. Multiply head files.
	3. Make a plugin in order to pasively execute script without active daemon revision.
