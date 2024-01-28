-- ==============================
--            Options
-- ==============================
-- See `:help vim.o
vim.g.mapleader = ' '           -- Set <space> as the leader key
vim.g.maplocalleader = ' '
vim.o.smartcase = true
vim.o.hlsearch = true           -- Set highlight on search
vim.wo.number = true            -- enable line numbers
vim.o.mouse = 'a'               -- Enable mouse mode
vim.o.clipboard = 'unnamedplus' -- Sync clipboard
vim.o.breakindent = true        -- Enable break indent
vim.o.undofile = true           -- Save undo history
vim.o.ignorecase = true         -- Case-insensitive search
vim.wo.signcolumn = 'yes'       -- Keep signcolumn on by default
vim.o.updatetime = 250          -- Decrease update time
vim.o.timeoutlen = 300
vim.o.termguicolors = true
vim.o.completeopt = 'menuone,noselect'
vim.opt.shiftwidth = 4 -- vim-slueth may change this
TRANSPARENT = false    -- Enable transparency for basic themes
theme = "catppuccin"

if TRANSPARENT then
  vim.cmd([[
  autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE
  autocmd vimenter * hi NonText guibg=NONE ctermbg=NONE
  autocmd vimenter * hi NvimTreeNormal guibg=NONE ctermbg=NONE
  autocmd vimenter * hi NormalFloat guibg=NONE ctermbg=NONE
  ]])
end


-- ==============================
--            Keymaps
-- ==============================
-- See `:help vim.keymap.set()`

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


-- ==============================
--            Plugins
-- ==============================

-- load plugins with lazy.nvim
require("plugins")

-- bufferline
require("bufferline").setup {
  options = {
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",
        separator = true     -- use a "true" to enable the default, or set your own character
      },
    },
    hover = {
      enabled = true,
      delay = 200,
      reveal = { 'close' }
    },
  },
}
vim.keymap.set('n', '<A-.>', [[:BufferLineCycleNext<CR>]], {})
vim.keymap.set('n', '<A-,>', [[:BufferLineCyclePrev<CR>]], {})

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require("nvim-tree").setup({
  filters = {
    git_ignored = false
  }
})
vim.keymap.set('n', '<BSLASH>n', [[:NvimTreeToggle<CR>]], {})

-- tree-sitter
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = {
      'c',
      'cpp',
      'python',
      'lua',
      'rust',
      'bash',
      'go',
      'vim',
      'vimdoc',
      'javascript',
      'typescript',
    },

    auto_install = false,
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)

--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- sets the mode, buffer and description.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end


-- Enable language servers
local servers = {
  clangd = {},
  rust_analyzer = {},
  jedi_language_server = {},
  ruff_lsp = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = { disable = { 'lowercase-global', 'missing-fields' } },
    },
  },
}

-- mason
-- mason-lspconfig
require('mason').setup()
require('mason-lspconfig').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}

-- nvim-cmp
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
  },
}

-- nerd commenter
vim.g.NERDCompactSexyComs = 1
vim.g.NERDCommentEmptyLines = 1
vim.g.NERDTrimTrailingWhitespace = 1
vim.g.NERDToggleCheckAllLines = 1
vim.g.NERDSpaceDelims = 1
vim.keymap.set({ 'n', 'v' }, '++', [[<plug>NERDCommenterToggle]], {})
vim.keymap.set({ 'n', 'v' }, '<leader>/', [[<plug>NERDCommenterToggle]], {})


-- todo comments
require("todo-comments").setup();

-- set theme
if theme == "catppuccin" then
  require("catppuccin").setup({
    flavour = "mocha",
    transparent_background = false
  })
  vim.cmd.colorscheme "catppuccin"
elseif theme == "ayu" then
  require('ayu').setup({
    mirage = false,
    overrides = {},
  })
  vim.cmd.colorscheme "ayu-dark"
end


-- EPICS stuff
-- Set filetype=conf for .cmd files on Linux
if package.config:sub(1, 1) == '/' then
  vim.cmd([[autocmd BufNewFile,BufRead *.cmd set filetype=conf]])
  vim.cmd([[autocmd BufNewFile,BufRead *.db set filetype=conf]])
end

-- Check if the current working directory contains the string "ioc" and execute :LspStop
-- function check_ioc_directory()
  -- local current_directory = vim.fn.getcwd()
  -- if string.find(current_directory, "ioc") then
    -- -- Print a message to confirm that the condition is true
    -- print("Current directory contains 'ioc', executing :LspStop")
    -- -- Execute the LspStop command
    -- vim.cmd("LspStop")
  -- end
-- end

-- Set up an autocommand to trigger the function when a file is opened
-- vim.cmd [[
  -- autocmd BufReadPost * lua check_ioc_directory()
-- ]]