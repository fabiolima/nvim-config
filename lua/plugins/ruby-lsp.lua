-- local util = require("lspconfig.util")

-- return {
--   default_config = {
--     cmd = { 'solargraph', 'stdio' },
--     settings = {
--       solargraph = {
--         diagnostics = true,
--       },
--     },
--     init_options = { formatting = true },
--     filetypes = { 'ruby' },
--     root_dir = util.root_pattern('Gemfile', '.git'),
--   },
--   docs = {
--     description = [[
-- https://solargraph.org/
--
-- solargraph, a language server for Ruby
--
-- You can install solargraph via gem install.
--
-- ```sh
-- gem install --user-install solargraph
-- ```
--     ]],
--   },
-- }
-- return {
--   {
--     "neovim/nvim-lspconfig",
--     lazy = false,
--     opts = {
--       servers = {
--         solargraph = {
--           mason = false,
--           cmd = { vim.fn.expand("~/.rbenv/shims/solargraph"), "stdio" },
--         },
--         rubocop = {
--           mason = false,
--           cmd = { vim.fn.expand("~/.rbenv/shims/rubocop"), "--lsp" },
--         },
--       },
--     },
--   },
-- }
local lspconfig = require("lspconfig")

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Useful for debugging formatter issues
      format_notify = true,
      servers = {
        -- rubocop = {
        --   mason = false,
        --   -- See: https://docs.rubocop.org/rubocop/usage/lsp.html
        --   -- cmd = { "bundle", "exec", "rubocop", "--lsp" },
        --   -- cmd = { vim.fn.expand("~/.rbenv/shims/rubocop"), "--lsp" },
        --   -- root_dir = lspconfig.util.root_pattern("Gemfile", ".git", "."),
        -- },
        solargraph = {
          mason = false,
          -- See: https://medium.com/@cristianvg/neovim-lsp-your-rbenv-gemset-and-solargraph-8896cb3df453
          cmd = { os.getenv("HOME") .. "/.rbenv/shims/solargraph", "stdio" },
          -- root_dir = lspconfig.util.root_pattern("Gemfile", ".git", "."),
          settings = {
            solargraph = {
              autoformat = true,
              completion = true,
              diagnostics = true,
              folding = true,
              references = true,
              rename = true,
              symbols = true,
            },
          },
        },
      },
    },
  },
}
