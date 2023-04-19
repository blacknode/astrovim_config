return {
    -- You can also add new plugins here as well:
    -- Add plugins, the lazy syntax
    -- "andweeb/presence.nvim",
    -- {
    --   "ray-x/lsp_signature.nvim",
    --   event = "BufRead",
    --   config = function()
    --     require("lsp_signature").setup()
    --   end,
    -- },
    {
        "folke/todo-comments.nvim",
        dependencies = {"nvim-lua/plenary.nvim"},
        -- config = function() require("todo-comments").setup {} end,
        event = "User AstroFile",
        -- lazy = false
        opts = {}
    }, {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/neotest-go", "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter", "antoinemadec/FixCursorHold.nvim"
        },
        config = function()
            local neotest_ns = vim.api.nvim_create_namespace "neotest"
            vim.diagnostic.config({
                virtual_text = {
                    format = function(diagnostic)
                        local message = diagnostic.message:gsub("\n", " "):gsub(
                                            "\t", " "):gsub("%s+", " ")
                                            :gsub("^%s+", "")
                        return message
                    end
                }
            }, neotest_ns)
            require("neotest").setup {adapters = {require "neotest-go"}}
        end,
        opts = {},
        lazy = false,
        event = "User AstroFile"
    }, {
        "olexsmir/gopher.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter"
        },
        event = "User AstroFile"
    }, {
        "tanvirtin/monokai.nvim",
        lazy = false,
        opts = {},
        config = function()
            require("monokai").setup {palette = require("monokai").pro}
        end
    }, {
        "jedrzejboczar/toggletasks.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim", "akinsho/toggleterm.nvim",
            "nvim-telescope/telescope.nvim"
        },
        opts = {},
        event = "User AstroFile",
        lazy = false,
        config = function()
            require("toggletasks").setup {
                debug = false,
                silent = false, -- don't show "info" messages
                short_paths = true, -- display relative paths when possible
                -- Paths (without extension) to task configuration files (relative to scanned directory)
                -- All supported extensions will be tested, e.g. '.toggletasks.json', '.toggletasks.yaml'
                search_paths = {
                    "toggletasks", ".toggletasks", ".nvim/toggletasks"
                },
                -- Directories to consider when searching for available tasks for current window
                scan = {
                    global_cwd = true, -- vim.fn.getcwd(-1, -1)
                    tab_cwd = true, -- vim.fn.getcwd(-1, tab)
                    win_cwd = true, -- vim.fn.getcwd(win)
                    lsp_root = true, -- root_dir for first LSP available for the buffer
                    dirs = {}, -- explicit list of directories to search or function(win): dirs
                    rtp = false, -- scan directories in &runtimepath
                    rtp_ftplugin = false -- scan in &rtp by filetype, e.g. ftplugin/c/toggletasks.json
                },
                tasks = {}, -- list of global tasks or function(win): tasks
                -- this is basically the "Config format" defined using Lua tables
                -- Language server priorities when selecting lsp_root (default is 0)
                lsp_priorities = {["null-ls"] = -10},
                -- Defaults used when opening task's terminal (see Terminal:new() in toggleterm/terminal.lua)
                toggleterm = {close_on_exit = false, hidden = true},
                -- Configuration of telescope pickers
                telescope = {
                    spawn = {
                        open_single = true, -- auto-open terminal window when spawning a single task
                        show_running = false, -- include already running tasks in picker candidates
                        -- Replaces default select_* actions to spawn task (and change toggleterm
                        -- direction for select horiz/vert/tab)
                        mappings = {
                            select_float = "<C-f>",
                            spawn_smart = "<C-a>", -- all if no entries selected, else use multi-select
                            spawn_all = "<M-a>", -- all visible entries
                            spawn_selected = nil -- entries selected via multi-select (default <tab>)
                        }
                    },
                    -- Replaces default select_* actions to open task terminal (and change toggleterm
                    -- direction for select horiz/vert/tab)
                    select = {
                        mappings = {
                            select_float = "<C-f>",
                            open_smart = "<C-a>",
                            open_all = "<M-a>",
                            open_selected = nil,
                            kill_smart = "<C-q>",
                            kill_all = "<M-q>",
                            kill_selected = nil,
                            respawn_smart = "<C-s>",
                            respawn_all = "<M-s>",
                            respawn_selected = nil
                        }
                    }
                }
            }
            require("telescope").load_extension "toggletasks"
        end
    }
}
