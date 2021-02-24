#!/bin/bash

if type xcode-select >&- && xpath=$( xcode-select --print-path ) &&
       test -d "${xpath}" && test -x "${xpath}" ; then
   #... is correctly installed
else
   #... isn't correctly installed
   XCODE_MESSAGE="$(osascript -e 'tell app "System Events" to display dialog "Please click install when Command Line Developer Tools appears"')"
   if [ "$XCODE_MESSAGE" = "button returned:OK" ]; then
       xcode-select --install
   else
       echo "You have cancelled the installation, please rerun the installer."
       # you have forgotten to exit here
       exit
   fi
fi
