vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Core options
vim.opt.compatible = false
vim.opt.encoding = "utf-8"
vim.opt.shortmess:append("I")
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.laststatus = 2
vim.opt.backspace = "indent,eol,start"
vim.opt.hidden = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.errorbells = false
vim.opt.visualbell = true
vim.opt.belloff = "all"
vim.opt.mouse = "a"
vim.opt.tabstop = 8
vim.opt.softtabstop = 0
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.linebreak = true
vim.opt.showbreak = "+++"
vim.opt.textwidth = 80
vim.opt.formatoptions:append("r")
vim.opt.formatoptions:append("q")
vim.opt.formatoptions:append("n")
vim.opt.formatoptions:append("b")
vim.opt.colorcolumn = { "80", "100" }
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.undofile = true

-- NERDTree auto-close
do
    local nerd =
        vim.api.nvim_create_augroup("NERDTreeAutoClose", { clear = true })
    vim.api.nvim_create_autocmd("BufEnter", {
        group = nerd,
        callback = function()
            if
                vim.fn.tabpagenr("$") == 1
                and vim.fn.winnr("$") == 1
                and vim.b.NERDTree
                and vim.b.NERDTree.isTabTree()
            then
                vim.cmd("quit")
            end
        end,
    })
end
vim.keymap.set("n", "<leader>t", "<cmd>NERDTreeFocus<CR>")
vim.g.NERDTreeShowHidden = 1

-- Markdown tweaks
vim.g.vim_markdown_folding_disabled = 1
vim.g.vim_markdown_strikethrough = 1

require("nvim-autopairs").setup({})
require("lsps")
require("formatting")
require("color-settings")
