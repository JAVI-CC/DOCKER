#!/bin/bash

###CREAR SERVIDOR SAMBA###

###FUNCION PARA ASSIGNARLE UNA CONTRASEÑA PARA EL SERVIDOR SAMBA###
function samba_add
{
    (echo "$PASSWORD"; echo "$PASSWORD") | smbpasswd -s -a $USER
}

###VARIABLES PARA CEAR USUARIO CONTRASEÑA Y EL PATH DE SAMBA###
USER='usuario'
PASSWORD='12345678'
SHARE=`mkdir /SAMBA`

###PERMISOS DEL PATH DE SAMBA####
chmod 777 /SAMBA

###INSTALAR REPOSITORIOS BASICOS PARA EL SERVIDOR SAMBA###
apt-get install -y --no-install-recommends && apt update -y && apt install -y samba && apt install -y nano

###CREANDO EL USUARIO Y LA CONTRASENYA QUE HE DECLARADO EN LA VARIABLE USER Y PASSWORD###
useradd $USER
(echo "$PASSWORD"; echo "$PASSWORD") | passwd  $USER

###CREANDO Y GESTIONANDO PERMISOS PARA EL GRUPO SMBUSERS###
groupadd smbusers
chown -R root:smbusers /SAMBA
usermod -G smbusers $USER

### LLAMANDO A LA FUNCION ###
samba_add


###COMENTANDO LOS PARAMETROS DE CONFIGURACION DE SMB.CONF ###
cat -n /etc/samba/smb.conf | sed -i '193,195 s/^/#/' /etc/samba/smb.conf
cat -n /etc/samba/smb.conf | sed -i '237,244 s/^/#/' /etc/samba/smb.conf
cat -n /etc/samba/smb.conf | sed -i '248,253 s/^/#/' /etc/samba/smb.conf
echo

###CONFIGURANDO LOS PARAMETROS DE CONFIGURACION DE SMB.CONF###
echo '  [COMPARTIR]' >> /etc/samba/smb.conf
echo '  comment = samba COMPARTIR ' >> /etc/samba/smb.conf
echo '  path = /SAMBA' >> /etc/samba/smb.conf
echo '  browseable = yes ' >> /etc/samba/smb.conf
echo '  guest ok = no ' >> /etc/samba/smb.conf
echo '  read only = no ' >> /etc/samba/smb.conf
echo '  create mask = 0777 ' >> /etc/samba/smb.conf
echo "  valid users = $USER " >>  /etc/samba/smb.conf
echo "  force user = $USER " >> /etc/samba/smb.conf
echo '  force group = smbusers ' >> /etc/samba/smb.conf

###LLAMANDO A LA FUNCION###
samba_add

###REINICIANDO SERVICIOS DEL SERVIDOR SAMBA###
/etc/init.d/samba restart
/etc/init.d/nmbd restart
