#!/bin/bash

#nab terminal width so we can center some text later!
terminal_width=$(tput cols)

quotes=("memento mori" "vulnerant omnes, ultima necat" "per aspera ad astra" "carpe diem" "dum spiro, spero" 
"fortis fortuna adiuvet" "labor omnia vincit" "errare humanum est" "nesce te ipsum" "acta non verba", "ex nihilo nihil"
"amor et melle et felle est fecundissimus" "esse quam videri" "a fronte praecipitium a tergo lupi" "spiritus intus alit" "virtus non stemma" 
"carpe nocte" "nihil verus est, omnem facere licet" "spectemur agendo" "de opresso liber" "disce aut discede" "post tenebras lux"
"aut inveniam viam aut faciam" "non scholae sed vita" "sapere aude" "scientia est lux lucis"

"Ecce! In pictura est puella, nomine Conrelia. Cornelia est puella Romana quae in Italia habitat."

)
translations=("remember you will die" "they all wound-- the last kills" "through hardship to the stars" "seize the day" 
"while I breathe I hope" "fortune favors the brave" "hard work conquers all" "to error is human" "know thyself" "actions not words", "nothing out of nothing"
"love is rich with both honey and venom" "to be rather than to seem" "a precipe in front, wolves behind" "spirits grows within" "virtue, not garland"
"seize the night" "nothing is true, everything is permitted" "let us be judged by our actions" "freedom from opression" "learn or leave" "after the shadows, light"
"I will either find a way or make one" "not for school but for life" "dare to know" "knowledge is the light of light"

":)"
)

colors=('\033[38;5;5m' '\033[38;5;6m' '\033[38;5;30m' '\033[38;5;34m' '\033[38;5;49m' '\033[38;5;50m'
'\033[38;5;51m' '\033[38;5;70m' '\033[38;5;155m ' '\033[38;5;225m'
)

#grab a random quote
length=${#quotes[@]}
index=$(( (RANDOM % $length) ))

#grab a random color
colors_length=${#colors[@]}
color_index=$(( RANDOM % colors_length ))
color="${colors[$color_index]}"
reset='\033[0m'

#format the quote to be all uppercase
quote=$(echo "${quotes[$index]}" | tr '[:lower:]' '[:upper:]')
quote=$(echo -e "${quote}")
translation=${translations[$index]}
translation=$(echo -e "~$translation~")

###OUTPUT###
for ((i=0; i<$terminal_width; i++)); do
    echo -ne "\033[38;5;${i}m*\033[0m"
done
echo -e "\n"

#find correct padding to center quote
text_length=${#quote}                
padding=$(( (terminal_width - $text_length) / 2)) 

#create padding
spaces=""
for ((i=0; i<$padding;i++)); do
    spaces+=" "
done

#print quote
echo -e "$spaces$color$quote$reset"
echo -e "$spaces\t$translation\n"

for ((i=0; i<$terminal_width; i++)); do
    echo -ne "\033[38;5;${i}m*\033[0m"
done
echo -e "\n"