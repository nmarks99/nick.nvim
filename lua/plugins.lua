-- ==============================
--            Plugins
-- ==============================
-- Lazy neovim plugin manager
-- See `:Lazy help`
local plugins = {

    -- themes
    { "catppuccin/nvim",              lazy = false, priority = 1000, name = "catppuccin" },
    { "rose-pine/neovim",             lazy = false, priority = 1000, name = "rose-pine" },
    { "shaunsingh/nord.nvim",         lazy = false, priority = 1000, name = "nord" },
    { "ellisonleao/gruvbox.nvim",     lazy = false, priority = 1000, name = "gruvbox" },
    { "Shatur/neovim-ayu",            lazy = false, priority = 1000 },
    { "folke/tokyonight.nvim",        lazy = false, priority = 1000 },
    { "ficcdaf/ashen.nvim",           lazy = false, priority = 1000 },
    { "slugbyte/lackluster.nvim",     lazy = false, priority = 1000 },
    { "abreujp/scholar.nvim",         lazy = false, priority = 1000 },
    { "e-ink-colorscheme/e-ink.nvim", lazy = false, priority = 1000 },
    { "nmarks99/mfd.nvim", lazy = false, priority = 1000 },

    { "pablopunk/pi.nvim" },

    -- Smarter splits for navigating between splits and multiplexer panes
    {
        'smart-splits-nvim/smart-splits.nvim',
        version = '^3.0.0',
        lazy = false,
        opts = function() -- Plugin Configuration
            if not vim.env.KITTY_WINDOW_ID then
                return { mux = { warn_if_unusable = false } }
            end
            return {
                mux = {
                  backend = 'smart-splits-backend-kitty',
                },
                move = {
                    at_edge = function(ctx)
                        if ctx.direction == 'left' then
                            vim.system({ 'kitten', '@', 'action', 'previous_tab' })
                        elseif ctx.direction == 'right' then
                            vim.system({ 'kitten', '@', 'action', 'next_tab' })
                        end
                    end,
                },
            }
        end,
        keys = {
            { '<A-h>', function() require('smart-splits').move_cursor_left() end,  desc = 'navigate left or tab' },
            { '<A-j>', function() require('smart-splits').move_cursor_down() end,  desc = 'navigate down' },
            { '<A-k>', function() require('smart-splits').move_cursor_up() end,    desc = 'navigate up' },
            { '<A-l>', function() require('smart-splits').move_cursor_right() end, desc = 'navigate right or tab' },
        },
        dependencies = {
            {
              'smart-splits-nvim/backend-kitty',
              module = 'smart-splits-backend-kitty',
              build = "./kitten/install_relative_resize.lua",
            },
        },
    },

    -- git signs in the column to the left of line numbers
    { "lewis6991/gitsigns.nvim" },

    {
        "barrettruth/preview.nvim",
        url = "https://forge.barrettruth.com/barrettruth/preview.nvim",
        init = function()
            vim.g.preview = {markdown = true}
        end,
    },

    {
      "folke/todo-comments.nvim",
      -- dependencies = { "nvim-lua/plenary.nvim" },
      opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    },

    -- git diff viewer
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose",
            "DiffviewRefresh", "DiffviewLog", "DiffviewFocusFiles", "DiffviewToggleFiles" },
        config = function()
            require("diffview").setup({})
        end,
    },

    -- Makes folds nicer
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        init = function()
            vim.o.foldcolumn = "0"
            vim.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
            vim.opt.fillchars = {
                fold = " ",
                foldopen = "",
                foldsep = " ",
                foldclose = "",
            }
        end,
        config = function()
            require('ufo').setup()
        end
    },

    -- fzf integration for neovim
    {
        "ibhagwan/fzf-lua",
        keys = {
            { "<A-p>", "<cmd>FzfLua files<cr>",     desc = "Fzf Files" },
            { "<A-b>", "<cmd>FzfLua buffers<cr>",   desc = "Fzf Buffers" },
            { "<A-g>", "<cmd>FzfLua live_grep<cr>", desc = "Fzf Live Grep" },
        },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("fzf-lua").setup({
                files = {
                    previewer = false
                },
                buffers = {
                    previewer = false
                }
            })
        end
    },

    {
        "lervag/vimtex",
        lazy = false, -- we don't want to lazy load VimTeX
        -- tag = "v2.15", -- uncomment to pin to a specific release
        init = function()
            -- VimTeX configuration goes here, e.g.
            vim.g.vimtex_view_method = "zathura"
        end
    },

    -- deal with trailing whitespace
    "ntpeters/vim-better-whitespace",

    -- Git related plugins
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',

    -- Language aware comment
    'preservim/nerdcommenter',

    -- File system tool
    {
        'stevearc/oil.nvim',
        opts = {},
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- Nice tools for cargo
    {
        'saecki/crates.nvim',
        ft = { "toml" },
        tag = 'stable',
        config = function()
            print("Loading crates.nvim")
            require('crates').setup({})
        end,
    },

    -- File explorer tree
    { "nvim-tree/nvim-tree.lua" },

    {
        "mason-org/mason.nvim",
        opts = {}
    },

    -- GLSL syntax highlighting
    {
        'tikhomirov/vim-glsl',
        ft = { "glsl" }
    },

    -- status line at the bottom
    {
        'nvim-lualine/lualine.nvim',
        event = "VimEnter",
        opts = {
            options = {
                icons_enabled = true,
                theme = "auto",
                component_separators = '|',
                section_separators = '',
            },
        },
    },

    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {}
    },

    -- Highlight, edit, and navigate code
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
        opts = {
            indent = {
                enable = true,
            },
            -- Include other basic configs here if they are missing
            highlight = {
                enable = true,
            },
        },
        config = function(_, opts)
            require('nvim-treesitter.configs').setup(opts)
        end,
    },
}

-- ensure lazy.nvim is installed, call setup with above table
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup(plugins, {})


-- ==============================
--      Plugins Configuration
-- ==============================
-- Configuration for miscellaneous plugins

-- oil
require("oil").setup()
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require("nvim-tree").setup({
    filters = {
        git_ignored = false
    }
})
vim.keymap.set('n', '<BSLASH>n', [[:NvimTreeToggle<CR>]], {})

-- nerd commenter
vim.g.NERDCompactSexyComs = 1
vim.g.NERDCommentEmptyLines = 1
vim.g.NERDTrimTrailingWhitespace = 1
vim.g.NERDToggleCheckAllLines = 1
vim.g.NERDSpaceDelims = 1
vim.cmd [[
  	let g:NERDCustomDelimiters = { 'c': { 'left': '//', 'right': ''} }
]]
vim.keymap.set({ 'n', 'v' }, '<leader>/', [[<plug>NERDCommenterToggle]], {})
