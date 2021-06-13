local nvim_lsp = require('lspconfig')
lsps = {"clangd", "pyls", "rust_analyzer", "tsserver", "jdtls", "gopls"}

for _, lsp in ipairs(lsps) do 
    nvim_lsp[lsp].setup{on_attach = require 'completion'.on_attach}
end 
