{ pkgs, lib, ... }:
{
  config = {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      extraConfig = ''
        "use ctlr+g as leader key
        let mapleader = "\<C-g>"

        set timeoutlen=1000
        set ttimeoutlen=50

        "Use space instead of tab
        set expandtab

        filetype plugin on

        set noswapfile
        set number relativenumber
        set nu rnu

        "highlight currentline
        set cursorline

        " Use ctrl+[hjkl] to select the active split
        nmap <silent> <c-k> :wincmd k<CR>
        nmap <silent> <c-j> :wincmd j<CR>
        nmap <silent> <c-h> :wincmd h<CR>
        nmap <silent> <c-l> :wincmd l<CR>

        " use ctrl+\ to vertically split
        nmap <silent> <c-\> :vsplit<CR>

        "ctrl+n to search for files
        nmap <unique> <C-N> :Files<CR>

        " toggleterm needs this
        set hidden

        set scrolloff=5
      '';

      plugins = with pkgs.vimPlugins; [
        nvim-surround
        vim-sleuth
        nvim-web-devicons
        vim-devicons
        vim-codefmt
        vim-nix
        vim-eunuch
        statix
        nerdtree
        diffview-nvim
        vim-fugitive

        {
          plugin = bufferline-nvim;
          type = "lua";
          config = ''
            vim.opt.termguicolors = true
            require("bufferline").setup{
              options = {
                color_icons = true;
                show_close_icon = true;
              }
            }
          '';
        }

        {
          plugin = flash-nvim;
          type = "lua";
          config = ''
            vim.keymap.set('n', 's', function() require("flash").jump() end, {
                desc = "Flash search"
            })
          '';
        }

        {
          plugin = undotree;
          type = "lua";
          config = ''
            vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle<CR>', {
                desc = "Toggle undo tree"
            })
          '';
        }

        {
          plugin = rainbow-delimiters-nvim;
          config = ''
            let g:rainbow_delimiters = {
                \ 'highlight': [
                    \ 'RainbowDelimiterYellow',
                    \ 'RainbowDelimiterBlue',
                    \ 'RainbowDelimiterOrange',
                    \ 'RainbowDelimiterGreen',
                    \ 'RainbowDelimiterViolet',
                    \ 'RainbowDelimiterCyan',
                \ ],
            \ }
          '';
        }

        {
          plugin = which-key-nvim;
          type = "lua";
          config = ''
            local wk = require("which-key")
            wk.register({})
          '';
        }

        {
          plugin = lualine-nvim;
          type = "lua";
          config = ''
            require('lualine').setup{}
          '';
        }

        {
          plugin = todo-comments-nvim;
          type = "lua";
          config = ''
            require("todo-comments").setup{}
          '';
        }

        {
          plugin = trouble-nvim;
          type = "lua";
          config = ''
            -- use gt to open diagnostics list
            vim.keymap.set('n', 'gt', '<cmd>TroubleToggle workspace_diagnostics<CR>', {
                desc = "Open diagnostics list"
            })
            -- use gq to open quickfix list
            vim.keymap.set('n', 'gq', '<cmd>TroubleToggle quickfix<CR>', {
                desc = "Open quickfix list"
            })

            -- use gr to open references of current symbol
            vim.keymap.set('n', 'gr', '<cmd>TroubleToggle lsp_references<CR>', {
                desc = "Open lsp references list"
            })
          '';
        }

        {
          plugin = vim-visual-multi;
          config = ''
            "use ctrl+d for multi-cursor instead of ctrl-n since that's used
            "by the file browser
            let g:VM_maps = {}
            let g:VM_maps['Find Under']         = '<C-d>'   " replace C-n
            let g:VM_maps['Find Subword Under'] = '<C-d>'   " replace visual C-n
          '';
        }

        {
          plugin = mini-nvim;
          type = "lua";
          config = ''
            require('mini.cursorword').setup()
            require('mini.pairs').setup()
            require('mini.trailspace').setup()
          '';
        }

        {
          plugin = lazygit-nvim;
          config = ''
            "ctrl+alt+g to open lazygit interface
            nnoremap <C-M-g> :LazyGit<CR>
          '';
        }

        {
          plugin = oil-nvim;
          type = "lua";
          config = ''
            -- alt+f1 for filesystems browser
            vim.keymap.set('n', '<F49>', '<cmd>execute ":Oil " . $PWD<CR>', {
                desc = "Open filebrowser"
            })
            require("oil").setup({
              columns = {
                "icon",
                "permissions",
                "size",
                "mtime",
              },

              use_default_keymaps = false,
              keymaps = {
                ["g?"] = "actions.show_help",
                ["<CR>"] = "actions.select",
                ["<C-s>"] = "actions.select_vsplit",
                ["<C-t>"] = "actions.select_tab",
                ["<C-p>"] = "actions.preview",
                ["<C-l>"] = "actions.refresh",
                ["-"] = "actions.parent",
                ["_"] = "actions.open_cwd",
                ["`"] = "actions.cd",
                ["~"] = "actions.tcd",
                ["gs"] = "actions.change_sort",
                ["g."] = "actions.toggle_hidden",
              },

              view_options = {
                -- show all hidden files except for .git
                is_hidden_file = function(name, bufnr)
                  return vim.startswith(name, ".git")
                end,
              }
            })
          '';
        }

        {
          plugin = nvim-treesitter.withPlugins (p: [
            p.c
            p.cpp
            p.haskell
            p.bash
            p.json
            p.devicetree
            p.make
            p.python
            p.nix
            p.rust
          ]);
          type = "lua";
          config = ''
            require'nvim-treesitter.configs'.setup {
              -- A list of parser names, or "all" (the five listed parsers should always be installed)
              ensure_installed = { },

              -- Install parsers synchronously (only applied to `ensure_installed`)
              sync_install = false,

              -- Automatically install missing parsers when entering buffer
              -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
              auto_install = false,

              -- List of parsers to ignore installing (for "all")
              ignore_install = { "all" },

              highlight = {
                enable = true,

                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = false,
              },
            }
          '';
        }
        {
          plugin = fzf-vim;
          config = ''
            let $FZF_DEFAULT_COMMAND = 'rg --files'
          '';
        }
        {
          plugin = gruvbox-nvim;
          config = ''
            colorscheme gruvbox
          '';
        }
        {
          plugin = nerdcommenter;
          config = ''
            "ctrl + / for commenting
            nmap <C-_>   <Plug>NERDCommenterToggle
            vmap <C-_>   <Plug>NERDCommenterToggle<CR>gv

            let g:NERDCreateDefaultMappings = 0
          '';
        }

        {
          plugin = gitsigns-nvim;
          type = "lua";
          config = ''
            require('gitsigns').setup({
              current_line_blame = true,
              numhl = true,
            })
          '';
        }

        {
          plugin = nvim-lint;
          type = "lua";
          config = ''
            -- filetype list is at https://github.com/vim/vim/blob/master/runtime/filetype.vim
            require('lint').linters_by_ft = {
              bash = {'shellcheck'},
              haskell = {'hlint'},
              lhaskell = {'hlint'},
              python = {'pylint'},
            }
            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
              callback = function()
                require("lint").try_lint()
              end,
            })
          '';
        }

        {
          plugin = toggleterm-nvim;
          type = "lua";
          config = ''
            -- ctrl+g t to toggle terminal
            require("toggleterm").setup({
               open_mapping = [[<leader>t]],
            })

            -- to open a new terminal we have to do 2ToggleTerm to open the 2nd one, 3ToggleTerm to open 3rd one, etc
            -- alt+arrow to navigate between splits
            -- ctrl+h to open 2nd horizontal terminal
            function _G.set_terminal_keymaps()
              local opts = {buffer = 0}
              vim.keymap.set('t', '<M-left>', [[<Cmd>wincmd h<CR>]], opts)
              vim.keymap.set('t', '<M-right>', [[<Cmd>wincmd l<CR>]], opts)
              vim.keymap.set('t', '<M-up>', [[<Cmd>wincmd k<CR>]], opts)
              vim.keymap.set('t', '<M-down>', [[<Cmd>wincmd j<CR>]], opts)
              vim.keymap.set('t', '<C-h>', [[<Cmd>2ToggleTerm<CR>]], opts)
              vim.keymap.set('t', '<leader>t', [[<C-\><C-n><C-w>]], opts)
            end

            vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
          '';
        }

        {
          plugin = nvim-spectre;
          type = "lua";
          config = ''
            require('spectre').setup({
              is_insert_mode = false,
              live_update = true,
            })

            -- ctrl+u to search current word across all files
            vim.keymap.set('n', '<C-u>', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
                desc = "Toggle Spectre"
            })
            vim.keymap.set('v', '<C-u>', '<cmd>lua require("spectre").open_visual({})<CR>', {
                desc = "Toggle Spectre"
            })
          '';
        }
        {
          plugin = nvim-lspconfig;
          type = "lua";
          config = ''

            -- Global mappings.
            -- See `:help vim.diagnostic.*` for documentation on any of the below functions
            vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
            vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

            -- Use LspAttach autocommand to only map the following keys
            -- after the language server attaches to the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
              group = vim.api.nvim_create_augroup('UserLspConfig', {}),
              callback = function(ev)
                -- Enable completion triggered by <c-x><c-o>
                vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                mkOpts = function(desc)
                  local opts = { buffer = ev.buf, desc = desc }
                  return opts
                end

                -- gd goes to defintion
                -- K to show hover
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, mkOpts("Go to declaration"))
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, mkOpts("Go to definition"))
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, mkOpts("Trigger hover"))
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, mkOpts("Go to implementation"))
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, mkOpts("Show references"))

                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, mkOpts(""))

                vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, mkOpts(""))
                vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, mkOpts(""))
                vim.keymap.set('n', '<space>wl', function()
                  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                  end, mkOpts(""))
                vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, mkOpts("Show type definition"))
                vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, mkOpts("Rename"))

                vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, mkOpts("Code action"))
                vim.keymap.set('n', '<space>f', function()
                  vim.lsp.buf.format { async = true }
                  end, mkOpts(""))
              end,
            })
          '';
        }

        {
          plugin = twilight-nvim;
          config = ''
            autocmd VimEnter * TwilightEnable
            lua << EOF
                require("twilight").setup {
                    context = 40,
                }
            EOF
          '';
        }

        cmp-buffer
        cmp-nvim-lsp
        cmp-path
        cmp-cmdline
        cmp-vsnip
        haskell-tools-nvim
        vim-vsnip
        vim-cool
        nvim-navic

        {
          plugin = indent-blankline-nvim;
          type = "lua";
          config = ''
            require("ibl").setup()
          '';
        }

        {
          plugin = nvim-cmp;
          type = "lua";
          config = ''
            -- Set up nvim-cmp.
            local cmp = require'cmp'

            cmp.setup({
              snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function(args)
                  vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                end,
              },
              window = {
                -- completion = cmp.config.window.bordered(),
                -- documentation = cmp.config.window.bordered(),
              },
              mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<tab>'] = cmp.mapping.confirm({ select = true }),
                ['<M-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                ['<M-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
              }),
              sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'vsnip' }, -- For vsnip users.
              }, {
                { name = 'buffer' },
              })
            })

            -- Set configuration for specific filetype.
            cmp.setup.filetype('gitcommit', {
              sources = cmp.config.sources({
                { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
              }, {
                { name = 'buffer' },
              })
            })

            cmp.setup.cmdline({ '/', '?' }, {
              mapping = cmp.mapping.preset.cmdline(),
              sources = {
                { name = 'buffer' }
              }
            })

            cmp.setup.cmdline(':', {
              mapping = cmp.mapping.preset.cmdline(),
              sources = cmp.config.sources({
                { name = 'path' }
              }, {
                { name = 'cmdline' }
              })
            })

            -- Set up lspconfig.
            -- docs here: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true
            }
            local lspconfig = require('lspconfig')
            local on_attach = function(client, bufnr)
              if client.server_capabilities.documentSymbolProvider then
                navic.attach(client, bufnr)
              end
              if client.server_capabilities.inlayHintProvider then
                vim.g.inlay_hints_visible = true
                vim.lsp.inlay_hint.enable(bufnr, true)
              end
            end
            local function tableMerge(table1, table2)
              local merge = {}
              for _, v in ipairs(table1) do
                table.insert(merge, v)
              end
              for _, v in ipairs(table2) do
                table.insert(merge, v)
              end
              return merge
            end
            local common_lspconfig = {
              capabilities = capabilities,
              on_attach = on_attach,
            }

            lspconfig.clangd.setup(common_lspconfig)
            lspconfig.bashls.setup(common_lspconfig)
            lspconfig.pyright.setup(common_lspconfig)
            lspconfig.rnix.setup(common_lspconfig)
            lspconfig.statix.setup(common_lspconfig)
            lspconfig.jsonls.setup(common_lspconfig)
            lspconfig.yamlls.setup(common_lspconfig)
            lspconfig.rust_analyzer.setup (tableMerge (common_lspconfig, {
              settings = {
                ['rust-analyzer'] = {
                  checkOnSave = {
                    command = "clippy",
                  },
                  check = {
                    command = "clippy";
                  },
                  diagnostics = {
                    enable = true;
                  }
                },
              },
            }))
          '';
        }

        # NOTE: "z" key is prefix for the fold functionalities
        # {
        #   plugin = nvim-ufo;
        #   type = "lua";
        #   config = ''
        #     require('ufo').setup()
        #   '';
        # }

        {
          plugin = nvim-navbuddy;
          type = "lua";
          config = ''
            local navbuddy = require("nvim-navbuddy")
            navbuddy.setup {
              lsp = {
                auto_attach = true,
              },
            }
            -- use gb to open navbuddy which show breadcrumb
            vim.keymap.set('n', 'gb', '<cmd>lua require("nvim-navbuddy").open()<CR>', {
                desc = "Open navbuddy"
            })
          '';
        }
      ];
    };
  };
}
