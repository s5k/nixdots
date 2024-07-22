export BOOKMARKS="$HOME/.cache/bookmarks"
export TODOS="$HOME/.cache/todos"
export CURSOR_TYPE="ibeam"

export PACKPATH="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"

# FZF 
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_DEFAULT_OPTS='--bind ctrl-n:down,ctrl-p:up'

# Prompt
export PS1=$'%{\x1b[34m%}\U250C\U2500%{\x1b[0m%} %{\x1b[1;38;2;227;135;255m%}%c%{\x1b[0m%}$(git_info) \n%{\x1b[34m%}\U2514%{\x1b[0m%} %{\x1b[1;31m%}\U1F9CB%{\x1b[0m%} '

export GLFW_IM_MODULE=ibus

export GTK_IM_MODULE=xim # đổi thành xim
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
# Dành cho những phần mềm dựa trên qt4
export QT4_IM_MODULE=ibus
# Dành cho những phần mềm dùng thư viện đồ họa clutter/OpenGaaL
export CLUTTER_IM_MODULE=ibus
export GLFW_IM_MODULE=ibus