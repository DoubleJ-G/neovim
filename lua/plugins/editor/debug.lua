return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim', -- bridges Mason + dap automatically
    },
    keys = {
      { '<leader>dc', function() require('dap').continue() end, desc = 'DAP Continue' },
      { '<leader>do', function() require('dap').step_over() end, desc = 'DAP Step Over' },
      { '<leader>di', function() require('dap').step_into() end, desc = 'DAP Step Into' },
      { '<leader>dO', function() require('dap').step_out() end, desc = 'DAP Step Out' },
      { '<leader>b', function() require('dap').toggle_breakpoint() end, desc = 'DAP Toggle Breakpoint' },
      { '<leader>dr', function() require('dap').repl.open() end, desc = 'DAP REPL' },
      { '<leader>du', function() require('dapui').toggle() end, desc = 'DAP UI Toggle' },
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      -- mason-nvim-dap handles installing js-debug-adapter via Mason
      require('mason-nvim-dap').setup {
        ensure_installed = { 'js' },
        automatic_installation = true,
        handlers = {}, -- use default handlers
      }

      -- Breakpoint signs (Nerd Font Icons)
      vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
      vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DapBreakpointCondition', linehl = '', numhl = '' })
      vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapBreakpointRejected', linehl = '', numhl = '' })
      vim.fn.sign_define('DapLogPoint', { text = '  ', texthl = 'DapLogPoint', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '  ', texthl = 'DapStopped', linehl = 'DapStoppedLine', numhl = '' })

      -- Highlight groups
      vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#e06c75' }) -- Red circle
      vim.api.nvim_set_hl(0, 'DapBreakpointCondition', { fg = '#e5c07b' }) -- Yellow question mark
      vim.api.nvim_set_hl(0, 'DapBreakpointRejected', { fg = '#5c6370' }) -- Grey warning sign
      vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#61afef' }) -- Blue log indicator

      -- Separation of the icon color and the execution line background
      vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#98c379' }) -- Green execution arrow
      vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = '#2d3343' })

      -- Adapter
      dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'js-debug-adapter',
          args = { '${port}' },
        },
      }

      -- Configurations
      local ts_config = {
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach to tsx --inspect (pick process)',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
          sourceMaps = true,
          resolveSourceMapLocations = {
            '${workspaceFolder}/**',
            '!**/node_modules/**',
          },
          skipFiles = { '<node_internals>/**', '**/node_modules/**' },
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach to tsx --inspect (port 9229)',
          port = 9229,
          cwd = '${workspaceFolder}',
          sourceMaps = true,
          resolveSourceMapLocations = {
            '${workspaceFolder}/**',
            '!**/node_modules/**',
          },
          skipFiles = { '<node_internals>/**', '**/node_modules/**' },
        },
      }

      dap.configurations.typescript = ts_config
      dap.configurations.typescriptreact = ts_config
      dap.configurations.javascript = ts_config -- handy if tsx runs .js too

      -- dap-ui
      dapui.setup()

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close
    end,
  },
}
