# ppup1090 
### The automated installation script given below, uses the set of pre-compiled executable binaries provided by PlanePlotter Group. You can download this set of pre-compiled binaries from here:</BR> https://www.coaa.co.uk/ppup1090-2024-06-11.zip

### The script given below installs PlanePlotter Uploader ppup1090 with Systemd on following:
- **Raspberry Pi 32-bit (armhf) & 64-bit (arm64) OS Buster, Bullseye, & Bookworm**
- **Ubuntu 20, 22 & 24 amd64 / x86_64**
- **Debian 11, 12 & 13 amd64 / x86_64**

### For automated installation, copy-paste following command in Terminal / Putty
`sudo bash -c "$(wget -O - https://github.com/abcd567a/ppup1090/raw/master/install-ppup.sh)" `

</br>

### When installation is completed, following annoncement will show:
</br>
INSTALLATION COMPLETED </br>
======================= </br>
PLEASE DO FOLLOWING: </br>
======================= </br>

(1) **Copy file `coaa.h` to folder /usr/share/ppup/** </br>
     NOTE: If you do not already have a `coaa.h` file,</br>
     or it has expired due to long priod of no use,</br>
     then request it from following address:</br>
       https://www.coaa.co.uk/rpi-request.htm
</br>

(2) Restart ppup1090 by following command:
</br>

 `sudo systemctl restart ppup1090 `

(3) Test ppup1090 status by following link</br>
     https://www.coaa.co.uk/rpiusers.php?authcode=123456789 </br>
     Instead of 123456789, use your authcode </br>
     (your authcode is available in file coaa.h) </br>

To see status: `sudo systemctl status ppup1090` </br>
To restart:    `sudo systemctl restart ppup1090` </br>
To stop:       `sudo systemctl stop ppup1090` </br>

