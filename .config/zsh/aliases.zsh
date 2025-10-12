# change your default USER shell
alias tobash="chsh $USER -s /bin/bash && echo 'Log out and log back in for change to take effect.'"
alias tozsh="chsh $USER -s /bin/zsh && echo 'Log out and log back in for change to take effect.'"


# Dotfiles configuration
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

alias nvim-likith='NVIM_APPNAME=nvim-likith nvim'
