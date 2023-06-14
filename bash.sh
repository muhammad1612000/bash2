#!/bin/bash


function ServerCredintails(){
read -p "Enter Server User: " SERVER_USER
read -p "Enter IP Address: " IP
read -p "The Distantion Of (where you want to copy the file): " SERVER_DIR 
}

function CheckExitCode(){
if (($?==0));then
echo "SUCCESSFULL COMANND"
else
echo "Error : Check $1 file"
fi
}

function CompressFiles(){
if [[ -f ps.log && -f ram.log && -f disk.log && -f /var/log/dmesg ]]; then
echo "FILES EXISTED!"
tar -czvf logs.tar.gz ps.log  ram.log disk.log /var/log/dmesg
echo "FILES COMPRESSED!"
else
CheckExitCode /var/log/dmesg
fi
}

function CreateLogs(){
ps -f -u $USER > ./ps.log 2> ./ps.error
CheckExitCode ps.error

free > ./ram.log 2> ./ram.error
CheckExitCode ram.error


df -h | awk '{printf "%-10s%-20s\n", substr($0, 1 ,10), substr($0, 33, 50)}' > ./disk.log 2> ./disk.error
CheckExitCode disk.error
CompressFiles
}

CreateLogs
ServerCredintails
rsync -avzp --ignore-existing logs.tar.gz muhammad@127.0.0.10:$SERVER_DIR
