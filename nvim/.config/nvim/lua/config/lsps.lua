local cmp = require('cmp')

local client_capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

cmp.setup {
    snippet = {
        expand = function(args)
            vim.fn['UltiSnips#Anon'](args.body)
        end
    },
    mapping = {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'ultisnips' },
        { name = 'buffer'},
        { name = 'path'},
        { name = 'treesitter'},
        { name = 'tmux'}
    }
}

local nvim_lsp = require('lspconfig')
-- clangd and lua are handled externally
local lsps = {
    'cmake',
    'gopls',
    'pylsp',
    'rust_analyzer',
    'tsserver',
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = 
    vim.lsp.with(vim.lsp .diagnostic.on_publish_diagnostics, { update_in_insert = true })

for _, lsp in ipairs(lsps) do
    nvim_lsp[lsp].setup { 
        capabilities = client_capabilities,
        on_init = function (client)
            client.config.flags.debounce_text_change = 150
        end
    }
end

-- clangd
nvim_lsp.clangd.setup { 
    cmd = {"clangd",
        "--header-insertion=never",
        "--all-scopes-completion",
        "--background-index",
        "--clang-tidy",
        "--cross-file-rename",
        "--suggest-missing-includes",
        "--log=verbose"
    },
    capabilities = client_capabilities
}

-- lua, because it's its own special snowflake
nvim_lsp.sumneko_lua.setup { 
    cmd = {"lua-language-server"},
    settings = {
        Lua = {
            diagnostics = {
                globals = {'vim'} -- Ignore missing vim global which is injected
            }
        }
    },
    capabilities = client_capabilities
}

--keybinds
local m = require('functions.keymap')
m.keys{
    {'n', 'gd', [[<cmd>lua vim.lsp.buf.definition()<CR>]]},
    {'n', '<leader>ri', [[<cmd>lua vim.lsp.buf.implementation()<CR>]]},
    {'n', '<leader>rs', [[<cmd>lua vim.lsp.buf.signature_help()<CR>]]},
    {'n', '<leader>rr', [[<cmd>lua vim.lsp.buf.references()<CR>]]},
    {'n', '<leader>ro', [[<cmd>lua vim.lsp.buf.rename()<CR>]]},
    {'n', '<leader>rh', [[<cmd>lua vim.lsp.buf.hover()<CR>]]},
    {'n', '<leader>re', [[<cmd>lua vim.lsp.buf.code_action()<CR>]]},
    {'n', '<leader>rn', [[<cmd>lua vim.lsp.diagnostic.goto_next()<CR>]]},
    {'n', '<leader>rq', [[<cmd>lua vim.lsp.diagnostic.show_line_diagnostics(); vim.lsp.util.show_line_diagnostics()<CR> ]]}
}

