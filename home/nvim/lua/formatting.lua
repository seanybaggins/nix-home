-- create a group for our formatting autocmds
local fmt_grp = vim.api.nvim_create_augroup("AutoFormat", { clear = true })

function add_formatting(command, pattern)
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = fmt_grp,
        pattern = pattern,
        callback = function()
            -- 1) snapshot cursor, folds, viewport
            local view = vim.fn.winsaveview()
            -- 2) run stylua over the whole buffer
            vim.cmd(command)
            -- 3) restore everything back
            vim.fn.winrestview(view)
        end,
    })
end
add_formatting(
    "%!clang-format -style=Webkit",
    { "*.c", "*.cpp", "*.h", "*.hpp", "*.cc", "*.cxx" }
)
add_formatting("%!black --quiet -", "*.py")
add_formatting("%!stylua --indent-type Spaces --column-width 80 -", "*.lua")
add_formatting("%!nixfmt", "*.nix")
add_formatting("%!shfmt --indent 4 --binary-next-line --keep-padding", "*.sh")

-- Nix indent
vim.api.nvim_create_autocmd("FileType", {
    pattern = "nix",
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
    end,
})
