#!/bin/bash
echo "Vous allez compresser $1"
$(tar -cvf "$1.tar" $1 2>/dev/null) 2>/dev/null 
$(gzip "$1.tar" ) 2>/dev/null
$(rm "$1.tar" 2>/dev/null) 2>/dev/null
