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
echo "                             FASE II/II"
echo "                       Como Directorio Activo"
echo "                   Linux - Windows Server 2008 R2"
echo "                             Venezuela"
echo "                              Año 2015"
echo "##########################################################################"
echo
echo
echo "##########################################################################"
echo "               Script realizado por Tarsicio Carrizales"
echo "                     Twitter:--> @tarsicio_tic"
echo "                  Mail: telecom.com.ve@gmail.com"
echo "###########################################################################"
echo
echo "Pulse una tecla para continuar con la Instalación Samba 4 AD Microsoft"; read Sigue
#**************************************************************
#                     Fin Bienvenido - Welcome End
#**************************************************************
clear
samba -V
echo "Pulse una tecla para continuar con la instalación"; read Sigue
/usr/local/samba/bin/samba-tool domain provision --host-name=srv-pdc --realm=EMPRESA.LOCAL --domain=EMPRESA --server-role=dc --dns-backend=SAMBA_INTERNAL --adminpass='T1dominio123' --function-level=2008_R2 --use-rfc2307 --use-xattrs=yes
# Mostramos el contenido del presente archivo para que se verifique como quedó
clear
echo "cat /usr/local/samba/etc/smb.conf"
echo "Verifique los datos que correspondan y estén correctos"
echo "El archivo le debe quedar algo parecido a esto"
echo
echo "Al final del archivo incluir los datos para los [Perfiles] móviles"
echo "y [Home] para los datos a guardar en el servidor de los usuarios en Z:\\ejemplo"
echo "Recuerde que luego debe dar permiso de lectura y escritura para que los usuarios"
echo "puedan guardar los archivos y perfiles"
echo
echo
echo cat /usr/local/samba/etc/smb.conf 
echo
echo "# Global parameters Datos de Ejemplo"
echo "[global]"
echo	"workgroup = EMPRESA"
echo	"realm = EMPRESA.LOCAL"
echo	"netbios name = SRV-PDC"
echo	"server role = active directory domain controller"
echo	"dns forwarder = 172.16.30.60"
echo	"idmap_ldb:use rfc2307 = yes"
echo
echo "[netlogon]"
echo	"path = /usr/local/samba/var/locks/sysvol/empresa.local/scripts"
echo	"read only = No"
echo
echo "[sysvol]"
echo	"path = /usr/local/samba/var/locks/sysvol"
echo	"read only = No"
echo "[perfiles]"
echo	"path = /usr/local/samba/var/perfiles"
echo	"read only = No"
echo "[home]"
echo	"path = /home"
echo	"read only = No"
echo
echo
echo "Pulse una tecla para continuar con la Instalación Kerberos"
echo "Recuerde que durante este proceso se le presentarán tres (3) Ventanas"
echo "En la primera teclee el dominio Ejemplo: EMPRESA.LOCAL, todo en Mayúscula"
echo "En la segunda teclee el equipo: SRV-PDC.EMPRESA.LOCAL, todo en Mayúscula  "
echo "y en la tercera Ventana teclee Ejemplo: SRV-PDC.EMPRESA.LOCAL, todo en Mayúscula"; read Sigue

#Ahora instalamos el servicio Kerberos y la utilidad del cliente
apt-get install krb5-user

#Arrancamos el servicio de Samba:
/usr/local/samba/sbin/samba start

echo
echo "La Instalación Culminó, se inicia los pasos de Prueba, atento en los siguientes pasos."
echo "recuerde una vez culmine la intalación y se reinicie el servidor, inicie el servicio de Samba"
echo
echo "Pulse una tecla para continuar"; read Sigue
#Realizamos algunas prueba. para comprobar el funcionamiento:
#del DNS. Este recurso es importante que funcione bien.
clear
#-------------------------------------------------------------------------------------------------------------

host -t SRV _ldap._tcp.empresa.local.
host -t SRV _kerberos._udp.empresa.local.
host -t A srv-pdc.empresa.local.
echo
echo
echo "Deberia mostrar algo parecido a esto, compare la tres líneas"
echo "_ldap._tcp.empresa.local has SRV record # ### ### srv-pdc.empresa.local."
echo "_kerberos._udp.empresa.local has SRV record # ### ### srv-pdc.empresa.local."
echo "srv-pdc.empresa.local has address 172.16.30.60"
echo
echo "Si le sale un error parecido a  not found 3(NXDOMAIN)"
echo "Edite el archivo /usr/local/samba/share/setup/krb5.conf"
echo "y modifique $(REALM) por Ejemplo: EMPRESA.LOCAL"
#-------------------------------------------------------------------------------------------------------------
echo "Pulse una tecla para continuar Verificando la Instalación"; read Sigue
clear
#La configuración de kerberos
echo "Coloca la clave T1dominio123 o la que colocó cuando instaló el Demonio Samba"
kinit administrator@EMPRESA.LOCAL
echo
echo "Debe aparecerle algo parecido a esto:"
echo "Password for administrator@SMBTEST.LOCAL:"
echo "Warning: Your password will expire in 41 days on Thu Dec 12 12:58:33 2013"
echo
echo
echo "Pulse una tecla para continuar Verificando la Instalación"; read Sigue
clear
#Probamos la conectividad con el servidor SAMBA (Directorio Activo)
smbclient -L localhost -U%
echo "Pulse una tecla para continuar con la Verificación"; read Sigue
clear
#Probamos la conexión con la cuenta administrador y el recurso netlogon
smbclient //localhost/netlogon -UAdministrator -c 'ls'
echo
echo "Pulse una tecla para continuar";read Sigue
clear 
echo "edite /usr/local/samba/share/setup/krb5.conf para modificar"
echo "Remplace $(REALM) por EMPRESA.LOCAL"
echo 
echo "Instalando NFS para compartir Archivos y dar permisos "
echo "apt-get install nfs-common nfs-kernel-server"
apt-get install nfs-common nfs-kernel-server
echo 
echo "Pulse una tecla para continuar";read Sigue
echo
echo "// Archivo de configuración del servidor NFS /etc/exports"
echo "debe incluir al final, las Carpetas o Diretorios a Compartir"
echo 
echo "/home 172.16.30.0/24(rw)"
echo "/tmp *(ro)"
echo "/usr/local/samba/var/perfiles/ 172.16.30.0/24(rw)"
echo
echo "Recuerde que rw = Lectura Escritura y ro = Sólo Lectura"
echo "También puede poner a compartir con un equipo en especial, si se requiere"
echo
echo "Pulse una tecla para culminar la Instalación Samba4 Microsoft, Bajo Linux"
echo "Gracias por utilizar este instalador, espero que le haya ayudado en su proyecto"
echo "Recuerde instalar la Zona reversa una vez instale RSAT de Windows o si lo prefiere instálelo manual por linux"
echo "También haga el link Simbólico para iniciar automáticamente Samba /etc/init.d/samba start"; read Sigue
clear
update-rc.d samba start 15 2 3 4 5 . stop 85 0 1 6 .
echo "#######################################################################################################"
echo "Todas las pruebas estan correctas, está instalado el Directorio Activo utilizando SAMBA 4"
echo "Ahora, puedes unir un cliente Windows (XP, Win7, Win8, win10 y Linux al dominio"
echo "También puedes instalar las herramienta Administrativas de Servidor de Microsoft (RSAT),"
echo "http://www.microsoft.com/es-es/download/details.aspx?id=7887  para Windows 7"
echo "http://www.microsoft.com/es-es/download/details.aspx?id=28972 Para Windows 8"
echo "para gestionar el Directorio Activo: Usuarios y Equipos de Active Directory, DNS y Políticas de Grupo"
echo "########################################################################################################"
echo
echo "########################################################################################################"
echo "Script realizado por Tarsicio Carrizales Twitter:--> @tarsicio_tic Mail: telecom.com.ve@gmail.com"
echo "########################################################################################################"
exit

