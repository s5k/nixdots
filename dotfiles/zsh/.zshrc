# ~/.zshrc
export TERM=xterm-256color
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# create .hushlogin if it doesn't exist
[[ ! -f $HOME/.hushlogin ]] && touch $HOME/.hushlogin

export DOTFILES="$HOME/Documents/nixdots/dotfiles/zsh"
export ZSH_DISABLE_COMPFIX="true"
# not found oh-my-zsh
# export ZSH="$HOME/.oh-my-zsh"

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

if [[ -d /opt/homebrew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# direnv stuff
eval "$(direnv hook zsh)"

# thefuck
eval $(thefuck --alias)
