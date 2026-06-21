---@module 'lazy'
---@type LazySpec
return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'marilari88/neotest-vitest',
    'haydenmeade/neotest-jest',
  },
  keys = {
    { '<leader>tt', function() require('neotest').run.run() end, desc = '[T]est run nearest' },
    { '<leader>tf', function() require('neotest').run.run(vim.fn.expand '%') end, desc = '[T]est run [F]ile' },
    { '<leader>ts', function() require('neotest').summary.toggle() end, desc = '[T]est [S]ummary' },
    { '<leader>to', function() require('neotest').output_panel.toggle() end, desc = '[T]est [O]utput panel' },
    { '<leader>tS', function() require('neotest').run.stop() end, desc = '[T]est [S]top' },
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-vitest',
        require 'neotest-jest' {
          jestCommand = 'npx jest',
        },
      },
    }
  end,
}
