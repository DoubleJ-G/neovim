---@module 'lazy'
---@type LazySpec
return {
  { -- Flutter: dartls LSP, run/reload/devices, dev log, widget outline and DAP
    'nvim-flutter/flutter-tools.nvim',
    ft = 'dart',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'mfussenegger/nvim-dap',
    },
    keys = {
      { '<leader>mr', '<cmd>FlutterRun<CR>', ft = 'dart', desc = 'Flutter [r]un' },
      { '<leader>mD', '<cmd>FlutterDebug<CR>', ft = 'dart', desc = 'Flutter [D]ebug (DAP)' },
      { '<leader>mq', '<cmd>FlutterQuit<CR>', ft = 'dart', desc = 'Flutter [q]uit' },
      { '<leader>mh', '<cmd>FlutterReload<CR>', ft = 'dart', desc = 'Flutter [h]ot reload' },
      { '<leader>mR', '<cmd>FlutterRestart<CR>', ft = 'dart', desc = 'Flutter hot [R]estart' },
      { '<leader>md', '<cmd>FlutterDevices<CR>', ft = 'dart', desc = 'Flutter [d]evices' },
      { '<leader>me', '<cmd>FlutterEmulators<CR>', ft = 'dart', desc = 'Flutter [e]mulators' },
      { '<leader>ml', '<cmd>FlutterLogToggle<CR>', ft = 'dart', desc = 'Flutter [l]og toggle' },
      { '<leader>mc', '<cmd>FlutterLogClear<CR>', ft = 'dart', desc = 'Flutter log [c]lear' },
      { '<leader>mo', '<cmd>FlutterOutlineToggle<CR>', ft = 'dart', desc = 'Flutter widget [o]utline' },
      { '<leader>mp', '<cmd>FlutterPubGet<CR>', ft = 'dart', desc = 'Flutter [p]ub get' },
      { '<leader>ms', '<cmd>Telescope flutter commands<CR>', ft = 'dart', desc = 'Flutter [s]earch commands' },
    },
    opts = function()
      return {
        -- Vertical guides showing the widget tree
        widget_guides = { enabled = true },
        -- Virtual text naming the widget a closing bracket belongs to
        closing_tags = { enabled = true, prefix = '// ' },
        -- `flutter run` output, opened in a split instead of a new tab
        dev_log = { enabled = true, open_cmd = 'botright 15split' },
        -- Registers the Dart/Flutter adapters with nvim-dap, used by :FlutterDebug
        debugger = { enabled = true },
        lsp = {
          capabilities = require('blink.cmp').get_lsp_capabilities(),
          settings = {
            completeFunctionCalls = true,
            renameFilesWithClasses = 'prompt',
            updateImportsOnRename = true,
            showTodos = true,
          },
        },
      }
    end,
    config = function(_, opts)
      require('flutter-tools').setup(opts)
      pcall(require('telescope').load_extension, 'flutter')

      -- The widget outline turns off numbers and wrap for its window, and jumping
      -- from it can open the Dart file in that same window. Restore them for Dart files
      vim.api.nvim_create_autocmd('BufWinEnter', {
        group = vim.api.nvim_create_augroup('flutter-restore-win-opts', { clear = true }),
        pattern = '*.dart',
        callback = function()
          vim.wo.number = true
          vim.wo.relativenumber = true
          vim.wo.wrap = true
          vim.wo.winfixwidth = false
        end,
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
