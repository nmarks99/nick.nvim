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
    root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
    settings = {
        -- ignore some globals brought in by EPICS lua module in EPICS projects
        Lua = { diagnostics = { globals = {
            'dbLoadDatabase', 'dbLoadRecords', 'iocInit',
            'epicsEnvSet', 'epicsEnvShow', 'cd', 'pwd',
            'luash', 'luaCmd', 'luaSpawn', 'luaPortDriver',
            'exec', 'pdbbase', 'iocsh',
            'OutTerminator', 'InTerminator',
            'WriteTimeout', 'ReadTimeout', 'WriteReadTimeout',
      }}}
    },
}

-- Define the 'ty' configuration manually since it's not yet built-in
vim.lsp.config('ty', {
  cmd = { 'ty', 'server' },  -- "ty server" starts the LSP
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ty.toml', '.git' }, -- Helps Neovim find the project root
  settings = {
    ty = {}
  }
})

vim.lsp.config('ruff', {
  init_options = {
    settings = {}
  }
})

-- enable all the severs
vim.lsp.enable({"lua_ls", "clangd", "ty", "ruff"})

-- Tell the server the capability of foldingRange,
-- Neovim hasn't added foldingRange to default capabilities, users must add it manually
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}
local language_servers = vim.lsp.get_clients() -- or list servers manually like {'gopls', 'clangd'}
for _, ls in ipairs(language_servers) do
    require('lspconfig')[ls].setup({
        capabilities = capabilities
    })
end

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
