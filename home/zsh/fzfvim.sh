function fzfvim() {
    nvim "$(find . -type f | fzf)" || return
}
