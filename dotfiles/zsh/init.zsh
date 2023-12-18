# Initial tasks to run on window boot up.
init() {
  curwin
  enable_bash_rematch
  [[ $CURSOR_TYPE == "ibeam" ]] && i_beam_cursor
}

# Info about current terminal window and other things.
curwin() {
  hline=""
  for i in {0..55}; do
    hline+="\u2500"
  done

  [[ $SHELL == "/bin/zsh" ]] && setopt local_options BASH_REMATCH

  echo "                          ,"
  echo "   ,-.       _,---._ __  / \\"
  echo "  /  )    .-'       \`./ /   \\"
  echo " (  (   ,'            \`/    /|"
  echo "  \  \`-\"             \'\   / |"
  echo "   \`.              ,  \ \ /  |"
  echo "    /\`.          ,'-\`----Y   |"
  echo "   (            ;        |   '"
  echo "   |  ,-.    ,-'         |  /"
  echo "   |  | (   |  s5k's box | /"
  echo "   )  |  \  \`.___________|/"
  echo "   \`--'   \`--'"
  echo
#   echo "\x1B[38;2;102;222;237m\u2192\x1B[0m \x1B[38;2;227;135;255mUser\x1B[0m:        \x1B[38;2;255;213;135m$(whoami)\x1B[0m"
#   echo "\x1B[38;2;102;222;237m\u2192\x1B[0m \x1B[38;2;227;135;255mOS Type\x1B[0m:     \x1B[38;2;255;213;135m$OSTYPE\x1B[0m"
#   echo "\x1B[38;2;102;222;237m\u2192\x1B[0m \x1B[38;2;227;135;255mTerminal\x1B[0m:    \x1B[38;2;255;213;135m$(tty)\x1B[0m"
#   echo "\x1B[38;2;102;222;237m\u2192\x1B[0m \x1B[38;2;227;135;255mShell\x1B[0m:       \x1B[38;2;255;213;135m$SHELL\x1B[0m"
#   echo 
}

# Boot tmux if tmux exists and is not running.
exec_tmux() {
  which tmux &> /dev/null && \
    [ -n "$PS1" ] && \
    [[ ! "$TERM" =~ screen ]] && \
    [[ ! "$TERM" =~ tmux ]] && \
    [ -z "$TMUX" ] && \
    exec tmux
}

vi_mode() {
  set -o vi
}

i_beam_cursor() {
  printf '\033[6 q'
}

print_todos() {
  [[ -f $TODOS ]] && cat $TODOS
}

enable_bash_rematch() {
  setopt BASH_REMATCH
}
