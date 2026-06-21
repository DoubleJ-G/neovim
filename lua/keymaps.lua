-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic Config & Keymaps
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Can switch between these as you prefer
  virtual_text = true,   -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
}

vim.keymap.set('n', '<C-s>', ':update<CR>', { desc = 'Write', silent = true })

vim.keymap.set('n', '<leader>bD', function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
      require('mini.bufremove').delete(buf, false)
    end
  end
end, { desc = 'Buffer [D]elete all others' })

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Restart LSP if it stops working
vim.keymap.set('n', '<leader>rs', ':lsp restart<CR>', { desc = 'Restart LSP' })

-- [[ Git (Fugitive + Telescope) ]]
vim.keymap.set('n', '<leader>gg', '<cmd>Git<CR>', { desc = '[G]it status (fugitive)' })
vim.keymap.set('n', '<leader>gc', '<cmd>Git commit<CR>', { desc = '[G]it [c]ommit' })
vim.keymap.set('n', '<leader>gC', '<cmd>Git commit --amend<CR>', { desc = '[G]it [C]ommit amend' })
vim.keymap.set('n', '<leader>gp', '<cmd>Git push<CR>', { desc = '[G]it [p]ush' })
vim.keymap.set('n', '<leader>gP', '<cmd>Git pull<CR>', { desc = '[G]it [P]ull' })
vim.keymap.set('n', '<leader>gd', '<cmd>Gvdiffsplit<CR>', { desc = '[G]it [d]iff split (vertical)' })
vim.keymap.set('n', '<leader>gb', '<cmd>Git blame<CR>', { desc = '[G]it [b]lame' })
vim.keymap.set('n', '<leader>gr', '<cmd>Gread<CR>', { desc = '[G]it [r]ead (checkout file)' })
vim.keymap.set('n', '<leader>gw', '<cmd>Gwrite<CR>', { desc = '[G]it [w]rite (stage file)' })
-- Telescope git pickers
vim.keymap.set('n', '<leader>gl', function() require('telescope.builtin').git_commits() end,
  { desc = '[G]it [l]og (commits)' })
vim.keymap.set('n', '<leader>gL', function() require('telescope.builtin').git_bcommits() end,
  { desc = '[G]it [L]og buffer commits' })
vim.keymap.set('n', '<leader>gB', function() require('telescope.builtin').git_branches() end,
  { desc = '[G]it [B]ranches' })
vim.keymap.set('n', '<leader>gs', function() require('telescope.builtin').git_status() end,
  { desc = '[G]it [s]tatus (telescope)' })
vim.keymap.set('n', '<leader>gS', function() require('telescope.builtin').git_stash() end, { desc = '[G]it [S]tash' })

-- LspInfo is not registered on Neovim 0.11+ due to early-exit guard in nvim-lspconfig
vim.api.nvim_create_user_command('LspInfo', ':checkhealth vim.lsp', { desc = 'Alias to checkhealth vim.lsp' })

-- vim: ts=2 sts=2 sw=2 et
