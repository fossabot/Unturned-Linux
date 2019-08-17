#!/bin/bash

erreur1='Contactez Julien sur Github via ce lien : https://github.com/julien040/Unturned-Linux'
#Premier message de Bienvenue
echo -e "\e[96mBonjour, et bienvenue dans le script d'installation de serveur Linux sur Unturned."

if [ -d $PWD/Unturned_Headless_Data ]
    then
    echo "Le serveur est déjà installé dans ce dossier, je vous invite donc à le mettre à jour"
    echo "Redirection vers le script de mise à jour dans 10s"
    ./update-server.sh

fi
sleep 2s
echo "Vous allez être guidé pas à pas du début de l'installation jusqu'à la finalisation du serveur"
echo "En cas de problème, merci de contacter Julien via https://github.com/julien040/Unturned-Linux"

#Attente afin de lire les messages
sleep 6s

#Avertissement
echo "Vous allez répondre à une suite de questions afin de personnaliser le serveur."
echo "Répondez y correctement afin de ne pas créer de bugs ; )"

#Attente afin de lire les messages
sleep 5s

#Installation des dépendences ou non
echo "Choisissez bien y ou n car le script pourrait être bloqué à cause de ça"
read -p "Avez vous déjà installé un serveur Unturned sur cette machine ? (y ou n)" yet

#Mise à jour des dépendences et installation si possible
if [ "$yet" = "n" ]
    then 
    echo "Puisque c'est la première installation d'un serveur Unturned, le script va installer les dépendences"
    apt-get update
    apt-get upgrade -y
    dpkg --add-architecture i386
    deb http://mirrors.linode.com/debian stretch main non-free
    deb-src http://mirrors.linode.com/debian stretch main non-free
    apt-get install -y unzip tar wget coreutils lib32gcc1 libgdiplus mono-complete scren steamcmd
    echo "Dépendences installées"
elif [ "$yet" = "y" ]
    then
    echo "Malgré que vous avez déjà installé Unturned sur cette machine, le script va mettre à jour les dépendences"
    apt-get update
    apt-get upgrade
    echo "Dépendences parfaitement mises à jour"
fi
#Choix du dossier d'installation
echo "Choisissez dans quel dossier installer le serveur Unturned ?(si aucun n'est indiqué, le serveur s'installera dans le dossier actuel"
read -p "Indiquez le chemin complet du dossier sinon Unturned s'installera dans le dossier actuel" folder
if [ -d $folder ]
    then
    echo "Le serveur sera installé dans $folder"

else 
    folder =`pwd`
    echo "Vous n'avez pas indiqué de dossier ou le dossier est inexistant. Le serveur sera donc installé dans $folder"

fi
#Choix du nom du serveur
read -p "Comment voulez-vous nommer le serveur ? " nameserver
echo "Dans le dossier /server , le serveur se nommera $nameserver"

#Choix obligatoire de RocketMod4 ou RocketMod5
echo "(Attention : RocketMod 5 est instable pour le moment)"
read -p "Souhaitez-vous un serveur sur RocketMod4 ou RockerMod5 (rm4 ou rm5) ?" servertype


#Réponse au choix de type de serveur
if [ "$servertype" = "rm4" ]
    then
    echo 'Le serveur sera sous RocketMod4'
elif [ "$servertype" = "rm5" ]
    then
    echo "Le serveur sera sous RocketMod 5 (instable)"

else 
    echo "Erreur dans le script à la ligne 62."
    echo "$erreur1"
fi

#Début de l'installation
echo "Le script va installer Unturned dans le dossier $folder"
sleep 2s
echo "Suivant la vitesse de votre connexion internet, cela peut prend plus ou moins de temps"
sleep 2s

#Téléchargement Steam
steamcmd.sh +login anonymous +force_install_dir $folder +app_update 1110390 validate +exit

echo "Steam vient de finir de télécharger Unturned !"
echo "Le script va maintenant installer RocketMod !"
sleep 5s

cd $folder

if [ "$servertype" = "rm4" ]
    then
    wget https://ci.rocketmod.net/job/Rocket.Unturned/lastSuccessfulBuild/artifact/Rocket.Unturned/bin/Release/Rocket.zip
    unzip Rocket.zip
    mv $folder/Scripts/Linux/* /$folder/
    rm -r $folder/Scripts/Linux
    rm -r $folder/Scripts/Windows
    rm Rocket.zip
    chmod 755 start.sh
    chmod 755 update.sh
    echo "RocketMod 4 vient d'être installé"
    sleep 3s

elif [ "$servertype" = "rm5" ]
    then
    wget https://ci.appveyor.com/api/buildjobs/bjt7acowdq73nh4u/artifacts/Rocket.Unturned-5.0.0.237.zip
    unzip Rocket.Unturned-5.0.0.237.zip
    mv $folder/Rocket.Unturned/ $folder/Modules/
    rm README.md
    rm Rocket.Unturned-5.0.0.237.zip
    echo "RocketMod 5 a été installé"
    sleep 3s

else 
    echo "Une erreur s'est produite. Impossible d'installer RocketMod"
    echo "$erreur1"

fi

cd $folder
if [ "$servertype" = "rm4" ]
    then
    echo "Démarrage du serveur"
    sleep 1s
    ./start.sh $nameserver
    exit 0

elif [ "$servertype" = "rm5" ]
    then
    echo "Démarrage du serveur"
    sleep 1s
    ./run-rm5.sh $nameserver
    exit 0
fi
exit