return {
  {
    'Mofiqul/dracula.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      require('dracula').setup()

      -- Load the colorscheme here.
      vim.cmd.colorscheme 'dracula'
    end,
  },
}
