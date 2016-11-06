username="$1"
adduser --disabled-password --gecos "" "$username"
mkdir -p /home/"$username"/.ssh
chmod 700 /home/"$username"/.ssh
curl https://github.com/"$username".keys > /home/"$username"/.ssh/authorized_keys
chmod 600 /home/"$username"/.ssh/authorized_keys
chown -R "$username":"$username" /home/"$username"/.ssh/