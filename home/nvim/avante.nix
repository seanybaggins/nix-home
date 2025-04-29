''
    " Use <c-space> to trigger completion.
    nnoremap <leader>av :AvanteToggle<CR>
    lua << EOF
  require("avante").setup({
    provider = "openai",
    openai = {
      endpoint = "https://api.openai.com/v1",
      model = "gpt-4o", -- or "gpt-4"
      timeout = 30000,
      temperature = 0,
      -- max_completion_tokens = 8192,
    },
    behaviour = {}  -- default to empty to prevent nil crash
  })
  EOF

''
