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
    'nixd',
    'neocmake',
    'terraformls',
    'tsserver',
    'pyright',
    'rust_analyzer',
}

local nvim_lsp = require('lspconfig')
local client_capabilities = require('cmp_nvim_lsp').default_capabilities()
for _, server in ipairs(lsps) do

    nvim_lsp[server].setup {
        function(server)
            nvim_lsp[server].setup {
                capabilities = client_capabilities
            }
        end
    }
end

nvim_lsp.lua_ls.setup {
    cmd = {'lua-lsp'},
    on_init = function(client)
        local path = client.workspace_folders[1].name
            if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
                client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT'
                        },
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME
                            }
                        }
                    }
                })

                client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
            end
        return true
    end,
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

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        m.keys {
            { 'n', 'gD', vim.lsp.buf.declaration },
            { 'n', 'gd', vim.lsp.buf.definition },
            { {'n', 'i'}, '<C-s>', vim.lsp.buf.signature_help },
            { {'n', 'i'}, '<C-t>', vim.lsp.buf.hover, { buffer = 0, noremap = true, silent = true }},
            { 'n', '<leader>rr', vim.lsp.buf.references },
            { 'n', '<leader>ro', vim.lsp.buf.rename },
            { 'n', '<leader>re', vim.lsp.buf.code_action },
            { 'n', '<leader>rn', vim.diagnostic.goto_next },
            { 'n', '<leader>rp', vim.diagnostic.goto_prev },
            { 'n', '<leader>rd', vim.diagnostic.setqflist },
            { {'n', 'v'}, '<leader>rf', function() vim.lsp.buf.format { async = true } end },
        }
    end,
})



