#!/bin/bash

echo "------------------------------Gentoo Easy Install Script--------------------------------------------------"
echo "---------------Please have patience and disable UEFI in bios----------------------------------------------" ;sleep 3
#Criado por josemarcelo: contato:josemarcelo975@gmail.com {Brasil}
#Script created only for amd64

dialog \
 --title "Test" \
 --infobox "Testing connection,please wait" \
 5 25 ;sleep 3
ping -c 3 www.gentoo.org
if [ $? = 0 ] ; then
dialog \
 --title "Connection worked" \
 --infobox "Connection stablished" \
  10 35 ;sleep 3
else dialog --title "Error" --infobox "No internet connection" 5 25 ; sleep 3
exit
fi

keyboard=$(dialog --no-cancel --menu "Select Your Keyboard" 0 0 0 \
bashkir "" bg_bds-cp1251 "" bg_bds-utf-8 "" bg_pho-cp1251 "" bg_pho-utf8 "" br-abnt "" br-abnt2 "" br-latin1-abnt2 "" \
br-latin1-us "" by-cp1251 "" by "" bywin-cp1251 "" cf "" cz-cp1250 "" cz-lat2-prog "" cz-lat2 "" cz-qwerty "" \
defkeymap "" defkeymap_V1.0 "" dk-latin1 "" dk "" emacs "" emacs2 "" es-cp850 "" es "" et-nodeadkeys "" \
et "" gr-pc "" gr "" hu101 "" il-heb "" il-phonetic "" il "" is-latin1-us "" it-ibm "" it "" it2 "" \
jp106 "" kazakh "" ky_alt_sh-UTF-8 "" kyrgyz "" la-latin1 "" lt.baltic "" lt.l4 "" lt "" lv-tilde "" lv "" \
mk-cp1251 "" mk-utf "" mk "" mk0 "" nl2 "" no-latin1 "" no "" pc110 "" pl "" pl1 "" pl2 "" pl3 "" pl4 "" \
pt-latin-1 "" pt-latin9 "" ro "" ro_win "" ru-cp1251 "" ru-ms "" ru-yawerty "" ru "" ru1 "" ru2 "" \
ru3 "" ru4 "" ru_win "" ruwin_alt-CP1251 "" ruwin_alt-KOI8-R "" ruwin_alt-UTF-8 "" ruwin_alt_sh-UTF-8 "" ruwin_cplk-CP1251 "" \
ruwin_cplk-KOI8-R "" ruwin_cplk-UTF-8 "" ruwin_ct_sh-CP1251 "" ruwin_ct_sh-KOI8-R "" ruwin_ct_sh-UTF-8 "" ruwin_ctrl-CP1251 "" \
ruwin_ctrl-KOI8-R "" ruwin_ctrl-UTF-8 "" se-ir209 "" se-lat6 "" sk-prog-qwerty "" sk-qwerty "" \
sr-cy "" sv-cy "" sv-latin1 "" tj_alt-UTF8 "" tr_q-latin5 "" tralt "" trf "" trq "" ttwin_alt-UTF-8 "" \
ttwin_cplk-UTF-8 "" ttwin_ct_sh-UTF-8 "" ttwin_ctrl-UTF-8 "" ua-cp1251 "" ua-utf-ws "" ua-utf "" ua-ws "" ua "" \
uk "" us-acentos "" --stdout)
loadkeys $keyboard

dialog --no-cancel --menu "HD on which to install the system" 10 40 15 \
/dev/sda ""
dialog \
 --title "Create Partitions" \
 --msgbox "In the label type select two and create two primary partitions: ROOT and SWAP.mark ROOT as bootable and SWAP select 82 Linux swap / Solaris." \
  15 55
cfdisk
partitionroot=$(dialog --no-cancel --menu "What is Your ROOT partition?" 0 0 0 \
/dev/sda1 "" \
/dev/sda2 "" --stdout)
yes | mkfs.ext4 $partitionroot
partitionswap=$(dialog --no-cancel --menu "What is Your SWAP partition?" 0 0 0 \
/dev/sda1 "" \
/dev/sda2 "" --stdout)
mkswap $partitionswap && swapon $partitionswap
mount $partitionroot /mnt/gentoo
day=$(dialog \
 --title "Date and Time" \
 --inputbox "Set in the following order:Month,Day,Time,Year.And without commas and spaces." \
 15 40 --stdout)
date $day
cd /mnt/gentoo
dialog \
 --title "Stage3" \
 --infobox "Download stage3,please wait..." \
 5 40 ; sleep 3
links https://www.gentoo.org/downloads/mirrrors/
dialog \
 --title "Please wait" \
 --infobox "Unpacking stage3,this may take a while" \
 5 45 ;sleep 3
tar xvjpf stage3-*.tar.bz2 --xattrs
_cores=$(($(nproc) + 1))
cat > /mnt/gentoo/etc/portage/make.conf << EOF
CFLAGS="-march=native -02 -pipe"
CXXFLAGS="\${CFLAGS}"
MAKEOPTS="-j$_cores"
CHOST="x86_64-pc-linux-gnu"
PORTDIR="/usr/portage"
DISTDIR="\${PORTDIR}/distfiles"
PKGDIR="\${PORTDIR}/packages"
USE="bindist python pulseaudio"
ACCEPT_LICENSE="* -@EULA"
CPU_FLAGS_X86="mmx sse sse2"
EOF
mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf
mkdir /mnt/gentoo/etc/portage/repos.conf
cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
cp -L /etc/resolv.conf /mnt/gentoo/etc/
mount -t proc proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev
cp /usr/bin/dialog /mnt/gentoo/usr/bin
cp /mnt/livecd/usr/lib64/libdialog.so.13 /mnt/gentoo/usr/lib64
#Move second install script
mv /root/InstallGentoo-master/Install-Gentoo2.sh /mnt/gentoo
chroot /mnt/gentoo /bin/bash ./Install-Gentoo2.sh
