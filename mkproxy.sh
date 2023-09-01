#!/bin/bash

echo ""

HOST1="172.16.2.11"
HOST2="172.16.199.20"
HOST3="172.16.199.40"
HOST4="none"

# selecting a proxy
index=1
InputChoice=1

# host and port array
HOSTS=($HOST1 $HOST2 $HOST3 $HOST4)
PORTS=(3128 8080 8080 "no poxy")

HOST=$?
PORT=$?

# display available proxy
echo "Please select one proxy :"

for i in ${!HOSTS[@]}; do
  HOST=${HOSTS[$i]}
  PORT=${PORTS[$i]}
  if [ $HOST = "none" ]; then
    echo $((i+1))")" $PORT
  else
    echo $((i+1))")" $HOST:$PORT
  fi
done

echo ""
read -p "Option : " InputChoice
echo ""

index=$((InputChoice-1))

# set proxy choice
if [ $InputChoice -ne 4 ]; then
  HOST=${HOSTS[$index]}
  PORT=${PORTS[$index]}
else
  HOST=${HOSTS[$index]}
fi

if [ $InputChoice -ne 4 ]; then
  echo -e "Selected Proxy : http://$HOST:$PORT\n"
fi


############## removing proxy settings from linux system files initiated ##############

# ~/.zshrc
sed -i '/export http_proxy/Id' $HOME/.zshrc
sed -i '/export https_proxy/Id' $HOME/.zshrc

# return if failed
if [ $? -ne 0 ] ; then
  return
fi

echo "removed proxy from ~/.zshrc"

# /etc/apt/apt.conf
sudo sed -i '/Acquire::http::Proxy/Id' /etc/apt/apt.conf
sudo sed -i '/Acquire::https::Proxy/Id' /etc/apt/apt.conf

# return if failed
if [ $? -ne 0 ] ; then
  return
fi

echo "removed proxy from /etc/apt/apt.conf"

# /etc/bash.bashrc
sudo sed -i '/export http_proxy/Id' /etc/bash.bashrc
sudo sed -i '/export https_proxy/Id' /etc/bash.bashrc

# return if failed
if [ $? -ne 0 ] ; then
  return
fi

echo "removed proxy from /etc/bash.bashrc"

# /etc/environment
sudo sed -i '/export http_proxy/Id' /etc/environment
sudo sed -i '/export https_proxy/Id' /etc/environment

# return if failed
if [ $? -ne 0 ] ; then
  return
fi

echo -e "removed proxy from /etc/environment\n"

############## removing proxy settings from linux system files done ##############


############# updating proxy settings in gsettings ############

if [ "$HOST" = "$HOST4" ]; then
  gsettings set org.gnome.system.proxy mode 'none'
  echo -e "updated proxy in gnome.system.proxy to 'none'\n"
else
  gsettings set org.gnome.system.proxy mode 'manual'

  # return if failed
  if [ $? -ne 0 ] ; then
    return
  fi

  # gnome http proxy
  gsettings set org.gnome.system.proxy.http host $HOST
  gsettings set org.gnome.system.proxy.http port $PORT
  # gnome https proxy
  gsettings set org.gnome.system.proxy.https host $HOST
  gsettings set org.gnome.system.proxy.https port $PORT

  echo -e "updated proxy in gnome.system.proxy to 'manual'\n"

fi

############# updating proxy settings in gsettings done ############

PROXY="http://$HOST:$PORT/"

############## updating proxy settings from linux system files initiated ##############

if [ $HOST != $HOST4 ]; then
  # echo $PROXY

  # ~/.zshrc
  echo "export http_proxy=$PROXY" | sudo tee -a $HOME/.zshrc >> /dev/null
  echo "export https_proxy=$PROXY" | sudo tee -a $HOME/.zshrc >> /dev/null

  # return if failed
  if [ $? -ne 0 ] ; then
    return
  fi
  echo "proxy updated in ~/.zshrc"

  # /etc/apt/apt.conf
  echo "Acquire::http::Proxy "\"$PROXY\"\; | sudo tee -a /etc/apt/apt.conf >> /dev/null
  echo "Acquire::https::Proxy "\"$PROXY\"\; | sudo tee -a /etc/apt/apt.conf >> /dev/null

  # return if failed
  if [ $? -ne 0 ] ; then
    return
  fi
  echo "proxy updated in /etc/apt/apt.conf"

  # /etc/bash.bashrc
  echo "export http_proxy=$PROXY" | sudo tee -a /etc/bash.bashrc >> /dev/null
  echo "export https_proxy=$PROXY" | sudo tee -a /etc/bash.bashrc >> /dev/null

  # return if failed
  if [ $? -ne 0 ] ; then
    return
  fi
  echo "proxy updated in /etc/bash.bashrc"

  # /etc/environment
  echo "export http_proxy=\"$PROXY\"" | sudo tee -a /etc/environment >> /dev/null
  echo "export https_proxy=\"$PROXY\"" | sudo tee -a /etc/environment >> /dev/null
  
  echo "proxy updated in /etc/environment"

fi

############## updating proxy settings from linux system files done ##############


############## updating proxy settings : git, yarn, npm ################

if [ $HOST != $HOST4 ]; then
  ### updating ###

  # git proxy update
  git config --global http.proxy $PROXY >> /dev/null
  git config --global https.proxy $PROXY >> /dev/null

  echo -e "proxy updated for git"

  # yarn proxy update
  yarn config set proxy $PROXY >> /dev/null
  yarn config set https-proxy $PROXY >> /dev/null

  echo -e "proxy updated for yarn"

  # npm proxy update
  npm config set proxy $PROXY >> /dev/null
  npm config set https-proxy $PROXY >> /dev/null

  echo -e "proxy updated for npm\n"
else
  ### removing ###

  # git proxy unset
  git config --global --unset http.proxy >> /dev/null
  git config --global --unset https.proxy >> /dev/null

  echo -e "removed proxy from git"

  # yarn proxy unset
  yarn config delete proxy >> /dev/null
  yarn config delete https-proxy >> /dev/null

  echo -e "removed proxy from yarn"

  # npm proxy unset
  npm config rm proxy >> /dev/null
  npm config rm https-proxy >> /dev/null

  echo -e "removed proxy from npm\n"
fi

############## updating proxy settings : git, yarn, npm done ################


echo -e "\nProxy Settings Updated! :)\n"


