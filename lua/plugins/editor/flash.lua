---@module 'lazy'
---@type LazySpec
return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  ---@module 'flash'
  ---@type Flash.Config
  opts = {},
  keys = {
    { 's', function() require('flash').jump() end, mode = { 'n', 'x', 'o' }, desc = 'Flash jump' },
    { 'S', function() require('flash').treesitter() end, mode = { 'n', 'x', 'o' }, desc = 'Flash treesitter select' },
    { 'r', function() require('flash').remote() end, mode = 'o', desc = 'Flash remote' },
    { 'R', function() require('flash').treesitter_search() end, mode = { 'x', 'o' }, desc = 'Flash treesitter search' },
    { '<c-s>', function() require('flash').toggle() end, mode = 'c', desc = 'Flash toggle search' },
  },
}
