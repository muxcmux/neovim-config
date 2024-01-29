local key = vim.keymap

-- Diagnostics navigation
local opts = { silent = true, noremap = true }
key.set("n", "]g", vim.diagnostic.goto_next, opts)
key.set("n", "[g", vim.diagnostic.goto_prev, opts)
key.set("n", "<leader>e", ":Trouble document_diagnostics<CR>", opts)
key.set("n", "<leader>we", ":Trouble workspace_diagnostics<CR>", opts)
key.set("n", "<leader>q", ":TroubleClose<CR>:cclose<CR>", opts)
-- Common LSP maps
key.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, opts)

-- Change Ctrl-e/y to move 5 lines at a time
key.set("n", "<C-e>", "5<C-e>")
key.set("n", "<C-y>", "5<C-y>")

-- Less disorienting movement on screen
-- this doesn't work well with smooth scrolling in neovide
if not vim.g.neovide then
  key.set("n", "<C-u>", "<C-u>zz")
  key.set("n", "<C-d>", "<C-d>zz")
  key.set("n", "n", "nzzzv")
  key.set("n", "N", "Nzzzv")
end

-- Exit insert mode by typing jk in quick succession
key.set("i", "jk", "<Esc>")

-- Keep selection when indenting
key.set("v", "<", "<gv")
key.set("v", ">", ">gv")

-- Ctrl-R on highlighted text to replace it with prompt
key.set("v", "<C-r>", [["hy:%s/<C-r>h//gc<left><left><left>]])

-- navigate quickfix list
key.set("n", "<leader>n", ":cnext<CR>", { silent = true })
key.set("n", "<leader>p", ":cprev<CR>", { silent = true })

-- navigate splits with arrow keys in normal mode
key.set("n", "<Up>", ":wincmd k<CR>", { silent = true})
key.set("n", "<Down>", ":wincmd j<CR>", { silent = true})
key.set("n", "<Left>", ":wincmd h<CR>", { silent = true})
key.set("n", "<Right>", ":wincmd l<CR>", { silent = true})
key.set("n", "<S-Up>", ":res +1<CR>", { silent = true})
key.set("n", "<S-Down>", ":res -1 j<CR>", { silent = true})
key.set("n", "<S-Left>", ":vertical res +1<CR>", { silent = true})
key.set("n", "<S-Right>", ":vertical res -1<CR>", { silent = true})

-- Disable annoying auto comment when going into
-- insert mode with o or O from a commented line
vim.api.nvim_create_autocmd("FileType", { pattern = "*", command = "set formatoptions-=o" })

-- Option + j/k to move line or selection up or down
-- very Mac specific shit
key.set("n", "∆"    , ":m .+1<CR>=="       , { silent = true })
key.set("n", "˚"    , ":m .-2<CR>=="       , { silent = true })
key.set("n", "<M-j>", ":m .+1<CR>=="       , { silent = true })
key.set("n", "<M-k>", ":m .-2<CR>=="       , { silent = true })
key.set("i", "∆"    , "<Esc>:m .+1<CR>==gi", { silent = true })
key.set("i", "˚"    , "<Esc>:m .-2<CR>==gi", { silent = true })
key.set("i", "<M-j>", "<Esc>:m .+1<CR>==gi", { silent = true })
key.set("i", "<M-k>", "<Esc>:m .-2<CR>==gi", { silent = true })
key.set("v", "∆"    , ":m '>+1<CR>gv=gv"   , { silent = true })
key.set("v", "˚"    , ":m '<-2<CR>gv=gv"   , { silent = true })
key.set("v", "<M-j>", ":m '>+1<CR>gv=gv"   , { silent = true })
key.set("v", "<M-k>", ":m '<-2<CR>gv=gv"   , { silent = true })
