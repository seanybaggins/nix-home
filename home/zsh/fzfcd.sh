function fzfcd() {
    cd "$(find . -type d | fzf)" || return
}
