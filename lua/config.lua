local opt = vim.opt

opt.termguicolors  = true
opt.confirm        = true
-- opt.showmode       = false
opt.errorbells     = true
opt.expandtab      = true
opt.shiftwidth     = 2
opt.softtabstop    = 2
opt.laststatus     = 0
opt.smartindent    = true
opt.relativenumber = true
opt.nu             = true
opt.hidden         = true
opt.incsearch      = true
opt.hlsearch       = false
opt.ignorecase     = true
opt.smartcase      = true
opt.wrap           = false
opt.cursorline     = true
opt.swapfile       = false
opt.undofile       = true
opt.undodir        = "/Users/muxcmux/.nvimundodir"
opt.scrolloff      = 4
opt.sidescrolloff  = 4
opt.mouse          = "a"
opt.listchars      = "trail:~"
opt.list           = true
opt.backspace      = "indent,eol,start"
opt.colorcolumn    = "100"
opt.signcolumn     = "yes"
opt.shell          = "/bin/zsh"
opt.background     = "dark"
opt.foldlevelstart = 20
opt.updatetime     = 250
opt.completeopt    = "menu,menuone,noselect"
opt.iskeyword:append("-")
-- opt.iskeyword:remove("_")

vim.g.mapleader = " "

-- get rid of netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- higlighted yank
vim.cmd [[
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup=(vim.fn['hlexists']('HighlightedyankRegion') > 0 and 'HighlightedyankRegion' or 'IncSearch'), timeout=180}
]]
