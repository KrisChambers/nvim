require("me.set")
require("me.remaps")
require("me.lazy_init")

local augroup = vim.api.nvim_create_augroup
local me = augroup('me', {})

-- load the snippet folder
require('luasnip.loaders.from_snipmate').load({ paths = { "./snippets" } })

local create_autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

local create_cmd = vim.api.nvim_create_user_command

function R(name)
    require("plenary.reload").reload_module(name)
end

-- Makes it so yanking shows what is being yanked with a flash of the selection.
create_autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 100,
        })
    end,
})

-- Before saving we get rid of any lines with empty lines
create_autocmd({ "BufWritePre" }, {
    group = me,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

--
-- python Bar setup?
--
--create_autocmd({"BufWinEnter"}, {
--    group = me,
--    pattern = {"*.py"},
--    callback = function ()
--        vim.cmd([[vs]])
--        vim.cmd([[wincmd l]])
--        vim.cmd([[vertical resize 100]])
--        vim.cmd([[set winfixwidth]])
--        vim.cmd([[wincmd h]])
--        vim.cmd([[sv +term]])
--        vim.cmd([[wincmd j]])
--        vim.cmd([[horizontal resize 25]])
--        vim.cmd([[set winfixheight]])
--        vim.cmd([[wincmd k]])
--    end
--})



--
-- TOFU / TERRAFORM Specific
--

create_autocmd({ "BufWritePre" }, {
    desc = "Format tofu / terraform files on save",
    group = me,
    pattern = { "*.test" }, -- TODO (kc): Test this out on other things

    callback = function(e)
        -- We want to run the terraform fmt before we save
        -- TODO (kc): This should be similar to the format on save for python files
        local filename = vim.api.nvim_buf_get_name(0)
        -- vim.cmd(":silent !tofu fmt " .. filename)
    end
})


--
-- PYTHON specific
--

-- Note (kc): On save of python files we want to format the file with black.
create_autocmd('BufWritePost', { -- TODO (kc): Should the be Pre write and not Post write?
    desc = "Format python files with black",
    pattern = { "*.py" },
    group = me,

    callback = function()
        local filename = vim.api.nvim_buf_get_name(0)
        vim.cmd(":silent !black " .. filename)
    end
})
create_autocmd('LspAttach', {
    group = me,
    pattern = { "*.hs" },
    callback = function (e)
            local ht = require('haskell-tools')
            local opts = { noremap = true, silent = true, buffer = e.buf, }
            -- haskell-language-server relies heavily on codeLenses,
            -- so auto-refresh (see advanced configuration) is enabled by default
            vim.keymap.set('n', '<space>cl', vim.lsp.codelens.run, opts)
            -- Hoogle search for the type signature of the definition under the cursor
            vim.keymap.set('n', '<space>hs', ht.hoogle.hoogle_signature, opts)
            -- Evaluate all code snippets
            vim.keymap.set('n', '<space>ea', ht.lsp.buf_eval_all, opts)
            -- Toggle a GHCi repl for the current package
            vim.keymap.set('n', '<leader>rr', ht.repl.toggle, opts)
            -- Toggle a GHCi repl for the current buffer
            vim.keymap.set('n', '<leader>rf', function()
              ht.repl.toggle(vim.api.nvim_buf_get_name(0))
            end, opts)
            vim.keymap.set('n', '<leader>rq', ht.repl.quit, opts)
    end

})

--create_cmd("PyErrorPane", function()
--    local x = [[
--export FORCE_COLOR=3;
--while [ true ];
--do
--    sleep 1;
--    output=$(pyright);
--    clear;
--    echo \"$output\";
--done
--]]
--
--    local y = table.concat(vim.split(x, "\n", {}), " ")
--
--    print(y)
--    vim.cmd([[vs]])
--    vim.cmd([[wincmd l]])
--    local cmd = string.format("bash -c '%s'", y)
--    print(cmd)
--    vim.cmd(cmd)
--    vim.cmd([[vertical resize 100]])
--    vim.cmd([[set winfixwidth]])
--    vim.cmd([[wincmd h]])
--
--    --vim.cmd([[sv +term]])
--    --vim.cmd([[wincmd j]])
--    --vim.cmd([[horizontal resize 25]])
--    --vim.cmd([[set winfixheight]])
--    --vim.cmd([[wincmd k]])
--end, {})
--
--
-- GENERIC LSP SPECIFIC
--
create_autocmd('LspAttach', {
    group = me,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts) -- TODO (kc): Can we set a mark so we can go back to the last file here?
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    end
})

--create_autocmd('BufEnter', {
--    group = me,
--
--    callback = function ()
--
--    end
--})

create_autocmd('BufEnter', {
    group = me,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("v", "<leader>be", function()
            vim.api.nvim_cmd({
                cmd = [["ty]]
            }, {})
        end, opts)
    end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.opt.laststatus = 3

local function print_plugins()
    local plugins = require("lazy").plugins()
    for _, plugin in pairs(plugins) do
        if plugin.url ~= nil then
            print(plugin.url .. "\n")
        end
    end
end
--print_plugins()  -- Comment or uncomment to toggle the output

