return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        vtsls = {
          root_dir = function(bufnr, on_dir)
            -- The project root is where the LSP can be started from
            -- As stated in the documentation above, this LSP supports monorepos and simple projects.
            -- We select then from the project root, which is identified by the presence of a package
            -- manager lock file.
            local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml' }
            local project_root = vim.fs.root(bufnr, root_markers) or ''
            if project_root ~= '' then
              on_dir(project_root)
            end
          end,
          settings = {
            typescript = {
              inlayHints = {
                parameterNames = { enabled = 'literals' },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
            },
            javascript = {
              inlayHints = {
                parameterNames = { enabled = 'literals' },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
            },
            -- vtsls = {},
          },
        },

        denols = {
          workspace_required = true,
          root_markers = { 'deno.json', 'deno.jsonc' },
        },

        eslint = {
          cmd = { 'eslint', '--stdio' },
        },
      },
    },
  },

  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        javascript = { 'prettierd' },
        typescript = { 'prettierd' },
        typescriptreact = { 'prettierd' },
      },
    },
  },
}
