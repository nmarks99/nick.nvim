-- ==============================
--            Options
-- ==============================
-- See `:help vim.o

vim.g.mapleader = ' '           -- Set <space> as the leader key
vim.g.maplocalleader = ' '
vim.o.hlsearch = true           -- highlight on search after enter
vim.wo.number = true            -- enable line numbers
vim.o.mouse = 'a'               -- Enable mouse mode
vim.o.breakindent = true        -- Enable break indent
vim.o.undofile = true           -- Save undo history
vim.o.ignorecase = true         -- Case-insensitive search...
vim.o.smartcase = true          -- ...unless capital in query
vim.wo.signcolumn = 'yes'       -- Keep signcolumn on by default
vim.o.updatetime = 250          -- Decrease update time
vim.o.timeoutlen = 300
vim.opt.scrolloff = 8           -- scroll 8 lines before bottom
vim.o.termguicolors = true      -- enable nice colors
vim.opt.shiftwidth = 4          -- vim-slueth may change this
vim.opt.belloff = "all"
vim.opt.title = true
vim.opt.incsearch = true
vim.opt.winborder = 'rounded'
vim.o.completeopt = 'menuone,noselect'
vim.schedule(function()         -- sync system clipboard (need wl-wayland on wayland)
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
