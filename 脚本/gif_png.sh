#!/bin/bash
    if [ $# -eq 0 ]  
    then  
        echo "Usage: $0 files..." 1>&2  
        exit 1  
    fi  
     
    if ! type giftopnm 2>/dev/null  
    then  
        echo "$0: conversion tool giftopnm not found " 1>&2  
        exit 1  
    fi  
     
    # missing "in ..." defaults to in "$@"  
    for f  
    do  
        case "$f" in  
        *.gif)  
            # OK, do nothing  
            ;;  
        *)  
            echo "gif2png: skipping $f, not GIF"  
            continue  
            ;;  
        esac  
     
        dir=`dirname "$f"`  
        base=`basename "$f" .gif`  
        result="$dir/$base.png"  
     
        giftopnm "$f" | pnmtopng > $result && echo "wrote $result"  
    done


4.  计数 Counting


    if test $# = 1  
    then  
        start=1  
        finish=$1  
    elif test $# = 2  
    then  
        start=$1  
        finish=$2  
    else  
        echo "Usage: $0 <start> <finish>" 1>&2  
        exit 1  
    fi  
     
    for argument in "$@"  
    do  
        if echo "$argument"|egrep -v '^-?[0-9]+$' >/dev/null  
        then  
            echo "$0: argument '$argument' is not an integer" 1>&2  
            exit 1  
        fi  
    done  
     
    number=$start  
    while test $number -le $finish  
    do  
        echo $number  
        number=`expr $number + 1`    # or number=$(($number + 1))  
    done
