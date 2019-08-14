cd
mkdir server-unturned
apt-get install -y unzip tar curl coreutils lib32gcc1 libgdiplus mono-complete
cd server-unturned
wget https://ci.rocketmod.net/job/Rocket.Unturned/lastSuccessfulBuild/artifact/Rocket.Unturned/bin/Release/Rocket.zip
unzip Rocket.zip
mv /root/server-unturned/Scripts/Linux/start.sh /root/server-unturned/
mv /root/server-unturned/Scripts/Linux/update.sh /root/server-unturned/
mv /root/server-unturned/Scripts/Linux/RocketLauncher.exe /root/server-unturned/
rm Rocket.zip
chmod 755 start.sh
chmod 755 update.sh
./update.sh
cd /root/steamcmd
cp linux32/steamclient.so /lib
cp linux64/steamclient.so /lib64
cp linux64/steamclient.so /root/server-unturned/Unturned_Headless_Data/Plugins/x86_64/steamclient.so