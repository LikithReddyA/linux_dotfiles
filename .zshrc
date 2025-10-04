# Path to zsh config folder
ZSH_CONFIG="$HOME/.config/zsh"


# Source modular files
for file in $ZSH_CONFIG/*.zsh; do
  source $file
done

export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

### SET VI MODE ###
# Comment this line out to enable default emacs-like bindings
bindkey -v

### CHANGE TITLE OF TERMINALS
case ${TERM} in
  xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|alacritty|st|konsole*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
        ;;
  screen*)
    PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
    ;;
esac

