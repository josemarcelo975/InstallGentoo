#!/bin/bash

source /etc/profile
export PS1="(chroot) $PS1"
#Install gentoo snapshot
dialog \
 --title "Please wait..." \
 --infobox "Installing a portage snapshot" \
  5 40 ; sleep 3
emerge-webrsync
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
echo "$zone/$subzone" > /etc/timezone
emerge --config sys-libs/timezone-data
locales=$(dialog --title "Locales" --menu "Select the default language for your system" 20 35 15 \
'"aa_DJ.UTF-8 UTF-8"' "" '"af_ZA.UTF-8 UTF-8"' "" '"an_ES.UTF-8 UTF-8"' "" '"ar_AE.UTF-8 UTF-8'"" "" '"ar_BH.UTF-8 UTF-8"' "" '"ar_DZ.UTF-8 UTF-8"' "" '"ar_EG.UTF-8 UTF-8"' "" '"be_BY.UTF-8 UTF-8"' "" '"bg_BG.UTF-8 UTF-8"' "" '"bs_BA.UTF-8 UTF-8"' "" '"ca_ES.UTF-8 UTF-8"' "" '"da_DK.UTF-8 UTF-8"' "" '"de_DE.UTF-8 UTF-8"' "" '"el_GR.UTF-8 UTF-8"' "" '"en_US.UTF-8 UTF-8 "" '"fr_BE.UTF-8 UTF-8"'' "" \
fr_FR "" gd_GB "" hu_HU "" ja_JP "" ka_GE "" lg_UG "" mg_MG "" nn_NO "" oc_FR "" pl_PL "" pt_BR "" pt_PT "" ro_RO "" ru_RU "" sk_SK "" \
'"tg_TJ.UTF-8 UTF-8"' "" '"tr_TR.UTF-8 UTF-8"' "" '"uk_UA.UTF-8 UTF-8"' "" '"wa_BE.UTF-8 UTF-8"' "" '"yi_US.UTF-8 UTF-8"' "" '"zh_CN.UTF-8 UTF-8"' "" --stdout)
touch /etc/env.d/02locale
echo LANG=$locales >> /etc/env.d/02locale
echo LC_COLLATE="C" >> /etc/env.d/02locale
env-update && source /etc/profile && export PS1="(chroot) $PS1"
dialog --title "Kernel" --infobox "Installing kernel sources" 5 35 ;sleep 3
emerge gentoo-sources
cd /usr/src/linux
cat > /etc/fstab << EOF
# <fs>          <mountpoint>    <type>     <opts>      <dump/pass>
$partitionroot       /           ext4      noatime       0 1
$partitionswap       none        swap        sw          0 0
/dev/sr0             /mnt/cdrom  auto      noauto,ro     0 0
EOF
kernel=$(dialog --no-cancel --title "Kernel compilation" --menu "Choose the kernel build option" 20 45 15 \
menuconfig "Advanced user only" \
genkernel "For beginners" --stdout)
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
host=$(dialog --title "Hostname" --inputbox "Please,enter your hostname" 10 35 --stdout)
echo 'HOSTNAME="'$host'" ' > /etc/conf.d/hostname
dialog --infobox "Installing the package netifrc" 5 35 ;sleep 3
emerge netifrc
password=$(dialog --title "Password" \
 --passwordbox "Enter a password for the root user,you can not see the password" 15 45 --stdout)
 usermod -p $(openssl passwd -1 $password) root
 ETH0=$(ifconfig | head -1 | awk '{print $1}' | sed 's/://')
 cat > /etc/conf.d/net << EOF
 config_$ETH0="dhcp"
 EOF
 cd /etc/init.d
 ln -s net.lo net.$ETH0
 rc-update add net.$ETH0 default
 echo 'clock="local" ' > /etc/conf.d/hwclock
 dialog --infobox "Installing the system of log" 5 35 ;sleep 3
 emerge sysklogd
 rc-update add sysklogd default
 connect=$(dialog --yesno "use dhcp on your connection" 10 35 --stdout)
 if [ $connect = 0 ] ;
 then
 emerge dhcpcd
 fi
 dialog --msgbox "Install grub as boot loader" 10 35 ;sleep 3
 emerge grub:2
 grub-install /dev/sda
 grub-mkconfig -o /boot/grub/grub.cfg
 exit
 rm -r /mnt/gentoo/usr/bin
 rm -r /mnt/gentoo/usr/lib64/
 umount -l /mnt/gentoo/dev{/shm,/pts,}
 umount /mnt/gentoo{/boot,/sys,/proc,}
 dialog --msgbox "System Reboot" ;sleep 3
 reboot