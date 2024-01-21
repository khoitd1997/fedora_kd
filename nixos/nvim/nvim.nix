{ pkgs, lib, ... }:
{
  config = {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      coc = {
        enable = true;
        settings = {
          "colors.enable" = true;
          "codeLens.enable" = true;
          "coc.preferences.enableLinkedEditing" = true;
          "diagnostic.floatConfig" = {
            "rounded" = true;
            "border" = true;
          };
          "diagnostic.format" = "%message [%source]";
          "diagnostic.virtualText" = true;
          "diagnostic.checkCurrentLine" = true;
          "diagnostic.separateRelatedInformationAsDiagnostics" = true;
          languageserver = {
            haskell = {
              command = "haskell-language-server";
              args = [ "--lsp" ];
              rootPatterns = [
                "*.cabal"
                "stack.yaml"
                "cabal.project"
                "package.yaml"
                "hie.yaml"
              ];
              filetypes = [ "haskell" "lhaskell" ];
            };
          };
        };
      };

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

        "alt+f1 for filesystems browser
        nnoremap <F49> :Oil<CR>

        " Use ctrl+[hjkl] to select the active split
        nmap <silent> <c-k> :wincmd k<CR>
        nmap <silent> <c-j> :wincmd j<CR>
        nmap <silent> <c-h> :wincmd h<CR>
        nmap <silent> <c-l> :wincmd l<CR>

        " use ctrl+\ to vertically split
        nmap <silent> <c-\> :vsplit<CR>

        "coc alt-j and alt-k to navigate completions
        execute "map \ej <M-j>"
        inoremap <expr> <M-j> coc#pum#visible() ? coc#pum#next(1) : "<M-j>"
        execute "map \ek <M-k>"
        inoremap <expr> <M-k> coc#pum#visible() ? coc#pum#prev(1) : "<M-k>"

        "coc tab and enter to select the completions
        inoremap <expr> <Tab> coc#pum#visible() ? coc#_select_confirm() : "<Tab>"
        inoremap <expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "<cr>"

        "ctrl+n to search for files
        nmap <unique> <C-N> :Files<CR>

        " use shift+K to show type
        nnoremap <silent> K :call <SID>show_documentation()<CR>
        function! s:show_documentation()
          if (index(['vim','help'], &filetype) >= 0)
            execute 'h '.expand('<cword>')
          elseif (coc#rpc#ready())
            call CocActionAsync('doHover')
          else
            execute '!' . &keywordprg . " " . expand('<cword>')
          endif
        endfunction

        " gd to go to definition
        nmap <silent> gd <Plug>(coc-definition)

        " toggleterm needs this
        set hidden
      '';

      plugins = with pkgs.vimPlugins; [
        coc-json
        coc-pyright
        coc-sh
        coc-yaml
        coc-rust-analyzer

        vim-surround
        vim-sleuth
        nvim-web-devicons
        vim-devicons
        vim-codefmt
        vim-nix
        vim-fugitive
        vim-eunuch
        statix
        nerdtree
        diffview-nvim

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
            require('mini.indentscope').setup({
                draw = {
                  -- disable animation
                  animation = require('mini.indentscope').gen_animation.none(),
                },
                options = {
                  try_as_border = true,
                },
            })
            require('mini.pairs').setup()
            require('mini.tabline').setup()
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
            require("oil").setup()
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
          plugin = gruvbox;
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
          plugin = vim-gitgutter;
          config = ''
            set updatetime=100
            set signcolumn=yes

            highlight GitGutterAdd    ctermbg=191 ctermfg=2
            highlight GitGutterChange ctermbg=214 ctermfg=3
            highlight GitGutterDelete ctermbg=160 ctermfg=1
            highlight GitGutterChangeDelete ctermbg=160 ctermfg=1
          '';
        }
        {
          plugin = toggleterm-nvim;
          type = "lua";
          config = ''
            -- ctrl+i to toggle terminal
            require("toggleterm").setup({
              open_mapping = [[<c-i>]],
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
              vim.keymap.set('t', '<C-i>', [[<C-\><C-n><C-w>]], opts)
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

            -- ctrl+r to search current word across all files
            vim.keymap.set('n', '<C-R>', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
                desc = "Toggle Spectre"
            })
          '';
        }
        #{
          #plugin = nvim-navbuddy;
          #type = "lua";
          #config = ''
            #local navbuddy = require("nvim-navbuddy")
            #local actions = require("nvim-navbuddy.actions")
            #navbuddy.setup {
              #lsp = {
                  #auto_attach = true,
              #}
            #}
            #-- use gb to open navbuddy
            #vim.keymap.set('n', 'gb', '<cmd>lua require("nvim-navbuddy").open()<CR>', {
                #desc = "Open navbuddy"
            #})
          #'';
        #}
      ];
    };
  };
}
