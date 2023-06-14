local config = require("plugins.configs.lspconfig")

local on_attach = config.on_attach
local capabilities = config.capabilities

local lspconfig = require("lspconfig")

lspconfig.pyright.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"python"},
})

-- Web Development
lspconfig.tsserver.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.astro.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})
