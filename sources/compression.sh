#!/bin/bash

function compression()
{
#à modifier : faire une boite de dialogue plutot qu'un echo 
echo "Vous allez compresser $1"
$(tar -cvf "$1.tar" $1 2>/dev/null) 2>/dev/null 
$(gzip "$1.tar" ) 2>/dev/null
$(rm "$1.tar" 2>/dev/null) 2>/dev/null
}
