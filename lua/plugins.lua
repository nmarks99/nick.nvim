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
	keys = {
	    { "<A-p>", "<cmd>FzfLua files<cr>",    desc = "Fzf Files" },
	    { "<A-b>", "<cmd>FzfLua buffers<cr>",  desc = "Fzf Buffers" },
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

    {
	"mason-org/mason.nvim",
	opts = {}
    },

    -- GLSL syntax highlighting
    {
	'tikhomirov/vim-glsl',
	ft = {"glsl"}
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
-- vim.keymap.set({ 'n', 'v' }, '++', [[<plug>NERDCommenterToggle]], {})
vim.keymap.set({ 'n', 'v' }, '<leader>/', [[<plug>NERDCommenterToggle]], {})
