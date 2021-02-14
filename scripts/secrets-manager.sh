#!/usr/bin/zsh

SENSITIVE=$HOME/.kmds/sensitive
mkdir -p $SENSITIVE
cd $SENSITIVE



if [ "$1" = "help" ]
then
  echo "Secrets Manager"
  echo ""
  echo "$ secrets-manager [command]"
  echo ""
  echo "Commands"
  echo "  export-keys"
  echo "  import-keys"
  echo "  zip"
  echo "  unzip"
elif [ "$1" = "export-keys" ]
then
  echo "Exporting PGP"
  gpg -ao pgp.pub.key --export 0171B712E406271A
  gpg -ao pgp.key --export-secret-keys 0171B712E406271A

  echo "Exporting SSH"
  sudo cp $HOME/.ssh/id_rsa ssh.key
  sudo cp $HOME/.ssh/id_rsa.pub ssh.pub.key
elif [ "$1" = "import-keys" ]
then
  echo "Importing PGP"
  gpg --import pgp.pub.key
  gpg --allow-secret-key-import --import pgp.key

  echo "Importing SSH"
  sudo cp ssh.key $HOME/.ssh/id_rsa 
  sudo cp ssh.pub.key $HOME/.ssh/id_rsa.pub
elif [ "$1" = "zip" ]
then
  tar -cvf sensitive.tar $(fd -I --exclude '*.enc' .) 
  openssl enc -aes-256-cbc -in sensitive.tar -out sensitive.tar.enc -salt
  rm sensitive.tar
elif [ "$1" = "unzip" ]
then
  openssl enc -aes-256-cbc -in sensitive.tar.enc -out sensitive.tar -salt -d
  tar -xvf sensitive.tar
  rm sensitive.tar
fi
