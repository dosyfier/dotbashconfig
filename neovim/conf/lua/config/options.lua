-- Configure <leader> key
vim.g.mapleader = " "

-- Enable relative line numbers by default
vim.opt.rnu = true

-- Indentation settings for using 2 spaces instead of tabs.
vim.opt.softtabstop = 2
vim.opt.expandtab = true

-- Indentation settings for using hard tabs for indent. Display tabs as
-- four characters wide.
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- Always wrap long lines for display
vim.opt.wrap = true

-- Set the command window height to 2 lines, to avoid many cases of having to
-- "press <Enter> to continue"
vim.opt.cmdheight = 2

-- Default to not read-only in vimdiff
vim.opt.ro = false

-- Allow modeline headers to activate declaratively specific vim syntax,
-- regardless of rules defined for vim
vim.opt.modeline = true
vim.opt.modelines = 5

-- Make searches case-insensitive by default
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Allow block folding in Vim editors
if vim.api.nvim_win_get_option(0, 'diff') then
  vim.opt.foldmethod = 'diff'
else
  vim.opt.foldmethod = 'indent'
end

-- Enable termguicolors, especially to let bufferline.nvim plugin work
-- ("as it reads the hex "gui" color values of various highlight groups")
vim.opt.termguicolors = true
