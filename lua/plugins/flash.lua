-- return {
--   {
--     'ggandor/leap.nvim',
--     event = { "BufReadPost", "BufNewFile" },
--     config = function()
--       vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
--       vim.api.nvim_set_hl(0, 'LeapMatch', {
--         fg = 'white',  -- for light themes, set to 'black' or similar
--         bold = true,
--         nocombine = true,
--       })
--       require('leap').opts.highlight_unlabeled_phase_one_targets = true
--       require('leap').opts.case_sensitive = true
--       require('leap').add_default_mappings()
--     end,
--   }
-- }
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    modes = {
      char = { enabled = false },
      search = { enabled = false },
    },
  },
  keys = {
    { "s", mode = "n", function() require("flash").jump() end, desc = "Flash" },
  },
}
