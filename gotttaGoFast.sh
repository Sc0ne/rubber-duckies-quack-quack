#!/bin/bash

###Create folder for script logs/backups/etc.
echo "Creating GottaGoFast folder to store logs, file backups, and important info for later..."
mkdir GottaGoFast
cd GottaGoFast

###Unalias commands
aliases=$(alias)

# touch alias_info.txt
# echo -e "Currently set aliases:\n" >> alias_info.txt
# echo -e "$aliases" >> alias_info.txt
# echo -e "If a .bash_rc file is present it contained:\n"
# cat .bash_aliases >> alias_info.txt

echo "Alias information saved to alias_info.txt"

cat alias_info.txt
echo Delete aliases? y or n
read delAliases
if [ "$delAliases" == "n" ]; then
    rm .bash_aliases
    unalias -a
fi

###Delete SSH keys
for homeDir in /home/*/
do 
    if [ -d "$homeDir/.ssh" ]; then
        echo -e "Found .ssh keys"
        #red team uses these so dont delete them please
    fi
done

###Create our own SSH keys
sed -i 's/^#PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config
systemctl restart sshd
mkdir ~/.ssh
echo "Created our SSH keys! Be sure to copy private to local machine and then delete."

###Delete unwanted users
users=$(awk -F':' -v "limit=1000" '{ if ( $3 >= limit ) print $1}' /etc/passwd)
echo "New Password"
read newPassword
for user in $users
do 
    echo "Delete $user? y or n"
    read delUser
    if [ $delUser == "y" ]; then
        sudo iptables -F && sudo iptables -X && sudo iptables -P INPUT ACCEPT && sudo iptables -P FORWARD ACCEPT && sudo iptables -P OUTPUT ACCEPT
        #userdel -r "$user"
    else
        echo "changeme\n" | passwd $user
    fi

###Add/remove sudo privliges
users=$(awk -F':' -v "limit=1000" '{ if ( $3 >= limit ) print $1}' /etc/passwd)
for user in $users
do 
    echo "Should $user be in sudo/admin group? y or n"
    read sudoPrivs
    if [ "$sudoPrivs" == "y" ]; then
        usermod -aG sudo "$user"
    fi
done
echo "Remember to check visudo as well"

###Delete crontabs
for user in $users
do
    #crontab -r -u "$user" dont delete these please redteam uses them
    echo "Deleted cronjobs for $user"
done

###Set up ufw
apt-get install -y ufw
sudo ufw default allow incoming
sudo ufw default allow outgoing
echo "Allow ssh through ufw? y or n"
read allowSSH
if [ $allowSSH == "y" ]; then
    ufw allow ssh
fi
ufw allow ssh
echo "Enter all port numbers to allow connections through with a space between them:"
read ports

for port in $ports
do
    ufw allow "$port"
done

ufw enable

###Systemctl goodness
echo -e "# Controls IP packet forwarding\nnet.ipv4.ip_forward = 1\n\n"
echo -e "# IP Spoofing protection\nnet.ipv4.conf.all.rp_filter = 0\nnet.ipv4.conf.default.rp_filter = 0\n\n"
echo -e "# Ignore ICMP broadcast requests\nnet.ipv4.icmp_echo_ignore_broadcasts = 1\n\n"
echo -e "# Disable source packet routing\nnet.ipv4.conf.all.accept_source_route = 1\nnet.ipv6.conf.all.accept_source_route = 1\nnet.ipv4.conf.default.accept_source_route = 1\nnet.ipv6.conf.default.accept_source_route = 1\n\n"
echo -e "# Ignore send redirects\nnet.ipv4.conf.all.send_redirects = 0\nnet.ipv4.conf.default.send_redirects = 0\n\n"
echo -e "# Block SYN attacks\nnet.ipv4.tcp_syncookies = 1\nnet.ipv4.tcp_max_syn_backlog = 2048\nnet.ipv4.tcp_synack_retries = 2\nnet.ipv4.tcp_syn_retries = 5\n\n"
echo -e "# Ignore ICMP redirects\nnet.ipv4.conf.all.accept_redirects = 0\nnet.ipv6.conf.all.accept_redirects = 0\nnet.ipv4.conf.default.accept_redirects = 0\nnet.ipv6.conf.default.accept_redirects = 0\n\n"
echo -e "# Ignore Directed pings\nnet.ipv4.icmp_echo_ignore_all = 0\n\n"
echo -e "# Accept Redirects? No, this is not router\nnet.ipv4.conf.all.secure_redirects = 1\n\n"
echo -e "# Log packets with impossible addresses to kernel log? yes\nnet.ipv4.conf.default.secure_redirects = 1\n\n"

###Update packages
#apt-get update -qq
#apt-get upgrade -qq

##Clean up unused dependencies
#apt-get autoremove -y -qq

echo "Now go forth and check if your fridge is running and all that other stuff I know how to automate..."