export BOOKMARKS="$HOME/.cache/bookmarks"
export TODOS="$HOME/.cache/todos"
export CURSOR_TYPE="ibeam"

export PACKPATH="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"

# FZF 
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_DEFAULT_OPTS='--bind ctrl-n:down,ctrl-p:up'

# Prompt
# export PS1=$'%{\x1b[34m%}\U250C\U2500%{\x1b[0m%} %{\x1b[1;38;2;227;135;255m%}%c%{\x1b[0m%}$(git_info) \n%{\x1b[34m%}\U2514%{\x1b[0m%} %{\x1b[1;31m%}\U1F9CB%{\x1b[0m%} '

# Correct but wrong emoji
# export PS1=$'%{\e[34m%}\u250C\u2500%{\e[0m%} %{\e[1;38;2;227;135;255m%}%c%{\e[0m%}$(git_info) \n%{\e[34m%}\u2514%{\e[0m%} %{\e[1;31m%}\u1F9CB%{\e[0m%} '

export GLFW_IM_MODULE=ibus
