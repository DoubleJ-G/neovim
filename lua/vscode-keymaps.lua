-- [[ VSCode / Cursor Keymaps ]]
--  Only loaded when running inside vscode-neovim (`vim.g.vscode`).
--  Loaded after plugins, so these override the plugin-backed keymaps
--  from `keymaps.lua` and the plugin specs with the equivalent VSCode commands.
--  See https://github.com/vscode-neovim/vscode-neovim#%EF%B8%8F-api

local vscode = require 'vscode'

local map = function(mode, keys, action, desc, opts)
  vim.keymap.set(mode, keys, function() vscode.action(action, opts) end, { desc = desc })
end

-- [[ Search (Telescope) ]]
-- Like Telescope find_files: list every workspace file up front.
--  quickOpen only shows recent files until you type, so build the picker here.
--  Respects files.exclude and search.exclude (node_modules etc.), not .gitignore
vim.keymap.set('n', '<leader>sf', function()
  vscode.eval_async [[
    const config = {
      ...vscode.workspace.getConfiguration('files').get('exclude'),
      ...vscode.workspace.getConfiguration('search').get('exclude'),
    }
    const exclude = `{${Object.keys(config).filter((glob) => config[glob] === true).join(',')}}`
    const files = await vscode.workspace.findFiles('**/*', exclude, 20000)
    const items = files
      .map((uri) => ({ label: vscode.workspace.asRelativePath(uri), uri }))
      .sort((a, b) => a.label.localeCompare(b.label))
    const pick = await vscode.window.showQuickPick(items, { placeHolder: 'Search Files' })
    if (pick) await vscode.window.showTextDocument(pick.uri)
  ]]
end, { desc = '[S]earch [F]iles' })
map('n', '<leader>s.', 'workbench.action.quickOpen', '[S]earch Recent Files')
map({ 'n', 'v' }, '<leader>sg', 'workbench.action.findInFiles', '[S]earch by [G]rep')
vim.keymap.set('n', '<leader>sw', function()
  vscode.action('workbench.action.findInFiles', { args = { { query = vim.fn.expand '<cword>' } } })
end, { desc = '[S]earch current [W]ord' })
map('v', '<leader>sw', 'workbench.action.findInFiles', '[S]earch current [W]ord')
map('n', '<leader>/', 'actions.find', '[/] Fuzzily search in current buffer')
map('n', '<leader><leader>', 'workbench.action.showAllEditors', '[ ] Find existing buffers')
map('n', '<leader>sc', 'workbench.action.showCommands', '[S]earch [C]ommands')
map('n', '<leader>sk', 'workbench.action.openGlobalKeybindings', '[S]earch [K]eymaps')
map('n', '<leader>sd', 'workbench.actions.view.problems', '[S]earch [D]iagnostics')

-- [[ Files & Buffers (Neo-tree, mini.bufremove) ]]
-- Like Neo-tree: reveal the current file, or close the sidebar if we opened it.
--  VSCode doesn't expose sidebar visibility, so this tracks it locally
--  (if you close it another way, the next press just reveals again)
local explorer_open = false
vim.keymap.set('n', '<leader>nt', function()
  vscode.action(explorer_open and 'workbench.action.closeSidebar' or 'workbench.files.action.showActiveFileInExplorer')
  explorer_open = not explorer_open
end, { desc = '[N]eo-[T]ree toggle (reveal file)' })
map('n', '<leader>bd', 'workbench.action.closeActiveEditor', 'Buffer [D]elete')
map('n', '<leader>bD', 'workbench.action.closeOtherEditors', 'Buffer [D]elete all others')

-- [[ Windows & Terminal ]]
map('n', '<C-h>', 'workbench.action.navigateLeft', 'Move focus to the left window')
map('n', '<C-l>', 'workbench.action.navigateRight', 'Move focus to the right window')
map('n', '<C-j>', 'workbench.action.navigateDown', 'Move focus to the lower window')
map('n', '<C-k>', 'workbench.action.navigateUp', 'Move focus to the upper window')
map('n', '<c-\\>', 'workbench.action.terminal.toggle', 'Toggle Terminal')
map('n', '<leader>cc', 'workbench.action.toggleAuxiliaryBar', 'Toggle AI [C]hat pane')

-- [[ Diagnostics (Trouble) ]]
map('n', '<leader>e', 'editor.action.showHover', 'Show diagnostic [E]rror messages')
map('n', '<leader>q', 'workbench.actions.view.problems', 'Open diagnostic [Q]uickfix list')
map('n', '<leader>xx', 'workbench.actions.view.problems', 'Trouble: buffer diagnostics')
map('n', '<leader>xX', 'workbench.actions.view.problems', 'Trouble: workspace diagnostics')

-- [[ LSP & Formatting (Conform) ]]
map('n', '<leader>rn', 'editor.action.rename', '[R]e[n]ame')
map('n', 'grn', 'editor.action.rename', '[R]e[n]ame')
map({ 'n', 'x' }, '<leader>ca', 'editor.action.quickFix', '[C]ode [A]ction')
map({ 'n', 'x' }, 'gra', 'editor.action.quickFix', '[C]ode [A]ction')
map('n', 'grr', 'editor.action.goToReferences', '[G]oto [R]eferences')
map('n', 'gri', 'editor.action.goToImplementation', '[G]oto [I]mplementation')
map('n', 'grt', 'editor.action.goToTypeDefinition', '[G]oto [T]ype Definition')
map('n', 'gO', 'workbench.action.gotoSymbol', 'Open Document Symbols')
map('n', '<leader>ci', 'editor.action.sourceAction', 'Add missing imports',
  { args = { { kind = 'source.addMissingImports.ts', apply = 'first' } } })
map('n', '<leader>rs', 'typescript.restartTsServer', 'Restart LSP')
map('n', '<leader>f', 'editor.action.formatDocument', '[F]ormat buffer')
map('v', '<leader>f', 'editor.action.formatSelection', '[F]ormat selection')

-- [[ Git (Fugitive + Telescope) ]]
map('n', '<leader>gg', 'workbench.view.scm', '[G]it status')
map('n', '<leader>gs', 'workbench.view.scm', '[G]it [s]tatus')
map('n', '<leader>gc', 'git.commit', '[G]it [c]ommit')
map('n', '<leader>gC', 'git.commitStagedAmend', '[G]it [C]ommit amend')
map('n', '<leader>gp', 'git.push', '[G]it [p]ush')
map('n', '<leader>gP', 'git.pull', '[G]it [P]ull')
map('n', '<leader>gd', 'git.openChange', '[G]it [d]iff split')
map('n', '<leader>gb', 'gitlens.toggleFileBlame', '[G]it [b]lame')
map('n', '<leader>gr', 'git.clean', '[G]it [r]ead (discard file changes)')
map('n', '<leader>gw', 'git.stage', '[G]it [w]rite (stage file)')
map('n', '<leader>gl', 'gitlens.showQuickRepoHistory', '[G]it [l]og (commits)')
map('n', '<leader>gL', 'gitlens.showQuickFileHistory', '[G]it [L]og buffer commits')
map('n', '<leader>gB', 'git.checkout', '[G]it [B]ranches')
map('n', '<leader>gS', 'git.stashApply', '[G]it [S]tash')

-- [[ Git hunks (Gitsigns) ]]
map({ 'n', 'v' }, '<leader>hs', 'git.stageSelectedRanges', 'git [s]tage hunk')
map({ 'n', 'v' }, '<leader>hr', 'git.revertSelectedRanges', 'git [r]eset hunk')
map({ 'n', 'v' }, '<leader>hu', 'git.unstageSelectedRanges', 'git [u]nstage hunk')
map('n', '<leader>hS', 'git.stage', 'git [S]tage buffer')
map('n', '<leader>hR', 'git.clean', 'git [R]eset buffer')
map('n', '<leader>hp', 'editor.action.dirtydiff.next', 'git [p]review hunk')
map('n', '<leader>hb', 'gitlens.showQuickCommitFileDetails', 'git [b]lame line')
map('n', '<leader>hd', 'git.openChange', 'git [d]iff against index')
map('n', '<leader>tb', 'gitlens.toggleLineBlame', '[T]oggle git show [b]lame line')
map('n', ']c', 'workbench.action.editor.nextChange', 'Jump to next git [c]hange')
map('n', '[c', 'workbench.action.editor.previousChange', 'Jump to previous git [c]hange')

-- [[ Debug (DAP) ]]
-- Like `dap.continue()`: start a session if none is running, otherwise continue
vim.keymap.set('n', '<leader>dc', function()
  vscode.eval [[
    const cmd = vscode.debug.activeDebugSession ? 'workbench.action.debug.continue' : 'workbench.action.debug.start'
    await vscode.commands.executeCommand(cmd)
  ]]
end, { desc = 'DAP Continue' })
map('n', '<leader>do', 'workbench.action.debug.stepOver', 'DAP Step Over')
map('n', '<leader>di', 'workbench.action.debug.stepInto', 'DAP Step Into')
map('n', '<leader>dO', 'workbench.action.debug.stepOut', 'DAP Step Out')
map('n', '<leader>b', 'editor.debug.action.toggleBreakpoint', 'DAP Toggle Breakpoint')
map('n', '<leader>dr', 'workbench.debug.action.toggleRepl', 'DAP REPL')
map('n', '<leader>du', 'workbench.view.debug', 'DAP UI Toggle')

-- [[ Tests (Neotest) ]]
map('n', '<leader>tt', 'testing.runAtCursor', '[T]est run nearest')
map('n', '<leader>tf', 'testing.runCurrentFile', '[T]est run [F]ile')
map('n', '<leader>ts', 'workbench.view.testing.focus', '[T]est [S]ummary')
map('n', '<leader>to', 'testing.showMostRecentOutput', '[T]est [O]utput panel')
map('n', '<leader>tS', 'testing.cancelRun', '[T]est [S]top')

-- Move selected lines without `=` reindenting (VSCode maps `=` to format selection)
vim.keymap.set('x', 'J', ":move '>+1<CR>gv", { desc = 'Move selected lines down', silent = true })
vim.keymap.set('x', 'K', ":move '<-2<CR>gv", { desc = 'Move selected lines up', silent = true })

-- vim: ts=2 sts=2 sw=2 et
