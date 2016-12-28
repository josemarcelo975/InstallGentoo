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
keyboard=$(dialog --no-cancel --menu "Select Your Keyboard" 20 35 15 \
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

hd=$(dialog --nocancel --menu "HD on which to install the system" 10 40 15 \
`ĺsblk | grep "disk" | awk '{print "/dev/" $1 ORS"\b"}'` --stdout)
dialog \
 --title "Create Partitions" \
 --msgbox "In the label type select dos and create two partitions:ROOT and SWAP.\n\nmark ROOT as bootable and SWAP select 82 Linux swap / Solaris." \
  15 55
cfdisk $hd
partitionroot=$(dialog --no-cancel --menu "What is Your ROOT partition?" 0 0 0 \
`lsblk | grep "part" | awk '{print substr($1 ORS"\b",3)}'` --stdout)
yes | mkfs.ext4 /dev/$partitionroot >/dev/null
partitionswap=$(dialog --no-cancel --menu "What is Your SWAP partition?" 0 0 0 \
`lsblk | grep "part" | awk '{print substr($1 ORS"\b",3)}'` --stdout)
mkswap /dev/$partitionswap && swapon /dev/$partitionswap > /dev/null
mount /dev/$partitionroot /mnt/gentoo
day=$(dialog \
 --title "Date and Time" \
 --inputbox "Set in the following order:Month,Day,Time,Year.And without commas and spaces." \
 15 40 --stdout)
date $day
DIST_MIRROR="http://mirror.bytemark.co.uk/gentoo/"
_LATEST_STAGE3=$(curl -s $DIST_MIRROR/releases/amd64/autobuilds/latest-stage3-amd64.txt | tail -1 | awk '{print $1}')
_STAGE3_URI="$DIST_MIRROR/releases/amd64/autobuilds/$_LATEST_STAGE3"
_CHROOT="chroot /mnt/gentoo"
mkdir -p /mnt/gentoo
cd /mnt/gentoo
dialog \
 --title "Stage3" \
 --infobox "Download stage3,please wait..." \
 5 40 ; sleep 3
 wget $_STAGE3_URI
 dialog \
 --title "Please wait" \
 --infobox "Unpacking stage3,this may take a while" \
 5 45 ;sleep 3
 tar xvjpf stage3-*.tar.bz2 --xattrs
 rm stage3-*.tar.bz2
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
cp -L /etc/resolv.conf /mnt/gentoo/etc
mount -t proc proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev

dialog \
 --title "Please wait..." \
 --infobox "Installing a portage snapshot" \
  5 40 ; sleep 3
$_CHROOT emerge-webrsync
Profile=$(dialog \
--menu "Choose the profile of your system,define the flags for your system and some other settings" 25 40 25 \
1 "Default of System Gentoo" \
2 "Default selinux" \
3 "Desktop:Xfce,Mate,Lxde..." \
4 "Desktop Gnome Shell 3" \
5 "Desktop Gnome Shell 3 Systemd" \
6 "Desktop Kde" \
7 "Desktop Kde Plasma Systemd" \
8 "Desktop Kde Plasma 5" \
9 "Desktop Kde Plasma 5 Systemd" --stdout)
eselect profile set $Profile

zone=$(dialog --no-cancel --title "World zones" --menu "To set the system clock,please choose the World Zone of your location." 20 35 15 \
Africa "" America "" Antarctica "" Arctic "" Asia "" Atlantic "" Australia "" Brazil "" Canada "" Europe "" Indian "" Mexico "" Pacific "" US "" --stdout)
if [ $zone = Africa ] ;
	then
subzone=$(dialog --no-cancel --title "Cities in Africa" --menu "Now select your nearest city from this list." 20 35 15 \
Abidjan "" Accra "" Addis_Ababa "" Algiers "" Asmara "" Asmera "" Bamako "" Bangui "" Banjul "" Bissau "" Blantyre "" Brazzaville "" \
Bujumbura "" Cairo "" Casablanca "" Ceuta "" Conakry "" Dakar "" Dar_es_Salaam "" Djibouti "" Douala "" El_Aaiun "" Freetown "" Gaborone "" Harare "" Johannesburg "" Juba "" Kampala "" Khartoum "" Kigali "" \
Kinshasa "" Lagos "" Libreville "" Lome "" Luanda "" Lubumbashi "" Lusaka "" Malabo "" Maputo "" Maseru "" Mbabane "" Mogadishu "" Monrovia "" Nairobi "" Ndjamena "" Niamey "" Nouakchott "" Ouagadougou "" Porto-Novo "" \
Sao_Tome "" Timbuktu "" Tripoli "" Tunis "" Windhoek "" --stdout)
elif [ $zone = America ] ;
	then
subzone=$(dialog --no-cancel --title "Cities in America" --menu "Now select your nearest city from this list." 20 35 15 \
Adak "" Anchorage "" Anguilla "" Antigua "" Araguaina "" Aruba "" Asunction "" Atikokan "" Atka "" Bahia "" Bahia_Banderas "" Barbaros "" Belem "" Belize "" Blanc-Sablon "" Boa_Vista "" Bogota "" Boise "" Buenos_Aires "" Cambridge_Bay "" Campo_Grande "" Cancum "" Caracas "" Catamarca "" \
Cayenne "" Cayman "" Chicago "" Chihuahua "" Coral_Harbour "" Cordoba "" Costa_Rica "" Creston "" Cuiaba "" Curacao "" Danmarkshavn "" Dawson "" Dawson_Creek "" Denver "" Detroit "" Dominica "" Edmonton "" Eirunepe "" El_Salvador "" Ensenada "" Fort_Nelson "" Fort_Wayne "" Fortaleza "" Glace_Bay "" Godthab "" Goose_Bay "" \
Grand_Turk "" Grenada "" Guadeloupe "" Guatemala "" Guayaquil "" Guyana "" Halifax "" Havana "" Hermosillo "" Indianapolis "" Inuvik "" Iqaluit "" Jamaica "" Jujuy "" Juneau "" Knox_IN "" Kralendijk "" La_Paz "" Lima "" \
Los_Angeles "" Louisville "" Lower_Princes "" Maceio "" Managua "" Manaus "" Marigot "" Martinique "" Matamoros "" Mazatlan "" Mendoza "" Menominee "" Merida "" Metlakatla "" Mexico_City "" Miquelon "" Moncton "" Monterrey "" Montevideo "" Montreal "" Montserrat "" Nassau "" New_York "" Nipigon "" Nome "" Noronha "" Ojinaga "" Panama "" \
Pangnirtung "" Paramaribo "" Phoenix "" Port-au-Prince "" Port_of_spain "" Porto_Acre "" Porto_Velho "" Puerto_Rico "" Rainy_River "" Rankin_Inlet "" Recife "" Regina "" Resolute "" Rio_Branco "" Rosario "" Santa_Isabel "" Santarem "" Santiago "" Santo_Domingo "" Sao_Paulo "" Scoresbysund "" Shiprock "" Sitka "" St_Barthelemy "" St_Johns "" \
St_Kitts "" St_Lucia "" St_Thomas "" St_Vincent "" Swift_Current "" Tegucigalpa "" Thule "" Thunder_Bay "" Tijuana "" Toronto "" Tortola "" Vancouver "" Virgin "" Whitehorse "" Winnipeg "" Yakutat "" Yellowknife "" --stdout)
elif [ $zone = Antarctica ] ;
	then
subzone=$(dialog --no-cancel --title "Cities in Antarctica" --menu "Now select your nearest city from this list." 20 35 15 \
Casey "" Davis "" DumontDUrville "" Macquarie "" Mawson "" McMurdo "" Palmer "" Rothera "" South_Pole "" Troll "" Vostok "" --stdout)
elif [ $zone = Arctic ] ;
	then
subzone=$(dialog --no-cancel --title "Cities in Arctic" --menu "Now select your nearest city from this list." 20 35 15 \
Longyearbyen "" --stdout)
elif [ $zone = Asia ] ;
	then
subzone=$(dialog --no-cancel --title "Cities in Asia" --menu "Now select your nearest city from this list." 20 35 15 \
Aden "" Almaty "" Amman "" Anadyr "" Aqtau "" Aqtobe "" Ashgabat "" Ashkhabad "" Baghdad "" Bahrain "" Baku "" Bangkok "" Barnaul "" Beirut "" Bishkek "" Brunei "" Calcutta "" Chita "" Choibalsan "" Chongqing "" Chungking "" Colombo "" Dacca "" Damascus "" Dhaka "" Dili "" Dubai "" Dushanbe "" Gaza "" Harbin "" Hebron "" Ho_Chi_Minh "" Hong_Kong "" Hovd "" Irkutsk "" Istanbul "" Jakarta "" \
Jayapura "" Jerusalem "" Kabul "" Kamchatka "" Karachi "" Kashgar "" Kathmandu "" Katmandu "" Khandyga "" Kolkata "" Krasnoyarsk "" Kuala_Lumpur "" Kuching "" Kuwait "" Macao "" Macau "" Magadan "" Makassar "" Manila "" Muscat "" Nicosia "" Novokuznetsk "" Novosibirsk "" Omsk "" Oral "" Phnom_Pehn "" Pontianak "" Pyongyang "" Qatar "" Qyzylorda "" Rangoon "" Riyadh "" Saigon "" Sakhalin "" \
Samarkand "" Seoul "" Shanghai "" Singapore "" Srednekolymsk "" Taipei "" Tashkent "" Tbilisi "" Tehran "" Tel_Aviv "" Thimbu "" Thimphu "" Tokyo "" Tomsk "" Ujung_Pandang "" Ulaanbaatar "" Ulan_Bator "" Urumqi "" Ust-Nera "" Vientiane "" Vladivostok "" Yakutsk "" Yangon "" Yekaterinburg "" Yerevan "" --stdout)
elif [ $zone = Atlantic ] ;
	then
subzone=$(dialog --no-cancel --title "Cities in Atlantic" --menu "Now select your nearest city from this list." 20 35 15 \
Azores "" Bermuda "" Canary "" Cape_Verde "" Faeroe "" Faroe "" Jan_Mayen "" Madeira "" Reykjavik "" South_Georgia "" St_Helena "" Stanley "" --stdout)
elif [ $zone = Australia ] ;
	then
subzone=$(dialog --title "Cities in Australia" --menu "Now select your nearest city from this list." 20 35 15 \
ACT "" Adelaide "" Brisbane "" Broken_Hill "" Canberra "" Currie "" Darwin "" Eucla "" Hobart "" LHI "" Linderman "" Lord_Howe "" Melbourne "" NSW "" North "" Perth "" Queensland "" South "" Sydney "" Tasmania "" Victoria "" West "" Yancowinna "" --stdout)
elif [ $zone = Brazil ] ;
	then
subzone=$(dialog --no-cancel --title "Cities in Brazil" --menu "Now select your nearest city from this list." 20 35 15 \
Acre "" DeNoronha "" East "" West "" --stdout)
elif [ $zone = Canada ] ;
	then
subzone=$(dialog --no-cancel --title "Cities in Canada" --menu "Now select your nearest city from this list." 20 35 15 \
Atlantic "" Central "" East-Sashkatchewan "" Eastern "" Mountain "" Newfoundland "" Pacific "" Saskatchewan "" Yukon "" --stdout)
elif [ $zone = Europe ] ;
	then
subzone=$(dialog --no-cancel --title "Cities in Europe" --menu "Now select your nearest city from this list." 20 35 15 \
Amsterdam "" Andorra "" Astrakhan "" Athens "" Belfast "" Belgrade "" Berlim "" Bratislava "" Brussels "" Bucharest "" Budapest "" Busingen "" Chisinau "" Copenhagen "" Dublin "" Gibraltar "" Guernsey "" Helsinki "" Isle_of_Man "" Istanbul "" Jersey "" Kaliningrad "" Kiev "" Kirov "" Lisbon "" Ljubljana "" London "" Luxembourg "" Madrid "" Malta "" Mariehamn "" Minsk "" Monaco "" Moscow "" Nicosia "" Oslo "" Paris "" \
Podgorica "" Prague "" Riga "" Rome "" Samara "" San_Marino "" Sarajevo "" Simferopol "" Skopje "" Sofia "" Stockholm "" Tallinn "" Tirane "" Tiraspol "" Ulyanovsk "" Uzhgorod "" Vaduz "" Vatican "" Vienna "" Vilnius "" Volgograd "" Warsaw "" Zagreb "" Zaporozhye "" Zurich "" --stdout)
elif [ $zone = Indian ] ;
	then
subzone=$(dialog --no-cancel --title "Cities in Indian" --menu "Now select your nearest city from this list." 20 35 15 \
Antananarivo "" Chagos "" Christmas "" Cocos "" Comoro "" Kerguelen "" Mahe "" Maldives "" Mauritius "" Mayotte "" Reunion "" --stdout)
elif [ $zone = Mexico ] ;
	then
subzone=$(dialog --no-cancel --title "Cities in Mexico" --menu "Now select your nearest city from this list." 20 35 15 \
BajaNorte "" BajaSur "" General "" --stdout)
elif [ $zone = Pacific ] ;
	then
subzone=$(dialog --no-cancel --title "Cities in Pacific" --menu "Now select your nearest city from this list." 20 35 15 \
Apia "" Auckland "" Bougainville "" Chatham "" Chuuk "" Easter "" Efate "" Enderbury "" Fakaofo "" Fiji "" Funafuti "" Galapagos "" Gambier "" Guadalcanal "" Guam "" Honolulu "" Johnston "" Kiritimati "" Kosrae "" Kwajalein "" Majuro "" Marquesas "" Midway "" Nauru "" Niue "" Norfolk "" Noumea "" Pago_Pago "" Palau "" Pitcairn "" Pohnpei "" Ponape "" Port_Moresby "" Rarotonga "" Saipan "" Samoa "" Tahiti "" Tarawa "" \
Tongatapu "" Truk "" Wake "" Wallis "" Yap "" --stdout)
elif [ $zone = US ] ;
	then
subzone=$(dialog --no-cancel --title "Cities in US" --menu "Now select your nearest city from this list." 20 35 15 \
Alaska "" Aleutian "" Arizona "" Central "" East-Indiana "" Eastern "" Hawaii "" Indiana-Starke "" Michigan "" Mountain "" Pacific "" Pacific-New "" Samoa "" --stdout)
fi
echo "$zone/$subzone" > /mnt/gentoo/etc/timezone
$_CHROOT emerge --config sys-libs/timezone-data
locales=$(dialog --title "Locales" --menu "Select the default language for your system" 20 35 15 \
'"aa_DJ.UTF-8 UTF-8"' "" '"af_ZA.UTF-8 UTF-8"' "" '"an_ES.UTF-8 UTF-8"' "" '"ar_AE.UTF-8 UTF-8'"" "" '"ar_BH.UTF-8 UTF-8"' "" '"ar_DZ.UTF-8 UTF-8"' "" '"ar_EG.UTF-8 UTF-8"' "" '"be_BY.UTF-8 UTF-8"' "" '"bg_BG.UTF-8 UTF-8"' "" '"bs_BA.UTF-8 UTF-8"' "" '"ca_ES.UTF-8 UTF-8"' "" '"da_DK.UTF-8 UTF-8"' "" '"de_DE.UTF-8 UTF-8"' "" '"el_GR.UTF-8 UTF-8"' "" '"en_US.UTF-8 UTF-8"' "" '"fr_BE.UTF-8 UTF-8"' "" \
'"fr_FR.UTF-8 UTF-8"' "" '"gd_GB.UTF-8 UTF-8"' "" '"hu_HU.UTF-8 UTF-8"' "" '"ja_JP.UTF-8 UTF-8"' "" '"ka_GE.UTF-8 UTF-8"' "" '"lg_UG.UTF-8 UTF-8"' "" '"mg_MG.UTF-8 UTF-8"' "" '"nn_NO.UTF-8 UTF-8"' "" '"oc_FR.UTF-8 UTF-8"' "" '"pl_PL.UTF-8 UTF-8"' "" '"pt_BR.UTF-8 UTF-8"' "" '"pt_PT.UTF-8 UTF-8"' "" '"ro_RO.UTF-8 UTF-8"' "" '"ru_RU.UTF-8 UTF-8"' "" '"sk_SK.UTF-8 UTF-8"' "" \
'"tg_TJ.UTF-8 UTF-8"' "" '"tr_TR.UTF-8 UTF-8"' "" '"uk_UA.UTF-8 UTF-8"' "" '"wa_BE.UTF-8 UTF-8"' "" '"yi_US.UTF-8 UTF-8"' "" '"zh_CN.UTF-8 UTF-8"' "" --stdout)
touch /etc/env.d/02locale
echo LANG=$locales >> /mnt/gentoo/etc/env.d/02locale
echo LC_COLLATE='"C"' >> /mnt/gentoo/etc/env.d/02locale
cat > /mnt/gentoo/etc/fstab << EOF
# <fs>          <mountpoint>    <type>     <opts>      <dump/pass>
$partitionroot       /           ext4      noatime       0 1
$partitionswap       none        swap        sw          0 0
EOF

host=$(dialog --title "Hostname" --inputbox "Please,enter your hostname" 10 35 --stdout)
cat > /mnt/gentoo/etc/conf.d/hostname << EOF
hostname="$host"
EOF
dialog --infobox "Installing the package netifrc" 5 35 ;sleep 3
$_CHROOT emerge netifrc
ETH0=$(ifconfig | head -1 | awk '{print $1}' | sed 's/://')
cat > /mnt/gentoo/etc/conf.d/net << EOF
config_$ETH0="dhcp"
EOF
echo 'clock="local" ' > /etc/conf.d/hwclock
$_CHROOT /bin/bash << EOF
cd /etc/init.d
ln -s net.lo net.$ETH0
rc-update add net.$ETH0 default
EOF
dialog --infobox "Installing dhcp client" 5 35;sleep 3
$_CHROOT emerge net-misc/dhcpcd
password=$(dialog --title "Password" \
 --passwordbox "Enter a password for the root user,you can not see the password" 15 45 --stdout)
$_CHROOT usermod -p $(openssl passwd -1 $password) root
$_CHROOT /bin/bash << EOF
kernel=$(dialog --no-cancel --title "Kernel compilation" --menu "Choose the kernel build option" 20 45 15 \
menuconfig "Advanced user only" \
genkernel "For beginners,Incompatible with x86 architecture" --stdout)
if [ $kernel = menuconfig ] ;
 then
dialog --title "Compilation" --infobox "Compiling the modules,this can take a while" 10 35 ;sleep 3
make menuconfig
make && make modules_install
make install
elif [ $kernel = genkernel ] ;
 then
dialog --infobox "Installing genkernel,please wait" ;sleep 3
emerge genkernel
dialog --title "Compilation" --infobox "Wait while genkernel compiles the kernel for you" 10 35 ;sleep 3
genkernel all
fi
drivers=$(dialog --yesno "Would you like to install additional firmware(drivers)" 10 35 --sdout)
if [ $drivers = 0 ] ;
 then
emerge linux-firmware
fi
EOF
log=$(dialog --yesno "To install logging system?" 10 35 --stdout)
if [ $log = 0 ];
	then
$_CHROOT emerge sysklogd
fi

grub=$(dialog --yesno "Install grub as boot loader?" 10 35 --stdout)
if [ $grub = 0 ] ;
	then
$_CHROOT emerge sys-boot/grub:2
$_CHROOT grub-install $hd > /dev/null
$_CHROOT grub-mkconfig -o /boot/grub/grub.cfg > /dev/null
fi

cat > /mnt/gentoo/etc/conf.d/keymaps << EOF
keymap="$keymap"
windowkeys="YES"
dumpkeys_charset=""
fix_euro="NO"
EOF
cat > /mnt/gentoo/etc/conf.d/hwclock << EOF
clock="local"
clock_args=""
EOF
cd /
umount -l /mnt/gentoo/dev{/shm,/pts,} > /dev/null
umount /mnt/gentoo{/boot,/sys,/proc,} > /dev/null
dialog --title "Install is finished" \
 --msgbox "The installation finished!The system will reboot after this message,remove the installation media after reboot." 15 40
 reboot