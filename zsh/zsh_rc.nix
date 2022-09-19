{pkgs, ...} :
''
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

if [ -x "$(command -v neofetch)" ] && [ -n "$TMUX" ]; then
    neofetch
fi

# Base16 Shell
BASE16_SHELL="$HOME/dotfiles/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

# if tmux is executable and not inside a tmux session, then try to attach.
# if attachment fails, start a new session
# source: https://wiki.archlinux.org/title/tmux#Start_tmux_on_every_shell_login
[ -x "$(command -v tmux)" ] \
    && [ -z "$TMUX" ] \
    && { tmux -2 attach || tmux -2; } >/dev/null 2>&1
''
