return {
  'mfussenegger/nvim-dap',
  dependencies = {
    { 'nvim-neotest/nvim-nio' },
    'rcarriga/nvim-dap-ui',
    {
      'theHamsta/nvim-dap-virtual-text',
      opts = {},
    },
    {
      'mason-org/mason.nvim',
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        table.insert(opts.ensure_installed, 'js-debug-adapter')
      end,
    },
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<F7>',
      function()
        -- require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
  },
  opts = function()
    local dap = require 'dap'
    print 'Entered'
    if not dap.adapters['pwa-node'] then
      require('dap').adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '8090',
        executable = {
          command = 'node',
          -- 💀 Make sure to update this path to point to your installation
          args = {
            '~/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js',
            '8090',
          },
        },
      }
    end
    vim.keymap.set('n', '<leader>B', function()
      require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end)

    if not dap.adapters['node'] then
      dap.adapters['node'] = function(cb, config)
        if config.type == 'node' then
          config.type = 'pwa-node'
        end
        local nativeAdapter = dap.adapters['pwa-node']
        if type(nativeAdapter) == 'function' then
          nativeAdapter(cb, config)
        else
          cb(nativeAdapter)
        end
      end
    end

    local js_filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }

    local vscode = require 'dap.ext.vscode'
    vscode.type_to_filetypes['node'] = js_filetypes
    vscode.type_to_filetypes['pwa-node'] = js_filetypes

    for _, language in ipairs(js_filetypes) do
      if not dap.configurations[language] then
        dap.configurations[language] = {
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch file',
            program = '${file}',
            cwd = '${workspaceFolder}',
          },
          {
            type = 'pwa-node',
            request = 'attach',
            name = 'Attach',
            processId = require('dap.utils').pick_process,
            cwd = '${workspaceFolder}',
          },
        }
      end
    end
  end,
}
