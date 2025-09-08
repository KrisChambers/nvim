---
--- Fuzzy Finding via Telescope
---
return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },

    config = function()
        local themes = require("telescope.themes")

        local wide_opts = {
            layout_config = {
                width  = function (x, max_columns, max_lines)
                    return math.floor( max_columns* 0.8 ) -- Generally we want our picker to be pretty wide on the screen
                end
            }
        }

        -- Centered drop down ui
        local function with_dropdown(picker)
            local dd = themes.get_dropdown({
                layout_config = {
                    width = function (_, max_columns, max_lines)
                        return math.floor(max_columns * 0.7)
                    end,
                    height = function (_, _, max_lines)
                        return math.floor(max_lines * 0.7)
                    end
                }
            })

            local function wrapper()
                picker(dd)
            end

            return wrapper
        end

        -- Cursor relative telescope ui
        local function with_cursor(picker)
            local theme = themes.get_cursor({
                layout_config = {
                    width = function (x, max_columns, max_lines)
                        return math.floor(max_columns * 0.6)
                    end,
                    height = function (x, max_columns, max_lines)
                        return math.min(max_lines, 30)
                    end
                }
            })

            local function wrapper()
                picker(theme)
            end

            return wrapper
        end

        -- Bottom panel UI
        local function with_ivy(picker)
            local theme = themes.get_cursor({
            })

            local function wrapper()
                picker(theme)
            end

            return wrapper
        end

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Open telescope fuzzy finder for files reachable from the root directory" })
        vim.keymap.set('n', '<leader>fg', with_dropdown(builtin.live_grep), { desc = "Open telescope fuzzy finder for git managed files" })
        vim.keymap.set('n', '<leader>fb', with_dropdown(builtin.buffers), { desc = "Open telescope fuzzy finder for buffers" })
        vim.keymap.set('n', '<leader>fh', with_dropdown(builtin.help_tags), { desc = "Open telescope fuzzy finder for help_tags" })
        vim.keymap.set('n', '<leader>fd', with_dropdown(builtin.diagnostics), { desc = "Open telescope fuzzy finder for diagnostics" })
        vim.keymap.set('n', '<leader>fm', with_dropdown(builtin.keymaps), { desc = "Open telescope fuzzy finder for keymaps" })
    end
}
