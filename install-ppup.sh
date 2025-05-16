#!/bin/bash
VERSION=ppup1090-2024-06-11
INSTALL_FOLDER=/usr/share/ppup

echo " "
## Detect OS
OS_ID=`lsb_release -si`
OS_RELEASE=`lsb_release -sr`
OS_VERSION=`lsb_release -sc`
echo -e "\e[1;35mDETECTED OS VERSION \e[32m" ${OS_ID} ${OS_RELEASE} ${OS_VERSION}  "\e[39m"
ARCHITECTURE=`uname -m`
echo -e "\e[1;35mDetected architecture \e[1;32m" ${ARCHITECTURE}  "\e[39m"
echo " "
sleep 2
if [[ -d ${INSTALL_FOLDER} ]];
then
  if [[ -d ${INSTALL_FOLDER}-old ]];
  then
   rm -rf ${INSTALL_FOLDER}-old
  fi
echo -e "\e[32mRenaming existing folder" ${INSTALL_FOLDER} "by adding prefix \"old\" \e[39m"
INSTALL_FOLDER_OLD=${INSTALL_FOLDER}-old
mv ${INSTALL_FOLDER} ${INSTALL_FOLDER_OLD}
fi
echo " "
echo  -e "\e[1;35mCreating folder \e[1;32m" ${INSTALL_FOLDER}  "\e[39m"
mkdir ${INSTALL_FOLDER}
chmod 777 ${INSTALL_FOLDER}
sleep 2
echo " "
if [[ -d ${INSTALL_FOLDER_OLD} ]];
then
echo  -e "\e[1;32mCopying file coaa.h from old foder to new folder \e[39m"
sleep 2
cp  ${INSTALL_FOLDER_OLD}/coaa.h ${INSTALL_FOLDER}/
fi
echo " "

echo  -e "\e[1;35mDownloading compiled binaries \e[32m" ${VERSION}.zip "\e[1;35mfrom \e[32mcoaa.co.uk \e[39m"
sleep 2
wget -O ${INSTALL_FOLDER}/${VERSION}.zip https://www.coaa.co.uk/${VERSION}.zip

if [[ ! `dpkg-query -W unzip` ]]; then
  apt install -y --no-install-recommends unzip;
fi

echo -e "\e[1;32mUnzipping compiled binaries \e[39m"
sleep 2
unzip ${INSTALL_FOLDER}/${VERSION}.zip -d ${INSTALL_FOLDER}

echo -e "\e[1;32mDetecting which binary should be copied to" ${INSTALL_FOLDER} " \e[39m"
sleep 2
BINARY_FOLDER=""
if [[ ${OS_VERSION} == bookworm && ${ARCHITECTURE} == aarch64 ]]; then
   BINARY_FOLDER=Bookworm-64
   echo -e "\e[1;32mUsing Binary in Folder:" ${BINARY_FOLDER} "\e[39m";
   sleep 2;

elif [[ ${OS_VERSION} == bookworm && ${ARCHITECTURE} == armv7l ]]; then
   BINARY_FOLDER=Bookworm-32
   echo -e "\e[1;32mUsing Binary in Folder:" ${BINARY_FOLDER} "\e[39m";
   sleep 2;

elif [[ ${OS_VERSION} == bookworm && ${ARCHITECTURE} == x86_64 ]]; then
   BINARY_FOLDER=X86-64
   echo -e "\e[1;32mUsing Binary in Folder:" ${BINARY_FOLDER} "\e[39m";
   sleep 2;

elif [[ ${OS_VERSION} == trixie && ${ARCHITECTURE} == x86_64 ]]; then
   BINARY_FOLDER=X86-64
   echo -e "\e[1;32mUsing Binary in Folder:" ${BINARY_FOLDER} "\e[39m";
   sleep 2;

elif [[ ${OS_VERSION} == bullseye && ${ARCHITECTURE} == aarch64 ]]; then
   BINARY_FOLDER=Bullseye-64
   echo -e "\e[1;32mUsing Binary in Folder:" ${BINARY_FOLDER} "\e[39m";
   sleep 2;

elif [[ ${OS_VERSION} == bullseye && ${ARCHITECTURE} == armv7l ]]; then
   BINARY_FOLDER=Bullseye-32
   echo -e "\e[1;32mUsing Binary in Folder:" ${BINARY_FOLDER} "\e[39m";
   sleep 2;

elif [[ ${OS_VERSION} == buster && ${ARCHITECTURE} == armv7l ]]; then
   BINARY_FOLDER=Buster-32
   echo -e "\e[1;32mUsing Binary in Folder:" ${BINARY_FOLDER} "\e[39m";
   sleep 2;

elif [[ ${ARCHITECTURE} == i686 ]]; then
   BINARY_FOLDER=I686-32
   echo -e "\e[1;32mUsing Binary in Folder:" ${BINARY_FOLDER} "\e[39m";
   sleep 2;

elif [[ ${ARCHITECTURE} == x86_64 ]]; then
   BINARY_FOLDER=X86-64
   echo -e "\e[1;32mUsing Binary in Folder:" ${BINARY_FOLDER} "\e[39m";
   sleep 2;

else
  echo -e "\e[1;31mDo NOT have ppup1090 binary for your OS....aborting installation \e[39m"
  exit

fi

echo -e "\e[1;32mCopying binary to" ${INSTALL_FOLDER} " \e[39m"
sleep 2
cp ${INSTALL_FOLDER}/${BINARY_FOLDER}/ppup1090 ${INSTALL_FOLDER}/
echo "Making executable the binary" ${INSTALL_FOLDER}/ppup1090
chmod +x ${INSTALL_FOLDER}/ppup1090

echo -e "\e[1;32mCreating symlink to ppup1090 binary in folder /usr/bin/ \e[39m"
sleep 2
ln -s ${INSTALL_FOLDER}/ppup1090 /usr/bin/ppup1090

echo -e "\e[1;32mCreating config file ppup.conf \e[39m"
sleep 2
CONFIG_FILE=${INSTALL_FOLDER}/ppup.conf
touch ${CONFIG_FILE}
chmod 777 ${CONFIG_FILE}
echo "Writing code to config file ppup.conf"
/bin/cat <<EOM >${CONFIG_FILE}
## Make sure you have copied your file coaa.h to folder ${INSTALL_FOLDER}
--coaah ${INSTALL_FOLDER}/coaa.h
--modeac                    ## Enable decoding of SSR Modes 3/A & 3/C
#--nomodeac                 ## Disable decoding of SSR Modes 3/A & 3/C
--net-bo-ipaddr 127.0.0.1   ## TCP Beast output listen IPv4
--net-bo-port 30005         ## TCP Beast output listen port
--net-pp-ipaddr 0.0.0.0     ## Plane Plotter LAN IPv4 Address
#--quiet                    ## Disable output to stdout.

EOM
chmod 644 ${CONFIG_FILE}

echo -e "\e[1;32mCreating startup script file start.sh \e[39m"
sleep 2
SCRIPT_FILE=${INSTALL_FOLDER}/start.sh
touch ${SCRIPT_FILE}
chmod 777 ${SCRIPT_FILE}
echo "Writing code to startup script file start.sh"
/bin/cat <<EOM >${SCRIPT_FILE}
#!/bin/sh
CONFIG=""
a=""
b=""
while read -r line;
   do
      a="\$line";
      b="\${a%%#*}";
      if [[ -n "\${b}" ]]; then
        CONFIG="\${CONFIG} \${b}";
      fi
   done < ${CONFIG_FILE}
cd ${INSTALL_FOLDER}
ppup1090 \${CONFIG}
EOM
chmod +x ${SCRIPT_FILE}


echo "Creating User ppup to run ppup1090"
useradd --system ppup

echo "Assigning ownership of install folder to user ppup"
sudo chown ppup:ppup -R ${INSTALL_FOLDER}

echo -e "\e[1;32mCreating Service file ppup1090.service \e[39m"
sleep 2
SERVICE_FILE=/lib/systemd/system/ppup1090.service
touch ${SERVICE_FILE}
chmod 777 ${SERVICE_FILE}
/bin/cat <<EOM >${SERVICE_FILE}
# ppup1090 service for systemd

[Unit]
Description=ppup1090 Planeplotter uploader
After=network.target

[Service]
User=ppup
RuntimeDirectory=ppup1090
RuntimeDirectoryMode=0755
ExecStart=/bin/bash ${INSTALL_FOLDER}/start.sh
SyslogIdentifier=ppup1090
Type=simple
Restart=on-failure
RestartSec=30
RestartPreventExitStatus=64
Nice=-5

[Install]
WantedBy=default.target

EOM

chmod 644 ${SERVICE_FILE}
systemctl enable ppup1090
systemctl restart ppup1090

echo " "
echo " "
echo -e "\e[32mINSTALLATION COMPLETED \e[39m"
echo -e "\e[32m=======================\e[39m"
echo -e "\e[32mPLEASE DO FOLLOWING:\e[39m"
echo -e "\e[32m=======================\e[39m"
echo " "
echo -e "\e[33m  1. Use Systemd commands given below: \e[39m"
echo -e "\e[39m       sudo systemctl restart ppup1090 \e[39m"
echo -e "\e[39m       sudo systemctl status ppup1090 \e[39m"
echo " "
echo -e "\e[33m  2. Test ppup1090 status by following link \e[39m"
echo -e "\e[39m     https://www.coaa.co.uk/rpiusers.php?authcode=123456789 \e[39m"
echo -e "\e[95m     Instead of 123456789, use your authcode \e[39m"
echo -e "\e[95m     (your authcode is available in file coaa.h) \e[39m"
echo " "
echo -e "\e[1;31m  3. Copy file coaa.h to folder" ${INSTALL_FOLDER}"/  \e[39m"
echo -e "\e[95m     NOTE: If you do not already have a coaa.h file, \e[39m"
echo -e "\e[95m     or it has expired due to long priod of no use, \e[39m"
echo -e "\e[95m     then request it from following address: \e[39m"
echo -e "\e[39m       https://www.coaa.co.uk/rpi-request.htm \e[39m"
echo " "
echo -e "\e[1;33m  4. Config file is " ${INSTALL_FOLDER}"/ppup.conf  \e[39m"
echo -e "\e[35m     Contents of config file are as below:  \e[39m"
echo ""
echo -e "\e[1;34m       ## Make sure you have copied your file coaa.h to folder" ${INSTALL_FOLDER} "\e[39m"
echo -e "\e[39m       --coaah" ${INSTALL_FOLDER}"/coaa.h \e[39m"
echo -e "\e[39m       --modeac \e[39m"
echo -e "\e[1;34m       ## Other config parameters are given below.  \e[39m"
echo ""

