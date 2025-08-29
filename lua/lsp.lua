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

-- basedpyright
vim.lsp.config.basedpyright = {
    cmd = { 'basedpyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = {
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
        'pyrightconfig.json',
        '.git',
    },
    settings = {
        basedpyright = {
            analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'openFilesOnly',
            },
        },
    },
}

-- enable all the severs
vim.lsp.enable({ 'lua_ls', "clangd", "basedpyright" })

-- automatically attach LSPs and set up LSP keymaps
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client then return end
        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
        end

        -- trigger completion with ctrl+space in insert mode
        vim.keymap.set('i', '<c-space>', function()
            vim.lsp.completion.get()
        end)

        local keymap_opts = { buffer = ev.buf, silent = true }

        -- Go to definition
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, keymap_opts)

        -- Go to declaration
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, keymap_opts)

        -- Go to implementation
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, keymap_opts)

        -- Show line diagnostics
        vim.keymap.set("n", "gl", vim.diagnostic.open_float, keymap_opts)
    end,
})

vim.api.nvim_create_user_command("LspStop", function(_)
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
        vim.notify("No LSP client attached", vim.log.levels.WARN)
    else
        vim.lsp.stop_client(clients)
        vim.notify("Stopped " .. #clients .. " LSP client(s)")
    end
end, {})

vim.api.nvim_create_user_command("LspFormat", function(_)
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
        vim.notify("No LSP client attached", vim.log.levels.WARN)
    else
        vim.lsp.buf.format()
    end
end, {})
