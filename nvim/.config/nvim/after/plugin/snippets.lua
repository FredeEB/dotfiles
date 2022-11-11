-- snippets
local m = require('functions.keymap')
local ls = require('luasnip')
require('luasnip.loaders.from_snipmate').lazy_load()
m.keys({
    { { 'i', 's' }, "<C-j>", function() if ls.expand_or_jumpable() then ls.expand_or_jump() end end },
    { { 'i', 's' }, "<C-k>", function() if ls.expand_or_jumpable(-1) then ls.expand_or_jump(-1) end end },
    { { 'i', 's' }, "<C-l>", function() if ls.choice_active() then ls.change_choice(1) end end }
},
    { silent = true }
)

-- snippets
local function snippets()
    local s = ls.snippet
    local n = ls.snippet_node
    local t = ls.text_node
    local i = ls.insert_node
    local f = ls.function_node
    local c = ls.choice_node
    local d = ls.dynamic_node

    snip({ "once", {
        text({ "#ifndef " }),
        func
    } })
    s('once', {
        t('#ifndef '),
        d(1, l.TM_FILENAME:upper(), {}),
        t({ '', '#define ' }),
        f(function(args) return args[1][1] end, { 1 }),
        t({ '', '', '' }),
        i(0),
        t({ '', '', '#endif // end of include guard: ' }),
        f(function(args) return args[1][1] end, { 1 }),
    })
    -- markdown
    local function date()
        return os.date('+%Y-%m-%d %H:%M:%S %z')
    end

    local function get_jekyll_layouts()
        local git_root_p = io.popen("git rev-parse --show-toplevel")
        if git_root_p == nil then
            -- bail
            return { "none" }
        end

        local layout_dir = git_root_p:read("l") .. "/_layouts"

        local layout_p = io.popen('ls ' .. layout_dir .. '/*.html')

        local layouts = {}
        local i = 1
        for layout in layout_p:lines() do
            layouts[i] = string.gsub(layout, "(.*)\\..*", "%1")
            i = i + 1
        end

        if layout_p ~= nil then
            layout_p:close()
        end

        return layouts
    end

    snip({ "meta", {
        text({ "---",
            "layout: post",
            "title: " }), insert(2, "title"), text({ "",
            "date: " }), func(date, {}), text({ "",
            "categories: " }), insert(3, ""), text({ "",
            "---", "", "# " }),
        insert(0)
    } })
end
