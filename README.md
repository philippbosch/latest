latest
======

latest is a simple tool that allows you to download the latest version
of a variety of JavaScript libraries with just a few keystrokes in your
terminal.

Say, you are starting a new project and need the latest version of 
jQuery. Instead of going to the [jQuery website](http://jquery.com/)
and looking for the download link, just change to the destination 
folder and type:

    $ latest jquery
    Getting jQuery …
    jQuery downloaded and saved as jquery.min.js.

For more information:

    $ latest --help
    Usage: latest LIBRARY [DESTINATION]
    
    Libraries available:
     › jquery
     › zepto
     › backbone
     › underscore
     › prototype
     › require
     › raphael


Installation
------------

    curl -L https://github.com/philippbosch/latest/raw/master/latest.sh > /usr/local/bin/latest
    chmod +x /usr/local/bin/latest

