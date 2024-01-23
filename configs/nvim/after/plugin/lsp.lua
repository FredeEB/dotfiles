local m = require('functions.keymap')

-- cmp
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup {
    snippet = {
        expand = function(args) require('luasnip').lsp_expand(args.body) end
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-j>'] = cmp.mapping(function (fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, {'i','s'}),
        ['<C-k>'] = cmp.mapping(function (fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.expand_or_jumpable(-1) then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, {'i','s'})
    },
    sources = {
        { name = 'nvim_lsp_signature_help' },
        { name = 'nvim_lsp', max_item_count = 20, priority = 10 },
        { name = 'luasnip', max_item_count = 20, priority = 10 },
        { name = 'buffer', max_item_count = 10, priority = 3 },
        { name = 'path', max_item_count = 10, priority = 3 },
    }
}

-- lsp
local lsps = {
    'bashls',
    'docker_compose_language_service',
    'dockerls',
    'gopls',
    'lua_ls',
    'nil_ls',
    'neocmake',
    'pyright',
    'rust_analyzer',
}
require('mason-lspconfig').setup {
    ensure_installed = lsps,
}
local nvim_lsp = require('lspconfig')
local client_capabilities = require('cmp_nvim_lsp').default_capabilities()
require('mason-lspconfig').setup_handlers {
    function(server)
        nvim_lsp[server].setup {
            capabilities = client_capabilities
        }
    end
}

-- clangd is not installed with mason, so config is here
nvim_lsp.clangd.setup {
    cmd = {
        'clangd',
        '--header-insertion=never',
        '--all-scopes-completion',
        '--background-index',
        '--clang-tidy',
        '--query-driver=/**/*',
    },
    capabilities = client_capabilities
}

m.keys {
    { 'n', 'gd', vim.lsp.buf.definition },
    { 'n', '<leader>rs', vim.lsp.buf.signature_help },
    { 'n', '<leader>rr', vim.lsp.buf.references },
    { 'n', '<leader>ro', vim.lsp.buf.rename },
    { 'n', '<leader>rh', vim.lsp.buf.hover, { buffer = 0, noremap = true, silent = true }},
    { 'n', '<leader>re', vim.lsp.buf.code_action },
    { 'n', '<leader>rn', vim.diagnostic.goto_next },
    { 'n', '<leader>rp', vim.diagnostic.goto_prev },
    { 'n', '<leader>rd', vim.diagnostic.setqflist },
    { {'n', 'v'}, '<leader>rf', function() vim.lsp.buf.format { async = true } end },
}

