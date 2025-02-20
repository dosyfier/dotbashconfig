return {
  -- Linting plugin
  { "mfussenegger/nvim-lint" },

  -- LSP (Language Server Protocol) support
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      servers = {
        ansiblels = {},
        awk_ls = {},
        bashls = {},
        cmake = {},
        docker_compose_language_service = {},
        dockerls = {},
        gitlab_ci_ls = {},
        groovyls = {},
        helm_ls = {},
        java_language_server = {},
        jinja_lsp = {},
        jqls = {},
        nginx_language_server = {},
        perlnavigator = {},
        pyright = {},
        -- TODO: https://github.com/palantir/python-language-server
        rubocop = {},
        yamlls = {
          settings = {
            yaml = {
              -- Cf. https://github.com/redhat-developer/vscode-yaml/issues/703#issuecomment-1566947989
              customTags = {'!vault scalar'}
            }
          }
        },
      },
      -- This commented-out block of code may allow to turn off
      -- supplemental color highlighting applied by nvim-lspconfig.
      -- Cf. https://neovim.io/doc/user/lsp.html#_lsp-semantic-highlights
      -- setup = {
      --   require("lazyvim.util").lsp.on_attach(function(client)
      --     -- Hide semantic highlights for functions
      --     vim.api.nvim_set_hl(0, '@lsp.type.function', {})
      --     -- Hide all semantic highlights
      --     for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
      --       vim.api.nvim_set_hl(0, group, {})
      --     end
      --   end)
      -- }
      diagnostics = {
        virtual_text = {
          source = "always",
          format = function(diagnostic)
            if diagnostic.user_data.lsp.code == nil then
              return diagnostic.message
            else
              return string.format("[%s] %s", diagnostic.user_data.lsp.code, diagnostic.message)
            end
          end
        }
      }
    },
  },
}
