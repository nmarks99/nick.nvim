-- ==============================
--            Options
-- ==============================
-- See `:help vim.o

vim.g.mapleader = ' '      -- Set <space> as the leader key
vim.g.maplocalleader = ' '
vim.o.hlsearch = true      -- highlight on search after enter
vim.wo.number = true       -- enable line numbers
vim.o.mouse = 'a'          -- Enable mouse mode
vim.o.breakindent = true   -- Enable break indent
vim.o.undofile = true      -- Save undo history
vim.o.ignorecase = true    -- Case-insensitive search...
vim.o.smartcase = true     -- ...unless capital in query
vim.wo.signcolumn = 'yes'  -- Keep signcolumn on by default
vim.o.updatetime = 250     -- Decrease update time
vim.o.timeoutlen = 300
vim.opt.scrolloff = 8      -- scroll 8 lines before bottom
vim.o.termguicolors = true -- enable nice colors
vim.opt.shiftwidth = 4
vim.opt.belloff = "all"
vim.opt.title = true
vim.opt.swapfile = false
vim.opt.incsearch = true
vim.opt.winborder = 'rounded' -- borders on popup windows
vim.o.showmode = false        -- don't show mode since lualine shows it
vim.o.completeopt = 'menuone,noselect'
vim.schedule(function()       -- sync system clipboard (need wl-wayland on wayland)
    vim.opt.clipboard = 'unnamedplus'
end)

-- Set filetypes for several EPICS related files
if package.config:sub(1, 1) == '/' then
    vim.cmd([[autocmd BufNewFile,BufRead *.cmd set filetype=conf]])
    vim.cmd([[autocmd BufNewFile,BufRead *.db set filetype=conf]])
    vim.cmd([[autocmd BufNewFile,BufRead *.iocsh set filetype=conf]])
    vim.cmd([[autocmd BufNewFile,BufRead *.substitutions set filetype=conf]])
    vim.cmd([[autocmd BufNewFile,BufRead *.proto set filetype=conf]])
end


-- ==============================
--            Keymaps
-- ==============================
-- Keymappings for native Neovim features.
-- Plugin specific keymappings configured with plugins
-- See `:help vim.keymap.set()`

-- Retrun to normal mode in terminal buffer with ESC key
vim.keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })

-- Disable spacebar in normal and visual mode so it can be used as leader
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function()
    vim.diagnostic.jump({ count = -1, float = true })
end, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', function()
    vim.diagnostic.jump({ count = 1, float = true })
end, { desc = 'Go to previous diagnostic message' })

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

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- keep highlighted when shifting with < and >
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Move stuff up and down and adjust indent
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- cycle buffers
vim.keymap.set('n', '<A-.>', [[:bnext<CR>]], {})
vim.keymap.set('n', '<A-,>', [[:bprev<CR>]], {})

-- Popup menu (insert mode)
-- <C-j> goes to next item,
-- <C-k> goes to previous
-- <CR> to confirm selection
vim.keymap.set('i', '<C-j>', function()
    return vim.fn.pumvisible() == 1 and '<C-n>' or '<C-n>'
end, { expr = true })
vim.keymap.set('i', '<C-k>', function()
    return vim.fn.pumvisible() == 1 and '<C-p>' or '<C-p>'
end, { expr = true })
vim.keymap.set('i', '<CR>', function()
    return vim.fn.pumvisible() == 1 and '<C-y>' or '<CR>'
end, { expr = true })

-- Navigate splits with Alt+h,j,k,l only if not in zellij,
-- to avoid confusion between keybinds
if not vim.env.ZELLIJ then
    vim.keymap.set("n", "<A-h>", "<C-w><C-h>")
    vim.keymap.set("n", "<A-j>", "<C-w><C-j>")
    vim.keymap.set("n", "<A-k>", "<C-w><C-k>")
    vim.keymap.set("n", "<A-l>", "<C-w><C-l>")
end

-- Automatically enable treesitter (found from reddit comment)
local group = vim.api.nvim_create_augroup("auto_start_treesitter", {})
vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})
