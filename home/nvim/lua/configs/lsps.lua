local blink_cmp   = require('blink.cmp')
local capabilities = blink_cmp.get_lsp_capabilities()
vim.o.updatetime = 250
local on_attach = function(client, bufnr)
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function() vim.diagnostic.open_float(nil, { focus = false }) end,
  })
end

blink_cmp.setup {
  keymap     = { preset = 'default' },
  sources    = { default = { 'lsp','path','snippets','buffer' } },
  completion = { documentation = { auto_show = true } },
}

require("lspconfig").lua_ls.setup {
  on_attach    = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = { "lua/?.lua", "lua/?/init.lua" },
      },
      diagnostics = {
        globals = { "vim" },      -- don’t flag `vim` as undefined
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
}
