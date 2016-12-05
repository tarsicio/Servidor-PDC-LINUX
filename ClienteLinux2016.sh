#!/bin/bash
#Script realizado por Tarsicio Carrizales (Autor)
#Twitter: @tarsicio_tic
#   Mail: telecom.com.ve@gmail.com
#Éste Script no es una copia de Internet, fue desarrollado totalmente por su Autor:
#Usted utiliza este Script bajo su responsabilidad, debe realizar ajuste
#dependiendo de la distribución de Linux que utilice
#Éste Script está realizado para trabajar con Debian y/o Ubuntu
#Se instaló de forma exitosa en Ubuntu Versión 14.04 LTS
#Realizado bajo licencia GNU, 21 de febrero del 2016 hora 13:06
#
#
#**************************************************************
#                     Bienvenido - Welcome
#**************************************************************
clear
echo "##########################################################################"
echo "                   Instalando y configurando cliente linux"
echo "                             Para integrarlo al"
echo "                             Directorio Activo"
echo "                           Windows Server 2008 R2"
echo "                                Venezuela"
echo "                                Año 2016"
echo "##########################################################################"
echo
echo
echo "##########################################################################"
echo "               Script realizado por Tarsicio Carrizales"
echo "                     Twitter:--> @tarsicio_tic"
echo "                  Mail: telecom.com.ve@gmail.com"
echo "###########################################################################"
echo
echo "Pulse una tecla para continuar con la Instalación cliente linux"; read Sigue
#**************************************************************
#                     Fin Bienvenido - Welcome End
#**************************************************************
clear
echo "Instalar la paquetería necesaria:"
apt-get install samba smbclient winbind krb5-user krb5-config
echo
echo "Agregar la IP de nuestro equipo Linux y la del Server Active Directory a /etc/hosts"
echo "Ejemplo"
echo "192.168.1.20 debian.pruebas.local debian"
echo "192.168.1.254 ad.pruebas.local ad"
echo "Pulse una tecla para continuar con la Instalación cliente linux"; read Sigue
echo "Configurar el cliente kerberos"
echo "Para configurar el cliente kerberos agregamos/modificamos las siguientes lineas a /etc/krb5.conf"
echo "[libdefaults]"
echo "     default_realm = PRUEBAS.LOCAL"
echo "     clockskew = 300"
echo "[realms]"
echo "     PRUEBAS.LOCAL = {"
echo "             kdc = 192.168.1.254"
echo "             default_domain = pruebas.local"
echo "             admin_server = 192.168.1.254"
echo "     }"
echo "     pruebas.local = {"
echo "             kdc = 192.168.1.254"
echo "             default_domain = pruebas.local"
echo "             admin_server = 192.168.1.254"
echo "    }"
echo "    pruebas = {"
echo "         kdc = 192.168.1.254"
echo "         default_domain = pruebas"
echo "         admin_server = 192.168.1.254"
echo "   }"
echo "[logging]"
echo "      kdc = FILE:/var/log/krb5/krb5kdc.log"
echo "      admin_server = FILE:/var/log/krb5/kadmind.log"
echo "      default = SYSLOG:NOTICE:DAEMON"
echo "[domain_realm]"
echo "      .pruebas = pruebas"
echo "      .pruebas.local = PRUEBAS.LOCAL"
echo "[appdefaults]"
echo "     pam = {"
echo "         ticket_lifetime = 1d"
echo "         renew_lifetime = 1d"
echo "         forwardable = true"
echo "         proxiable = false"
echo "         retain_after_close = false"
echo "         minimum_uid = 0"
echo "         try_first_pass = true"
echo "          }"
echo "Pulse una tecla para continuar con la Instalación cliente linux"; read Sigue
echo "Crear tickets Kerberos"
echo "Nos pedirá el password de la cuenta administrador del dominio. "
echo "Puede utilizarse cualquier cuenta con permisos administrativos en el dominio."
kinit administrador@dominio.local
echo "Pulse una tecla para continuar con la Instalación cliente linux"; read Sigue
clear
echo "Configurar samba"
echo "Editamos /etc/samba/smb.conf quedando algo parecido a lo siguiente:"
echo "[global]"
echo "   security = ADS"
echo "   netbios name = debian"
echo "   realm = PRUEBAS.LOCAL"
echo "   password server = ad.pruebas.local"
echo "   workgroup = PRUEBAS"
echo "   log level = 1"
echo "   syslog = 0"
echo "   idmap uid = 10000-29999"
echo "   idmap gid = 10000-29999"
echo "   winbind separator = +"
echo "   winbind enum users = yes"
echo "   winbind enum groups = yes"
echo "   winbind use default domain = yes"
echo "   template homedir = /home/%D/%U"
echo "   template shell = /bin/bash"
echo "   client use spnego = yes"
echo "   domain master = no"
echo "   server string = linux como cliente de AD"
echo "   encrypt passwords = yes"
# compartir el home del usuario solo para él cuando se encuentre en otro equipo de la red
echo "[homes]"
echo "    echocomment = Home Directories"
echo "    valid users = %S"
echo "    browseable = No"
echo "    read only = No"
echo "    inherit acls = Yes"
echo "[profiles]"
echo "    comment = Network Profiles Service"
echo "    path = %H"
echo "    read only = No"
echo "    store dos attributes = Yes"
echo "    create mask = 0600"
echo "    directory mask = 0700"
##compartir una carpeta para todos los usuarios
echo "[users]"
echo "    comment = All users"
echo "    path = /alguna/carpeta"
echo "    read only = No"
echo "    inherit acls = Yes"
echo "    veto files = /aquota.user/groups/shares/"
##compartir carpeta solo para el usuario spruebas
echo "[UnUsuario]"
echo "    comment = prueba con usuario del dominio"
echo "    inherit acls = Yes"
echo "    path = /ruta/de/alguna/carpeta/"
echo "    read only = No"
echo "    available = Yes"
echo "    browseable = Yes"
echo "    valid users = pruebas+spruebas"
echo "Pulse una tecla para continuar con la Instalación cliente linux"; read Sigue
clear
echo "Reiniciamos samba:"
testparm
/etc/init.d/samba restart
echo "Pulse una tecla para continuar con la Instalación cliente linux"; read Sigue
echo "Agregar Linux al dominio:"
net ads join -S ad.pruebas.local
-U administrador
echo 
echo "Nos deberá mostrar un mensaje como el siguiente:"
echo 
echo "Using short domain name -- PRUEBAS"
echo "Joined 'DEBIAN' to realm 'PRUEBAS.LOCAL'"
echo 
echo
echo "Si nos llega a mostrar un error como el siguiente:"
echo
echo
echo "Administrador's password:"
echo "[2007/08/25 16:58:33, 0] libsmb/cliconnect.c:cli_session_setup_spnego(785)"
echo "Kinit failed: Clock skew too great"
echo "Failed to join domain!"
echo
echo
echo "El problema puede ser que la hora del equipo con Linux no este configurada correctamente. Kerberos es muy"
echo "estricto con la hora. Para solucionarlo, corregimos la hora manualmente o ejecutamos el siguiente comando:"
ntpdate pool.ntp.org
echo "Pulse una tecla para continuar con la Instalación cliente linux"; read Sigue
clear
echo "Después de hacer esto ya se debería de poder unir al dominio."
echo "Resolver nombres de usuarios y grupos de dominio"
echo "Editar /etc/nsswitch.conf y modificar las siguientes lineas dejándolas así:"
echo
echo "passwd:  files winbind"         
echo "group:   files winbind"
echo "shadow:  files winbind"
echo "hosts:   files dns winbind" 
echo
echo "Gracias a las lineas anteriores los usuarios y grupos del dominio pueden ser resueltos."
echo "--> Reiniciamos winbind:"
/etc/init.d/winbind restart
echo
echo "Pulse una tecla para continuar con la Instalación cliente linux"; read Sigue
clear
echo "Hacer pruebas para ver si todo salio bien"
echo "Verificar la integración del dominio:"
echo "net rpc testjoin muestra si esta correctamente integrada al dominio:"
net rpc testjoin
echo
echo "deberia mostrar algo como---> Join to 'PRUEBAS' is OK"
echo
echo "net ads info muestra información del dominio:"
net ads info
echo
echo "net rpc info -U Usuario_de_dominio muestra el dominio al que pertenece, numero de usuarios, grupos, etc:"
net rpc info -U Usuario_de_dominio
echo
echo "Verificar que winbind este funcionando:"
echo
echo "wbinfo -u lista usuarios del dominio."
wbinfo -u
echo
echo "wbinfo -g lista grupos del dominio."
wbinfo -g
echo
echo "getent passwd muestra usuarios locales y del dominio."
getent passwd
echo
echo "getent group muestra grupos locales y del dominio."
getent group
echo 
echo "su usuario-de-dominio nos convertimos en usuario-de-dominio."
su usuario-de-dominio
echo "Pulse una tecla para continuar con la Instalación cliente linux"; read Sigue
clear
echo "Configurar la autenticación"
echo "Para configurar el acceso a usuarios del dominio a nuestro Linux mediante el entorno gráfico hay que configurar"
echo "pam. Para ello editamos los siguientes archivos y agregamos/modificamos las siguientes lineas:"
echo
echo "/etc/pam.d/common-account"
echo "       account sufficient  pam_winbind.so"
echo "       account required    pam_unix.so try_first_pass"
echo "/etc/pam.d/common-auth"
echo "       auth sufficient     pam_winbind.so"
echo "       auth required       pam_unix.so nullok_secure try_first_pass"
echo "/etc/pam.d/common-password"
echo "password sufficient        pam_winbind.so"
echo "password required          pam_unix.so nullok obscure min=4 max=8 md5 try_first_pass"
echo "/etc/pam.d/common-session"
echo "session required           pam_mkhomedir.so skel=/etc/skel/ umask=0022"
echo "session sufficient         pam_winbind.so"
echo "session required           pam_unix.so try_first_pass"
echo
echo "Pulse una tecla para continuar con la Instalación cliente linux"; read Sigue
clear
echo "El modulo pam_winbind.so le indica a pam que los usuarios y grupos los obtenga mediante winbind. El modulo"
echo "pam_mkhomedir.so nos crea el directorio home del usuario en caso de no existir."

echo "#######################################################################################################"
echo "Todas las pruebas estan correctas, está instalado el Cliente Linux en Directorio Activo utilizando SAMBA 4"
echo "########################################################################################################"
echo
echo "########################################################################################################"
echo "Script realizado por Tarsicio Carrizales Twitter:--> @tarsicio_tic Mail: telecom.com.ve@gmail.com"
echo "########################################################################################################"



