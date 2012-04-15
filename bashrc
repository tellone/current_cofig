# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#check for conig dir and give short name

if [ -d /home/tellone/gitrepos/current_config/bash_rcs ]; then
    cofig1=/home/tellone/gitrepos/current_config/bash_rcs
else
    echo "WARNING!! no bash_configuration files"
fi

if [ -f $cofig1/bash_env ]; then
    . $cofig1/bash_env
else
    echo "No file bash_env found"
fi

if [ -f $cofig1/bash_config ]; then
    . $cofig1/bash_config
else
    echo "No file bash_config found"
fi

if [ -f $cofig1/aliases ]; then
    . $cofig1/aliases
else
    echo "No aliases loaded"
fi

if [ -f $cofig1/func_lib ]; then
    . $cofig1/func_lib
else
    echo "No functions loaded"
fi

