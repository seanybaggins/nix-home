{ pkgs, ... }:
''
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
  source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

  if [ -x "$(command -v neofetch)" ] && [ -n "$TMUX" ]; then
      neofetch
  fi

  # if tmux is executable and not inside a tmux session, then try to attach.
  # if attachment fails, start a new session
  # source: https://wiki.archlinux.org/title/tmux#Start_tmux_on_every_shell_login
  [ -x "$(command -v tmux)" ] \
      && [ -z "$TMUX" ] \
      && { tmux -2 attach || tmux -2; } >/dev/null 2>&1
''
+ builtins.readFile ./mkGraph.sh
+ builtins.readFile ./fzfcd.sh
  + builtins.readFile ./fzfvim.sh
