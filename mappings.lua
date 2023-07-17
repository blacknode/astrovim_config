-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
    -- first key is the mode
    n = {
        -- second key is the lefthand side of the map
        -- mappings seen under group name "Buffer"
        ["<leader>bn"] = {"<cmd>tabnew<cr>", desc = "New tab"},
        ["<leader>bD"] = {
            function()
                require("astronvim.utils.status").heirline.buffer_picker(
                    function(bufnr)
                        require("astronvim.utils.buffer").close(bufnr)
                    end)
            end,
            desc = "Pick to close"
        },
        -- tables with the `name` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        ["<leader>b"] = {name = "Buffers"},
        ["<A-j>"] = {"<cmd>m .+1<cr>=="},
        ["<A-k>"] = {"<cmd>m .-2<cr>=="},
        ["<leader>c"] = {
            function()
                local bufs = vim.fn.getbufinfo {buflisted = true}
                require("astronvim.utils.buffer").close(0)
                if require("astronvim.utils").is_available "alpha-nvim" and
                    not bufs[2] then require("alpha").start(true) end
            end,
            desc = "Close buffer"
        }

        -- quick save
        -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
    },
    t = {
        -- setting a mapping to false will disable it
        -- ["<esc>"] = false,
    },
    v = {
        ["<A-j>"] = {"<cmd>m '>+1<cr>gv=gv"},
        ["<A-k>"] = {"<cmd>m '<-2<cr>gv=gv"}
    },
    i = {["<A-j>"] = {"<Esc>m .+1<cr>==gi"}, ["<A-k>"] = {"<Esc>m .-2<cr>==gi"}}
}
