#!/bin/bash
SCRIPTNAME=${0##*/}
LIBRARIES="jquery zepto backbone underscore prototype require raphael"

txtund=$(tput sgr 0 1)    # Underline
txtbld=$(tput bold)       # Bold
txtred=$(tput setaf 1)    # Red
txtgrn=$(tput setaf 2)    # Green
txtylw=$(tput setaf 3)    # Yellow
txtblu=$(tput setaf 4)    # Blue
txtrst=$(tput sgr0)       # Text reset

function usage() {
    echo "${txtund}Usage:${txtrst} $SCRIPTNAME LIBRARY [DESTINATION]"
    echo
    echo "Libraries available:"
    for LIB in $LIBRARIES
    do
        echo " ${txtbld}›${txtrst} $LIB"
    done
    exit 2
}

if [ -z "$1" ] || [ "$1" == "--help" ] || [ "$1" == "-h" ]
then
    usage
fi

if [ -n "$2" ]
then
    DESTINATION=$2
else
    DESTINATION=""
fi

function check_exists() {
    if [ -e $1 ]
    then
        read -p "${txtylw}${txtbld}$1 exists. Overwrite [yN]?${txtrst} " REALLY
        if [ "$REALLY" != "y" ]
        then
            exit 99
        fi
    fi
}

function simple_get() {
    getting $3
    check_exists $2
    curl -sL $1 > $2
    downloaded $3 $2
}

function getting() {
    echo "${txtblu}${txtbld}Getting $1 …${txtrst}"
}

function downloaded() {
    echo "${txtgrn}${txtbld}$1 downloaded and saved as $2.${txtrst}"
}

case $1 in
    jquery)
        [[ -n "$DESTINATION" ]] && FILENAME=$DESTINATION || FILENAME="jquery.min.js"
        simple_get "http://code.jquery.com/jquery.min.js" $FILENAME "jQuery"
        ;;
    zepto|zeptojs)
        [[ -n "$DESTINATION" ]] && FILENAME=$DESTINATION || FILENAME="zepto.min.js"
        simple_get "http://zeptojs.com/zepto.min.js" $FILENAME "Zepto.js"
        ;;
    backbone|backbonejs)
        [[ -n "$DESTINATION" ]] && FILENAME=$DESTINATION || FILENAME="backbone.min.js"
        simple_get "http://documentcloud.github.com/backbone/backbone-min.js" $FILENAME "Backbone.js"
        read -p "Should I also download Underscore.js, a requirement of Backbone.js? [yN] " UNDERSCORE
        if [ "$UNDERSCORE" = "y" ]
        then
            $0 underscore
        fi
        ;;
    underscore|underscorejs)
        [[ -n "$DESTINATION" ]] && FILENAME=$DESTINATION || FILENAME="underscore.min.js"
        simple_get "http://documentcloud.github.com/underscore/underscore-min.js" $FILENAME "Underscore.js"
        ;;
    prototype|prototypejs)
        getting "Prototype"
        [[ -n "$DESTINATION" ]] && FILENAME=$DESTINATION || FILENAME="prototype.js"
        check_exists $FILENAME
        HTML=`curl -s http://www.prototypejs.org/download`
        URL=`echo $HTML | perl -wlne 'print $1 if /(https:\/\/ajax.googleapis.com\/[^"]+prototype.js)/'`
        curl -s $URL > $FILENAME
        downloaded "Prototype" $FILENAME
        ;;
    requirejs)
        getting "RequireJS"
        [[ -n "$DESTINATION" ]] && FILENAME=$DESTINATION || FILENAME="require.js"
        check_exists $FILENAME
        HTML=`curl -s http://requirejs.org/docs/download.html`
        URL=`echo $HTML | perl -wlne 'print $1 if /(http:\/\/requirejs.org\/docs\/release\/[^\/]+\/minified\/require.js)/'`
        curl -s $URL > $FILENAME
        downloaded "RequireJS" $FILENAME
        ;;
    raphael|raphaeljs)
        [[ -n "$DESTINATION" ]] && FILENAME=$DESTINATION || FILENAME="raphael.min.js"
        simple_get "https://github.com/DmitryBaranovskiy/raphael/raw/master/raphael-min.js" $FILENAME "Raphaël"
        ;;
    *)
        echo "${txtund}${txtred}Error:${txtrst} Unknown library: $1"
        exit 99
esac
