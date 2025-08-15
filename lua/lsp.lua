vim.lsp.config.clangd = {
    cmd = { 'clangd', '--background-index', "--header-insertion=never" },
    root_markers = { 'compile_commands.json', 'compile_flags.txt' },
    filetypes = { 'c', 'cpp' },
}

vim.lsp.enable({'clangd'})

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client:supports_method('textDocument/completion') then
          vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
        end
    end,
})

-- LSP keymaps
vim.keymap.set('i', '<c-space>', function()
    vim.lsp.completion.get()
end)

-- In insert mode: <C-j> goes to next item,
vim.keymap.set('i', '<C-j>', function()
  return vim.fn.pumvisible() == 1 and '<C-n>' or '<Down>'
end, { expr = true })

-- <C-k> goes to previous
vim.keymap.set('i', '<C-k>', function()
  return vim.fn.pumvisible() == 1 and '<C-p>' or '<Up>'
end, { expr = true })

-- <CR> to confirm selection
vim.keymap.set('i', '<CR>', function()
  return vim.fn.pumvisible() == 1 and '<C-y>' or '<CR>'
end, { expr = true })

