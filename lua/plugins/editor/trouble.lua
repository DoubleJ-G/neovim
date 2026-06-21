---@module 'lazy'
---@type LazySpec
return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  ---@module 'trouble'
  ---@type trouble.Config
  opts = {},
  keys = {
    { '<leader>xx', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Trouble: buffer diagnostics' },
    { '<leader>xX', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Trouble: workspace diagnostics' },
    { '<leader>xq', '<cmd>Trouble qflist toggle<cr>', desc = 'Trouble: quickfix list' },
    { '<leader>xl', '<cmd>Trouble loclist toggle<cr>', desc = 'Trouble: location list' },
    { '<leader>xt', '<cmd>Trouble todo toggle<cr>', desc = 'Trouble: TODOs' },
  },
}
