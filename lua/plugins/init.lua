-- ==============================
--            Plugins
-- ==============================
-- Lazy neovim plugin manager
-- See `:Lazy help`
local plugins = {

    -- themes
    { "catppuccin/nvim", lazy = false, name = "catppuccin" },
    { "rose-pine/neovim", lazy = false, name = "rose-pine" },
    { "shaunsingh/nord.nvim", lazy = false, name = "nord" },
    { "ellisonleao/gruvbox.nvim", lazy = false, name = "gruvbox" },
    { "Shatur/neovim-ayu", lazy=false, priority = 1000 },
    { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
    { "ficcdaf/ashen.nvim", lazy = false, priority = 1000 },
    { "lurst/austere.vim", lazy = false, priority = 1000 },
    { "slugbyte/lackluster.nvim", lazy = false, priority = 1000 },

    -- git diff viewer
    {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose",
	    "DiffviewRefresh", "DiffviewLog", "DiffviewFocusFiles", "DiffviewToggleFiles" },
	config = function()
	    require("diffview").setup({})
	end,
    },

    -- fzf integration for neovim
    {
	"ibhagwan/fzf-lua",
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

    -- deal with trailing whitespace
    "ntpeters/vim-better-whitespace",

    -- Git related plugins
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',

    -- Detect tabstop and shiftwidth automatically
    -- NOTE: very annoying when it doesn't work!
    'tpope/vim-sleuth',

    -- Language aware comment
    'preservim/nerdcommenter',

    -- File system tool
    {
	'stevearc/oil.nvim',
	opts = {},
	dependencies = { "nvim-tree/nvim-web-devicons" },
    },


    -- TODO comments manager
    {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {}
    },

    -- Nice tools for cargo
    {
	'saecki/crates.nvim',
	ft = {"toml"},
	tag = 'stable',
	config = function()
	    print("Loading crates.nvim")
	    require('crates').setup({})
	end,
    },

    -- File explorer tree
    { "nvim-tree/nvim-tree.lua" },

    -- LSP Configuration & Plugins
    {
	'neovim/nvim-lspconfig',
	dependencies = {
	    -- Automatically install LSPs to stdpath for neovim
	    { 'williamboman/mason.nvim', config = true },
	    'williamboman/mason-lspconfig.nvim',

	    -- Useful status updates for LSP
	    { 'j-hui/fidget.nvim', opts = {} },

	    -- Additional lua configuration, makes nvim stuff amazing!
	    'folke/neodev.nvim',
	},
    },

    -- GLSL syntax highlighting
    {
	'tikhomirov/vim-glsl',
	ft = {"glsl"}
    },

    -- Autocompletion
    {
	'hrsh7th/nvim-cmp',
	dependencies = {
	    -- Snippet Engine & its associated nvim-cmp source
	    'L3MON4D3/LuaSnip',
	    'saadparwaiz1/cmp_luasnip',

	    -- Adds LSP completion capabilities
	    'hrsh7th/cmp-nvim-lsp',
	    'hrsh7th/cmp-path',

	    -- Adds a number of user-friendly snippets
	    'rafamadriz/friendly-snippets',
	},
    },

    -- status line at the bottom
    {
	'nvim-lualine/lualine.nvim',
	opts = {
	    options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = '|',
		section_separators = '',
	    },
	},
    },

    -- Highlight, edit, and navigate code
    {
	'nvim-treesitter/nvim-treesitter',
	dependencies = {
	    'nvim-treesitter/nvim-treesitter-textobjects',
	},
	build = ':TSUpdate',
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

-- ==================================================
require("plugins.config")
require("plugins.lsp")
