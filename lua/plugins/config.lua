-- ==============================
--      Plugins Configuration
-- ==============================
-- Configuration for miscellaneous plugins

-- fzf-lua
-- alt+p so we don't interfere with zellij ctrl+p
vim.keymap.set("n", "<a-p>", require('fzf-lua').files, { desc = "Fzf Files" })

-- oil
require("oil").setup()
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

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

-- nerd commenter
vim.g.NERDCompactSexyComs = 1
vim.g.NERDCommentEmptyLines = 1
vim.g.NERDTrimTrailingWhitespace = 1
vim.g.NERDToggleCheckAllLines = 1
vim.g.NERDSpaceDelims = 1
vim.cmd [[
  let g:NERDCustomDelimiters = { 'c': { 'left': '//', 'right': ''} }
]]
vim.keymap.set({ 'n', 'v' }, '++', [[<plug>NERDCommenterToggle]], {})
vim.keymap.set({ 'n', 'v' }, '<leader>/', [[<plug>NERDCommenterToggle]], {})

-- todo comments
require("todo-comments").setup();
