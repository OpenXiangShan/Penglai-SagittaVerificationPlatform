#!/bin/usr/csh

##need to modify $proj as project name
set proj = TODO
set temp = $cwd
unsetenv PROJ_ROOT

while ("$cwd" != "/")
    if ((-d lib) & (-d rtl) & (-d scr)) then
        setenv PROJ_ROOT $cwd
        break
    endif
    cd ..
end

cd $temp

echo "+---------------------------------------------------------------------------------------"
echo "| Welcome to [$proj]"
echo "| Current PROJ_ROOT = $PROJ_ROOT"
echo "+---------------------------------------------------------------------------------------"

#source  $PROJ_ROOT/scr/proj_tool.cshrc
source  $PROJ_ROOT/scr/verif/verif.cshrc

