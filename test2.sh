if [ $(dpkg-query -W -f='${Status}' checkinstall 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
 sudo apt-get install checkinstall;
fi