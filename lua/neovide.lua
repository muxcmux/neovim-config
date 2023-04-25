if vim.g.neovide then
  vim.o.guifont = "SFMono Nerd Font:h15"
  vim.opt.linespace = 6
  vim.g.neovide_confirm_quit = true
  vim.g.neovide_input_use_logo = 1
  vim.g.neovide_cursor_vfx_mode = "pixiedust"
  vim.g.neovide_cursor_vfx_particle_density = 25
  vim.g.neovide_cursor_vfx_particle_phase = 4
  vim.g.neovide_cursor_vfx_particle_lifetime = 2
  vim.g.neovide_cursor_trail_size = 0.4
  vim.g.neovide_cursor_animation_length = 0.08

  vim.g.neovide_padding_top = 6
  vim.g.neovide_padding_bottom = 6
  vim.g.neovide_padding_right = 6
  vim.g.neovide_padding_left = 6

  vim.keymap.set({"n", "i", "v"}, '<D-v>', '<ESC>"+p<CR>', { noremap = true, silent = true})

  vim.keymap.set({"n", "i", "v"}, '<D-s>', '<ESC>:w<CR>', { noremap = true, silent = true})

  vim.keymap.set("v", '<D-c>', '"+y', { noremap = true, silent = true})
  vim.keymap.set("n", '<D-c>', '"+yy', { noremap = true, silent = true})

  vim.keymap.set({"n", "i", "v"}, '<D-Bslash>', '<ESC>:Neotree toggle<CR>', { noremap = true, silent = true})

  vim.keymap.set({"n", "i", "v"}, '<D-v>', '<ESC>"+p<CR>', { noremap = true, silent = true})

  vim.keymap.set({"n", "i", "v"}, '<D-p>', '<ESC>:Telescope find_files<CR>', { noremap = true, silent = true})

  vim.keymap.set({"n", "i", "v"}, '<D-t>', '<ESC>:Telescope git_files<CR>', { noremap = true, silent = true})

  vim.keymap.set({"n", "i", "v"}, '<D-b>', '<ESC>:Telescope buffers<CR>', { noremap = true, silent = true})


  vim.keymap.set({"n", "i", "v"}, '<D-w>', '<ESC>:Neotree close<CR>:bd<CR>', { noremap = true, silent = true})

  vim.keymap.set({"n", "i", "v"}, '<D-n>', '<ESC>:enew<CR>', { noremap = true, silent = true})

  vim.keymap.set({"n", "i", "v"}, '<D-a>', '<ESC>ggVG', { noremap = true, silent = true})

  vim.keymap.set({"n", "i", "v"}, '<S-D-f>', '<ESC>:Telescope live_grep<CR>', { noremap = true, silent = true})
  vim.keymap.set({"n", "i", "v"}, '<D-f>', '<ESC>:Telescope current_buffer_fuzzy_find<CR>', { noremap = true, silent = true})
end
