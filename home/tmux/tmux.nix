''
# Increase the scroll limit. To small by default.
set-option -g history-limit 100000

# Pluggins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-yank'

# Allow scrolling with the mouse
set -g mouse on
set -g mode-keys vi

# WIP: Get highlights and copy and paste working intuitively
#set -g @yank_action 'copy-pipe'
#unbind -T copy-mode-vi MouseDragEnd1Pane

# Avoid ESC delay
set -s escape-time 0

# Modern Colors
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",alacritty:Tc"

# Focus events allow auto-read in vim to work.
# See vim :checkhealth or :help auto-read for details.
set-option -g focus-events on

# unbind the prefix and bind it to Ctrl-a like screen
# unbind C-b
#set -g prefix C-a
#bind C-a send-prefix

# So opening a new session starts in the current
# directory rather than the ending directory
# https://unix.stackexchange.com/questions/12032/how-to-create-a-new-window-on-the-current-directory-in-tmux
#
# Also changed the split pane keys to be more inititive
bind _ split-window -c "#{pane_current_path}"
bind | split-window -h -c "#{pane_current_path}"
bind c new-window -c "#{pane_current_path}"

# tmux messages are displayed for 4 seconds
set -g display-time 4000

# refresh 'status-left' and 'status-right' more often
set -g status-interval 5

# Do not display date and time in bottom right
set -g status-right \'\'
set -g status-right-length 0
'' + import ./colors.nix
