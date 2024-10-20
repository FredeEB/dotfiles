local m = require('functions.keymap')
local ai = require('constants.ai')

-- cmp
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-j>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<C-k>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.expand_or_jumpable(-1) then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<C-x>'] = cmp.mapping(
            cmp.mapping.complete({
                config = {
                    sources = cmp.config.sources({
                        { name = 'cmp_ai' },
                    }),
                },
            }),
            { 'i' }
        ),
    }),
    sources = {
        { name = 'nvim_lsp_signature_help' },
        { name = 'nvim_lsp', max_item_count = 20, priority = 10 },
        { name = 'luasnip', max_item_count = 20, priority = 10 },
        { name = 'buffer', max_item_count = 10, priority = 3 },
        { name = 'path', max_item_count = 10, priority = 3 },
    },
})

-- lsp
local lsps = {
    'bashls',
    'bitbake_language_server',
    'docker_compose_language_service',
    'dockerls',
    'gopls',
    'lua_ls',
    'nixd',
    'neocmake',
    'terraformls',
    'ts_ls',
    'pylyzer',
    'rust_analyzer',
    'verible',
    'zls',
}

local client_capabilities = require('cmp_nvim_lsp').default_capabilities()
local nvim_lsp = require('lspconfig')
for _, server in ipairs(lsps) do
    nvim_lsp[server].setup({
        function(server)
            nvim_lsp[server].setup({
                capabilities = client_capabilities,
            })
        end,
    })
end

nvim_lsp.clangd.setup({
    cmd = {
        'clangd',
        '--header-insertion=never',
        '--all-scopes-completion',
        '--background-index',
        '--clang-tidy',
        '--query-driver=/**/*',
    },
    capabilities = client_capabilities,
})

local cmp_ai = require('cmp_ai.config')

cmp_ai:setup({
    max_lines = 100,
    provider = 'Ollama',
    provider_options = {
        model = ai.code_model,
        base_url = 'http://dt:11434/api/generate',
        prompt = function(lines_before)
            return lines_before
        end,
        suffix = function(lines_after)
            return lines_after
        end,
    },
    notify = true,
    notify_callback = function(msg)
        vim.notify(msg)
    end,
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        m.keys({
            { 'n', 'gD', vim.lsp.buf.declaration },
            { 'n', 'gd', vim.lsp.buf.definition },
            { { 'n', 'i' }, '<C-s>', vim.lsp.buf.signature_help },
            { { 'n', 'i' }, '<C-t>', vim.lsp.buf.hover, { buffer = 0, noremap = true, silent = true } },
            { 'n', '<leader>rr', vim.lsp.buf.references },
            { 'n', '<leader>ro', vim.lsp.buf.rename },
            { 'n', '<leader>re', vim.lsp.buf.code_action },
            { 'n', '<leader>rn', vim.diagnostic.goto_next },
            { 'n', '<leader>rp', vim.diagnostic.goto_prev },
            { 'n', '<leader>rd', vim.diagnostic.setqflist },
            {
                { 'n', 'v' },
                '<leader>rf',
                function()
                    vim.lsp.buf.format({ async = true })
                end,
            },
        })
    end,
})

require('luasnip.loaders.from_vscode').lazy_load()
