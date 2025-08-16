-- ========================
--           LSP
-- ========================
-- clangd
vim.lsp.config.clangd = {
    cmd = { 'clangd', '--background-index', "--header-insertion=never" },
    root_markers = { 'compile_commands.json', 'compile_flags.txt' },
    filetypes = { 'c', 'cpp' },
}

-- lua_ls
vim.lsp.config.lua_ls = {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".git" }
}

-- enable all the severs
vim.lsp.enable({'lua_ls', "clangd"})

-- automatically attach LSPs
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client:supports_method('textDocument/completion') then
          vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
        end
    end,
})


-- trigger completion with ctrl+space in insert mode
vim.keymap.set('i', '<c-space>', function()
    vim.lsp.completion.get()
end)

-- In insert mode:
-- <C-j> goes to next item,
-- <C-k> goes to previous
-- <CR> to confirm selection
vim.keymap.set('i', '<C-j>', function()
  return vim.fn.pumvisible() == 1 and '<C-n>' or '<Down>'
end, { expr = true })
vim.keymap.set('i', '<C-k>', function()
  return vim.fn.pumvisible() == 1 and '<C-p>' or '<Up>'
end, { expr = true })
vim.keymap.set('i', '<CR>', function()
  return vim.fn.pumvisible() == 1 and '<C-y>' or '<CR>'
end, { expr = true })
