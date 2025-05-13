-- create a group for our formatting autocmds
local fmt_grp = vim.api.nvim_create_augroup("AutoFormat", { clear = true })

-- clang‑format on C/C++/Header files
vim.api.nvim_create_autocmd("BufWritePre", {
    group = fmt_grp,
    pattern = { "*.c", "*.cpp", "*.h", "*.hpp", "*.cc", "*.cxx" },
    command = "%!clang-format -style=Webkit", -- filter entire buffer through clang-format
})

-- black on Python files
vim.api.nvim_create_autocmd("BufWritePre", {
    group = fmt_grp,
    pattern = "*.py",
    command = "%!black --quiet -", -- read stdin, write stdout
})

-- stylua on Lua files
vim.api.nvim_create_autocmd("BufWritePre", {
    group = fmt_grp,
    pattern = "*.lua",
    command = "%!stylua --indent-type Spaces --column-width 80 -", -- stylua reads from stdin
})
