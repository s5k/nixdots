# ~/.zshrc
export TERM=xterm-256color
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export DOTFILES="$HOME/Documents/nixdots/dotfiles/zsh"
export ZSH_DISABLE_COMPFIX="true"
export ZSH="$HOME/.oh-my-zsh"

source $DOTFILES/env.zsh --source_only
source $DOTFILES/utils.zsh --source_only
source $DOTFILES/paths.zsh --source_only
source $DOTFILES/init.zsh --source_only
source $DOTFILES/aliases.zsh --source_only
source $DOTFILES/hooks.zsh --source_only
source $DOTFILES/key_bindings.zsh --source_only

init

eval "$(zoxide init zsh)"
export _ZO_ECHO='1'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
alias nvm="unalias nvm; [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"; nvm $@"

# direnv stuff
eval "$(direnv hook zsh)"
