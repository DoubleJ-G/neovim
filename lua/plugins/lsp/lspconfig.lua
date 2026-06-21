return {
  { 'williamboman/mason.nvim', opts = {} },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim',  opts = {} },
      { 'folke/lazydev.nvim', opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc) vim.keymap.set('n', keys, func,
              { buffer = event.buf, desc = 'LSP: ' .. desc }) end

          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if client and client.server_capabilities.documentHighlightProvider then
            local hl = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = hl,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = hl,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
              '[T]oggle Inlay [H]ints')
          end

          if client and client.name == 'eslint' then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = event.buf,
              command = 'EslintFixAll',
            })
          end
        end,
      })

      vim.lsp.config('*', {
        capabilities = require('blink.cmp').get_lsp_capabilities(),
      })

      require('mason-tool-installer').setup {
        ensure_installed = {
          'stylua',
          'ts_ls',
          'eslint',
          'lua-language-server',
          'vue-language-server',
        },
      }

      require('mason-lspconfig').setup {
        ensure_installed = { 'ts_ls', 'lua_ls', 'eslint' },
        automatic_enable = true,
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
