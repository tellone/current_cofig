# ~/.zshrc: executed by zsh(1) for non-login shells.
# see /usr/share/doc/zsh/examples/startup-files (in the package zsh-doc)
# for examples

#check for conig dir and give short name

if [ -d /home/tellone/current_config/zsh_rcs ]; then
    cofig1=/home/tellone/current_config/zsh_rcs
else
    echo "WARNING!! no zsh_configuration files"
fi

if [ -f $cofig1/zsh_env ]; then
    . $cofig1/zsh_env
else
    echo "No file zsh_env found"
fi

if [ -f $cofig1/zsh_config ]; then
    . $cofig1/zsh_config
else
    echo "No file zsh_config found"
fi


if [ -f $cofig1/zsh_completion ]; then
    . $cofig1/zsh_completion
else
    echo "No file zsh_config found"
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

