#!/bin/bash

# Verifică dacă au fost furnizați cei doi parametri
if [ "$#" -ne 2 ]; then
    echo "Utilizare: $0 <github_user> <local_user>"
    exit 1
fi

# Parametrii de intrare
USER_GITHUB=$1  # Numele de utilizator GitHub (primul parametru)
USER_LOCAL=$2   # Numele de utilizator local pe server (al doilea parametru)

# Setează calea corectă pentru directorul .ssh în funcție de utilizatorul local
if [ "$USER_LOCAL" == "root" ]; then
    SSH_DIR="/root/.ssh"
else
    SSH_DIR="/home/$USER_LOCAL/.ssh"
fi

# Creează directorul .ssh dacă nu există deja
mkdir -p $SSH_DIR

# Obține și adaugă cheile SSH din GitHub în authorized_keys
curl https://github.com/$USER_GITHUB.keys >> $SSH_DIR/authorized_keys

# Setează proprietarul corect al fișierelor și permisiunile
# if [ "$USER_LOCAL" == "root" ]; then
#     chown root:root $SSH_DIR/authorized_keys
# else
    chown $USER_LOCAL:$USER_LOCAL $SSH_DIR/authorized_keys
# fi

chmod 600 $SSH_DIR/authorized_keys
chmod 700 $SSH_DIR

echo "Cheile SSH de la utilizatorul GitHub $USER_GITHUB au fost importate pentru utilizatorul local $USER_LOCAL."
