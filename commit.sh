#!/bin/bash

read message 
[[ ${message} ]] && 
    {
        git add .
        git commit -a -m"$message"
        git push origin master  
    }

