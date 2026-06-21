---@module 'lazy'
---@type LazySpec
return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'sindrets/diffview.nvim',
  },
  cmd = 'Neogit',
  ---@module 'neogit'
  ---@type NeogitConfig
  opts = {
    integrations = { diffview = true },
  },
  keys = {
    { '<leader>gg', '<cmd>Neogit<cr>', desc = '[G]it open Neo[g]it' },
  },
}
