#!/bin/bash
#Script realizado por Tarsicio Carrizales (Autor)
#Twitter: @tarsicio_tic
#   Mail: telecom.com.ve@gmail.com
#Éste Script no es una copia de Internet, fue desarrollado totalmente por su Autor:
#Usted utiliza este Script bajo su responsabilidad, debe realizar ajuste
#dependiendo de la distribución de Linux que utilice
#Éste Script está realizado para trabajar con Debian y/o Ubuntu
#Se instaló de forma exitosa en Ubuntu Versión 14.04 LTS
#Realizado bajo licencia GNU, 9 de Agosto del 2015 hora 20:24
#
#
#**************************************************************
#                     Bienvenido - Welcome
#**************************************************************
clear
echo "##########################################################################"
echo "                   Instalando y configurando Samba 4"
echo "                             FASE I/II"
echo "                       Como Directorio Activo"
echo "                    Linux - Windows Server 2008 R2"
echo "                             Venezuela"
echo "                              Año 2015"
echo "##########################################################################"
echo 
echo "Recuerde muy importante tener INTERNET en este equipo antes de Iniciar la Instalación"
echo
echo "##########################################################################"
echo "               Script realizado por Tarsicio Carrizales"
echo "                     Twitter: @tarsicio_tic"
echo "                        Mail: telecom.com.ve@gmail.com"
echo "###########################################################################"
echo
echo "Pulse una tecla para iniciar la Instalación Samba 4 AD Microsoft"; read Sigue
#**************************************************************
#                     Fin Bienvenido - Welcome End
#**************************************************************

#**************************************************************
#         Inicio   apt-get update y apt-get upgrade
#**************************************************************
apt-get update
apt-get upgrade
#**************************************************************
#              Fin apt-get y apt-get upgrade
#**************************************************************

#activar estas opciones si no está instalado el servidor ssh
#apt-get install openssh-server

#Editamos el fichero /etc/network/interfaces
clear
echo "Edite el fichero /etc/network/interfaces y escriba en él, ejemplo:"
echo "Recuerde que las buenas prácticas indican que el servidor debe tener IP Fija"
echo
echo "auto lo eth0"
echo "iface lo inet loopback"
echo "auto eth0"
echo "iface eth0 inet static"
echo "address 192.168.1.5"
echo "netmask 255.255.255.0"
echo "network 192.168.1.0"
echo "gateway 192.168.1.1"
echo "dns-nameservers 192.168.1.5 200.44.32.12 8.8.8.8"
echo "dns-search empresa.local"
echo
echo
echo "Pulse una tecla para continuar la instalación"; read Sigue
clear
#Editamos el fichero /etc/resolv.conf y añadimos lo siguiente
echo "Añadir al fichero /etc/resolv.conf lo siguiente"
echo "echo  domain EMPRESA.LOCAL >> /etc/resolv.conf"
echo  domain EMPRESA.LOCAL >> /etc/resolv.conf
echo
echo "El archivo debe quedar algo parecido a esto"
echo "search empresa.local"
echo "domain empresa.local"
echo "nameserver 192.168.1.5 ip del Servidor PDC"
echo "nameserver Otro DNS1"
echo "nameserver Otro DNS2"
echo
echo "****************** archivo /etc/resolv.conf ********************"
cat /etc/resolv.conf
echo
echo "Pulse una tecla para continuar pre-configurando"; read Sigue
clear
#-------------------------------------------------------------------
echo "edite el archivo /etc/hosts y realice el cambio pertinente"
echo
echo "Debe agregar una línea como la siguiente: debajo de 127.0.1.1"
echo "Comente la línea #127.0.1.1"
echo "172.16.30.60 nombre-equipo.dominio.ext nombre-equipo"
echo
echo "Pulse una tecla para continuar pre-configurando"; read Sigue
#-------------------------------------------------------------------
clear
#-------------------------------------------------------------------
echo "Realice el cambio en el archivo nombre equipo /etc/hostname"
echo
echo srv-pdc.empresa.local > /etc/hostname
#echo $Nombre > /etc/hostname
cat /etc/hostname
echo "/etc/init.d/networking restart"
/etc/init.d/networking restart
#-------------------------------------------------------------------
echo "Pulse una tecla para continuar la instalación"; read Sigue
#///////////////////////////////////////////////////////////////////////////////////
clear
#Editamos el fichero /etc/ntp.conf
apt-get install ntp
echo "Editamos el fichero /etc/ntp.conf para modificar los servidores de la hora"
echo
echo "En nuestro caso buscamos los servidores para venezuela en"
echo "http://www.pool.ntp.org/es/zone/ve"
echo
echo "server 0.south-america.pool.ntp.org"
echo "server 1.south-america.pool.ntp.org"
echo "server 2.south-america.pool.ntp.org"
echo "server 3.south-america.pool.ntp.org"
echo
echo
echo "Modifique el archivo, y luego pulse una tecla para continuar instalando"; read Sigue
/etc/init.d/ntp restart
#////////////////////////////////////////////////////////////////////////////////////////
apt-get install build-essential libacl1-dev python-dev libldap2-dev 
apt-get install pkg-config gdb libgnutls-dev libblkid-dev libreadline-dev 
apt-get install libattr1-dev python-dnspython libpopt-dev libbsd-dev acl attr 
apt-get install docbook-xsl libcups2-dev git
#apt-get install bind9
echo "Pulse una tecla para continuar, recuerde de configurar bind9 DNS si aplica en su caso"; read Sigue
#*****************************************************************************
#         En esta parte se monta manual el Samba o por Internet
#         Usted escoje lo que se le facilite Mejor
#*****************************************************************************
#Aquí bajamos el clone de Samba y lo copiamos en /usr/src/samba4
#debemos de desactivar la otra alternativa Samba tar.gz
#Sólo se debe instalar una, la mejor opción es la primera
#Pero en verdad me ha dado muchos problemas al bajar el clone.
#*****************************************************************************
#Ahora, obtenemos el código de SAMBA 4 del repositorio git
#git clone git://git.samba.org/samba.git /usr/src/samba4
#cd /usr/src/samba4
#./configure
#make
#make install
#-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

#******************************************************************************
# Alternativa, al directorio git
# Con esta alternativa funcionó bien
wget https://www.samba.org/samba/ftp/stable/samba-4.2.3.tar.gz
tar -xzvf samba-4.2.3.tar.gz
cd samba-4.2.3
./configure
make
make install
#******************************************************************************
 echo 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/samba/bin:/usr/local/samba/sbin"' > /etc/environment
clear

echo "La Máquina se reiniciará en 5 Segundos,"
echo "cuando inicie de nuevo utilice el archivo "
echo "Samba4Install2015_2.sh para culminar la instalación"
echo
echo
echo
echo "#######################################################################################################"
echo "Instalación culminada con éxito fase I/II Linux-Windows Server 2008 R2"
echo "########################################################################################################"
echo
echo "########################################################################################################"
echo "Script realizado por Tarsicio Carrizales Twitter:--> @tarsicio_tic Mail: telecom.com.ve@gmail.com"
echo "########################################################################################################"
sleep 5s
reboot now
exit
