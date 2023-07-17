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
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = {text = '│'},
                change = {text = '│'},
                delete = {text = '_'},
                topdelete = {text = '‾'},
                changedelete = {text = '~'},
                untracked = {text = '┆'}
            },
            signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
            numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
            linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
            word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
            watch_gitdir = {follow_files = true},
            attach_to_untracked = true,
            current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                delay = 100,
                ignore_whitespace = false
            },
            current_line_blame_formatter = 'Commit info: <author>, <author_time:%Y-%m-%d> - <summary>',
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil, -- Use default
            max_file_length = 40000, -- Disable if file is longer than this (in lines)
            preview_config = {
                -- Options passed to nvim_open_win
                border = 'single',
                style = 'minimal',
                relative = 'cursor',
                row = 0,
                col = 1
            },
            yadm = {enable = false}
        }
    }, {
        "nvim-neo-tree/neo-tree.nvim",
        opts = {
            auto_clean_after_session_restore = true,
            close_if_last_window = true,
            source_selector = {
                winbar = true,
                content_layout = "center",
                sources = {
                    {
                        source = "filesystem",
                        display_name = require("astronvim.utils").get_icon "FolderClosed" ..
                            " File"
                    }, {
                        source = "buffers",
                        display_name = require("astronvim.utils").get_icon "DefaultFile" ..
                            " Bufs"
                    }, {
                        source = "git_status",
                        display_name = require("astronvim.utils").get_icon "Git" ..
                            " Git"
                    }, {
                        source = "diagnostics",
                        display_name = require("astronvim.utils").get_icon "Diagnostic" ..
                            " Diagnostic"
                    }
                }
            },
            default_component_configs = {
                indent = {padding = 0, indent_size = 3},
                icon = {
                    folder_closed = require("astronvim.utils").get_icon "FolderClosed",
                    folder_open = require("astronvim.utils").get_icon "FolderOpen",
                    folder_empty = require("astronvim.utils").get_icon "FolderEmpty",
                    default = require("astronvim.utils").get_icon "DefaultFile"
                },
                modified = {
                    symbol = require("astronvim.utils").get_icon "FileModified"
                },
                git_status = {
                    symbols = {
                        added = require("astronvim.utils").get_icon "GitAdd",
                        deleted = require("astronvim.utils").get_icon "GitDelete",
                        modified = require("astronvim.utils").get_icon "GitChange",
                        renamed = require("astronvim.utils").get_icon "GitRenamed",
                        untracked = require("astronvim.utils").get_icon "GitUntracked",
                        ignored = require("astronvim.utils").get_icon "GitIgnored",
                        unstaged = require("astronvim.utils").get_icon "GitUnstaged",
                        staged = require("astronvim.utils").get_icon "GitStaged",
                        conflict = require("astronvim.utils").get_icon "GitConflict"
                    }
                }
            },
            commands = {
                system_open = function(state)
                    require("astronvim.utils").system_open(
                        state.tree:get_node():get_id())
                end,
                parent_or_close = function(state)
                    local node = state.tree:get_node()
                    if (node.type == "directory" or node:has_children()) and
                        node:is_expanded() then
                        state.commands.toggle_node(state)
                    else
                        require("neo-tree.ui.renderer").focus_node(state,
                                                                   node:get_parent_id())
                    end
                end,
                child_or_open = function(state)
                    local node = state.tree:get_node()
                    if node.type == "directory" or node:has_children() then
                        if not node:is_expanded() then -- if unexpanded, expand
                            state.commands.toggle_node(state)
                        else -- if expanded and has children, seleect the next child
                            require("neo-tree.ui.renderer").focus_node(state,
                                                                       node:get_child_ids()[1])
                        end
                    else -- if not a directory just open it
                        state.commands.open(state)
                    end
                end,
                copy_selector = function(state)
                    local node = state.tree:get_node()
                    local filepath = node:get_id()
                    local filename = node.name
                    local modify = vim.fn.fnamemodify

                    local results = {
                        e = {
                            val = modify(filename, ":e"),
                            msg = "Extension only"
                        },
                        f = {val = filename, msg = "Filename"},
                        F = {
                            val = modify(filename, ":r"),
                            msg = "Filename w/o extension"
                        },
                        h = {
                            val = modify(filepath, ":~"),
                            msg = "Path relative to Home"
                        },
                        p = {
                            val = modify(filepath, ":."),
                            msg = "Path relative to CWD"
                        },
                        P = {val = filepath, msg = "Absolute path"}
                    }

                    local messages = {
                        {"\nChoose to copy to clipboard:\n", "Normal"}
                    }
                    for i, result in pairs(results) do
                        if result.val and result.val ~= "" then
                            vim.list_extend(messages, {
                                {("%s."):format(i), "Identifier"},
                                {(" %s: "):format(result.msg)},
                                {result.val, "String"}, {"\n"}
                            })
                        end
                    end
                    vim.api.nvim_echo(messages, false, {})
                    local result = results[vim.fn.getcharstr()]
                    if result and result.val and result.val ~= "" then
                        vim.notify("Copied: " .. result.val)
                        vim.fn.setreg("+", result.val)
                    end
                end
            },
            window = {
                position = "right",
                width = 60,
                mappings = {
                    ["<space>"] = false, -- disable space until we figure out which-key disabling
                    ["[b"] = "prev_source",
                    ["]b"] = "next_source",
                    o = "open",
                    O = "system_open",
                    h = "parent_or_close",
                    l = "child_or_open",
                    Y = "copy_selector"
                }
            },
            filesystem = {
                follow_current_file = true,
                filtered_items = {
                    never_show = {".git", ".DS_Store"},
                    visible = false,
                    hide_dotfiles = false,
                    always_show = {
                        ".gitignore", ".env", ".env.*", ".toggletasks"
                    }
                },
                hijack_netrw_behavior = "open_current",
                use_libuv_file_watcher = true
            },
            event_handlers = {
                {
                    event = "neo_tree_buffer_enter",
                    handler = function(_)
                        vim.opt_local.signcolumn = "auto"
                    end
                }
            }
        }
    }, {
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
    }, {
        "goolord/alpha-nvim",
        opts = function(_, opts)
            opts.section.header.val = {
                [[                                                                       ]],
                [[                                                                     ]],
                [[       ████ ██████           █████      ██                     ]],
                [[      ███████████             █████                             ]],
                [[      █████████ ███████████████████ ███   ███████████   ]],
                [[     █████████  ███    █████████████ █████ ██████████████   ]],
                [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
                [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
                [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
                [[                                                                       ]]
            }
            -- opts.section.footer.val = {
            --
            -- }
        end
    }

}
