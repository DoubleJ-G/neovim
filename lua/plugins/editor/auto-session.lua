-- auto-session saves and restores Neovim sessions automatically
-- https://github.com/rmagatti/auto-session

---@module 'lazy'
---@type LazySpec
return {
  'rmagatti/auto-session',
  lazy = false,
  ---@module 'auto-session'
  opts = {
    suppressed_dirs = { '~/', '~/Downloads' },
  },
  keys = {
    {
      '<leader>ws',
      '<cmd>SessionSave<CR>',
      desc = '[S]ave session',
    },
    {
      '<leader>wr',
      '<cmd>SessionRestore<CR>',
      desc = '[R]estore session',
    },
    {
      '<leader>wl',
      '<cmd>SessionSearch<CR>',
      desc = 'Search session [L]ist',
    },
    {
      '<leader>wd',
      '<cmd>SessionDelete<CR>',
      desc = '[D]elete session',
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
