#!/bin/bash

#Ctrl_c

function ctrl_c(){
    echo -e "\n[+] Saliendo..."
    tput cnorm
    exit 1
}

trap ctrl_c SIGINT

#Esconde el cursor
tput civis

#Ejecutable para los puertos
function portScan(){
    timeout 5 bash -c "exec 3<> /dev/tcp/192.168.1.$1/$2" 2>/dev/null

    if [ $? -eq 0 ]; then
        echo -e "\t[*] Host 192.168.1.$1 - puerto $2 (OPEN)"
    fi

    exec 3>&-
    exec 3<&-
}


for i in $(seq 1 254); do
    timeout 1 bash -c "ping -c 1 192.168.1.$i" &>/dev/null && echo -e "[+] Host 192.168.1.$i (Activo)"
    if [ $? -eq 0 ]; then
        for j in 21 22 23 80 443 8080 8081; do
            portScan $i $j &
        done
    fi
done
tput cnorm
wait
