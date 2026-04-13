return {
  'neovim/nvim-lspconfig',
  lazy = false,
  dependencies = {
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    { 'folke/neodev.nvim', opts = {} },
  },
  config = function()
    local function path_exists(path)
      return path and vim.uv.fs_stat(path) ~= nil
    end

    local function resolve_python_env(workspace)
      local venv = vim.env.VIRTUAL_ENV
      if venv and path_exists(venv) then
        local python = venv .. '/bin/python3'
        if not path_exists(python) then
          python = venv .. '/bin/python'
        end

        return {
          python = python,
          venv = vim.fs.basename(venv),
          venv_path = vim.fs.dirname(venv),
        }
      end

      for _, name in ipairs({ '.venv', 'venv' }) do
        local venv_path = workspace .. '/' .. name
        if path_exists(venv_path) then
          local python = venv_path .. '/bin/python3'
          if not path_exists(python) then
            python = venv_path .. '/bin/python'
          end

          return {
            python = python,
            venv = name,
            venv_path = workspace,
          }
        end
      end

      local python = vim.fn.exepath('python3')
      if python == '' then
        python = vim.fn.exepath('python')
      end

      return {
        python = python ~= '' and python or 'python3',
      }
    end

    local function apply_pyright_python(config, workspace)
      local env = resolve_python_env(workspace)

      config.settings = config.settings or {}
      config.settings.python = config.settings.python or {}
      config.settings.python.pythonPath = env.python

      if env.venv and env.venv_path then
        config.settings.python.venv = env.venv
        config.settings.python.venvPath = env.venv_path
      end
    end

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    local servers = {
      gopls = {
        cmd = { '/Users/wonbinjin/go/bin/gopls' },
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
          },
        },
      },
      pyright = {
        before_init = function(_, config)
          apply_pyright_python(config, config.root_dir)
        end,
        on_new_config = function(config, root_dir)
          apply_pyright_python(config, root_dir)
        end,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = 'workspace',
            },
          },
        },
      },
    }

    require('mason').setup()

    local ensure_installed = vim.tbl_keys(servers)
    vim.list_extend(ensure_installed, { 'stylua' })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }

    vim.diagnostic.config({
      virtual_text = false,
    })

    vim.api.nvim_set_keymap(
      'n',
      '<Leader>d',
      ':lua vim.diagnostic.open_float()<CR>',
      { noremap = true, silent = true }
    )
  end,
}
