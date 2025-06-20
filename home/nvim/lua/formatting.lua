-- create a group for our formatting autocmds
local fmt_grp = vim.api.nvim_create_augroup("AutoFormat", { clear = true })

function add_formatting(command, pattern)
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = fmt_grp,
        pattern = pattern,
        callback = function()
            -- where to move the cursor and view after a succesful write
            local view = vim.fn.winsaveview()

            local buffer = vim.api.nvim_get_current_buf()
            local lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)
            local result = vim.fn.systemlist(command, lines)
            if vim.v.shell_error ~= 0 then
                vim.api.nvim_echo({
                    {
                        "[formatter error] " .. table.concat(result, "\n"),
                        "ErrorMsg",
                    },
                }, false, {})
                return
            end
            -- Write on success
            vim.api.nvim_buf_set_lines(buffer, 0, -1, false, result)
            -- restore the cursor and view
            vim.fn.winrestview(view)
        end,
    })
end
--add_formatting(
--    "%!clang-format -style=Webkit",
--    { "*.c", "*.cpp", "*.h", "*.hpp", "*.cc", "*.cxx" }
--)
add_formatting("black --quiet -", "*.py")
add_formatting("stylua --indent-type Spaces --column-width 80 -", "*.lua")
add_formatting("nixfmt", "*.nix")
add_formatting("shfmt --indent 4 --binary-next-line --keep-padding", "*.sh")

-- Nix indent
vim.api.nvim_create_autocmd("FileType", {
    pattern = "nix",
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
    end,
})
