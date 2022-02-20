-- vim:fdm=marker

-- CHANGELOG {{{1
-- Transition to neovim 0.5! (From `deprecated/.init.vim.02`)
--
-- Theme: Simplify and remove bespoke stuff.
--
-- * Everything in lua!
-- * Drop Windows support because it's not useful to me
-- * binding: <leader>sc => yoh (vim-unimpaired binding)
-- * binding: Remove clipboard integration bindings. I think it was messing with things.
-- * binding: No longer move cursor back when exiting insert mode.
--     * I prefer old behavior, but my desire for standard behavior is even stronger.
--     * https://vi.stackexchange.com/questions/3138/cursor-moves-one-character-backwards-on-exiting-insert-mode
--     * The vi mode in zsh mixes me up sometimes based on this
-- * plugin-manager: vim-plug => packer
-- * plugin: fzf => telescope
-- * plugin: gitgutter => gitsigns
-- * plugin: sgur/vim-editorconfig => editorconfig/vim-editorconfig
--     * Speed issues have been addressed
-- * plugin: vim-airline => lualine
--
-- MISSING
--
-- * plugin: syntax highlighting (Pending treesitter)
--
-- REMOVED:
-- * plugin: base16 color scheme

-- SETTINGS {{{1

vim.g["config_path"] = "~/.config/nvim/"

-- Indentation
local indent = 4
vim.o["expandtab"] = true
-- :help smartindent
-- When using the ">>" command, lines starting with '#' are not shifted right.
-- vim.o["smartindent"] = false
vim.o["shiftwidth"] = indent
vim.o["tabstop"] = indent

-- Case insensitive unless we type caps
-- (Force sensitivity by suffixing with \C if neccesary)
vim.go["ignorecase"] = true
vim.go["smartcase"] = true

vim.o["swapfile"] = false

vim.wo["number"] = true      -- Show line numbers
vim.wo["cursorline"] = true  -- Highlight line the cursor is on

-- Switch buffers without abandoning changes or writing out
vim.o["hidden"] = true

-- Mouse support for all modes
vim.o["mouse"] = "a"

-- Special characters
vim.o["showbreak"] = "»"
vim.opt.listchars = {
    -- eol = "¶",
    extends = "»",
    nbsp = "¬",
    precedes = "«",
    tab = ">-",
    trail = "-", -- Other chars: •¤
}
vim.o["list"] = true -- Actually show the listchars above

-- REMAPS {{{1

function dict_under_cursor()
    -- This is probably done in a really stupid way :)
    word_under_cursor = vim.api.nvim_eval('expand("<cword>")')
    vim.api.nvim_command('!dict '..word_under_cursor)
end
vim.api.nvim_set_keymap("n", "gD", ":lua dict_under_cursor()<cr>", {noremap = true})

-- Use jk/kj to exit insertion mode (Writing this line was fun!)
vim.api.nvim_set_keymap("i", "jk", "<Esc>", {noremap = true})
vim.api.nvim_set_keymap("i", "kj", "<Esc>", {noremap = true})

-- Move up/down sensibly on wrapped lines
vim.api.nvim_set_keymap("n", "j", "gj", {noremap = true})
vim.api.nvim_set_keymap("n", "k", "gk", {noremap = true})

-- Make Y behave as C and D do
vim.api.nvim_set_keymap("n", "Y", "y$", {noremap = true})

-- re-run the last command in the next tmux pane
-- https://superuser.com/questions/744857/how-to-send-keys-to-other-pane
vim.api.nvim_set_keymap("n", "<C-p>", ":silent !tmux send-keys -t .+ Up Enter<cr>", {noremap = true})
-- Alternative workflow ideas:
-- Have a key chuck you over to another pane to run some interactive process
--   :nnoremap <C-p> :silent !tmux send-keys -t .+ Up Enter && tmux select-pane R <enter>
-- And then send you back when it's done
--   /run.sh ; tmux select-pane -L

-- Spacemacs-esque Remaps -----------------

-- Map leader to space
vim.g["mapleader"] = " "

-- Edit dotfiles
vim.api.nvim_set_keymap("n", "<leader>fed", ":e " .. vim.g["config_path"] .. "init.lua<cr>", {noremap = true})

-- Jump back to previous buffer
vim.api.nvim_set_keymap("n", "<leader><TAB>", "<C-^>", {noremap = true})

-- PLUGINS {{{1

-- Auto install packer.nvim if required
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.api.nvim_command('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end
vim.cmd [[packadd packer.nvim]]
-- Not sure how I feel about this bit
-- vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile' -- Auto compile when there are changes in plugins.lua

require("packer").startup(function()
    -- Packer can manage itself as an optional plugin
    use {"wbthomason/packer.nvim", opt = true}

    -- Colors and Themes
    use {"sainnhe/gruvbox-material"}       -- Warm and cozy.    256/truecolor
    use {"jeffkreeftmeijer/vim-dim"}       -- Default IMproved. 16 color

    use {"norcalli/nvim-colorizer.lua"}    -- Highlight colorcodes (Like #fe03bb)
    use {"hoob3rt/lualine.nvim",           -- Status line
        config = function()
            require("lualine").setup {
                options = {
                    component_separators = "",
                    icons_enabled = false,
                    section_separators = "",
                    theme = "codedark",
                }
            }
            vim.o["showmode"] = false -- lualine plugin replaces vim mode indicator
        end }

    use { "vim-scripts/DrawIt" }           -- ASCII diagrams

    -- Usability
    use {"junegunn/vim-easy-align",        -- Align around characters. Useful for tables.
        config = function()
            vim.api.nvim_set_keymap("n", "ga", "<Plug>(EasyAlign)", {noremap = false})
            vim.api.nvim_set_keymap("v", "ga", "<Plug>(EasyAlign)", {noremap = false})
        end }

    use {"tpope/vim-commentary"}           -- Allow commenting blocks of code
    use {"tpope/vim-repeat"}               -- Allow repeating supported plugins with `.`
    use {"tpope/vim-surround"}             -- For manipulating surrounding text
    use {"tpope/vim-unimpaired"}           -- Complimentary pairs of mappings
    use {"tpope/vim-vinegar"}              -- Enhance the default file explorer, netrw

    use {"farmergreg/vim-lastplace"}       -- Remember last place in files. Good for ebooks.

    use {"jpalardy/vim-slime",             -- Send buffer snippets to a REPL
        config = function()
            vim.g["slime_target"] = "tmux"
            if (vim.env.TMUX) then
                -- Assume SLIME target is the next tmux pane
                vim.g["slime_default_config"] = {socket_name=vim.split(vim.env["TMUX"], ",")[1], target_pane=":.+"}
            end

            vim.g["slime_cell_delimiter"] = "```"
            vim.api.nvim_set_keymap("n", "<leader>sc", "<Plug>SlimeSendCell", {noremap = false})
            vim.api.nvim_set_keymap("n", "<leader>sn", "<Plug>SlimeConfig", {noremap = false})
        end }
    use {"editorconfig/editorconfig-vim"}  -- Obey `.editorconfig` files (https://editorconfig.org/)

    -- Language Server Protocol (LSP)

    -- Helps nvim find and automatically start the correct language servers.
    -- Can provide completion alone via nvim's omnifunc, works better with nvim-cmp (below)
    use {"neovim/nvim-lspconfig"}          -- Collection of common LSP configs.

    -- Autocompletion engine which can draw from LSP (and other stuff).
    -- It provides additional functionality over vim's native omnicompletion like
    -- async, autocomplete, more columns...
    use {"hrsh7th/nvim-cmp",
        requires = {
            {"hrsh7th/cmp-buffer"},            -- Let nvim-cmp autocomplete from buffer words
            {"hrsh7th/cmp-nvim-lsp"},          -- Let nvim-cmp autocomplete from LSP
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup {
                mapping = {
                    ["<C-Space>"] = cmp.mapping.complete(), -- Manually invoke completion menu
                    ["<TAB>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                },
                sources = {
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                },
                completion = {
                    autocomplete = false
                }
            }
        end }

    -- Filetype-specific

    -- use { "pirmd/gemini.vim" }             -- gemini syntax highlighting
    -- use { "LnL7/vim-nix" }                 -- nix syntax highlighting
    use { "plasticboy/vim-markdown",       -- markdown syntax highlighting
        requires = "godlygeek/tabular",
        config = function()
            -- Fold markdown on the same line as the title, not the line after
            vim.g["vim_markdown_folding_style_pythonic"] = 1
            -- Make ToC not take up half the screen
            vim.g["vim_markdown_toc_autofit"] = 1
        end }
    use { "HiPhish/info.vim" }             -- info: Read info/texinfo doc files

    -- Git
    use { "tpope/vim-fugitive" }           -- Git integration
    use { "lewis6991/gitsigns.nvim",       -- Show git status in gutter. Bindings to stage hunks.
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("gitsigns").setup {
                update_debounce = 300, -- Increase to prevent flickering
            }
        end }

    use { "nvim-telescope/telescope.nvim", -- Fuzzy finder
        requires = {{"nvim-lua/popup.nvim"}, {"nvim-lua/plenary.nvim"}},
        config = function()
            require("telescope").setup {
                defaults = {
                    mappings = {
                        i = {  -- Move through list with Ctrl j/k
                            ["<C-j>"] = require('telescope.actions').move_selection_next,
                            ["<C-k>"] = require('telescope.actions').move_selection_previous,
                        }
                    }
                }
            }
            vim.api.nvim_set_keymap("n", "<leader>ff", ":Telescope find_files<cr>", {noremap = true})
            vim.api.nvim_set_keymap("n", "<leader>fg", ":Telescope live_grep<cr>", {noremap = true})
            vim.api.nvim_set_keymap("n", "<leader>fb", ":Telescope buffers<cr>", {noremap = true})
            vim.api.nvim_set_keymap("n", "<leader>fh", ":Telescope help_tags<cr>", {noremap = true})
            vim.api.nvim_set_keymap("n", "<leader>fr", ":Telescope oldfiles<cr>", {noremap = true})

        end
    }
    -- TODO: What is "nvim-telescope/telescope-hop"?
end)
-- To update things: `PackerSync`

-- PLUGIN SETTINGS {{{1

-- LSP config {{{
-- Now that cmp_nvim_lsp is installed, we should tell the language servers that
-- we support more capabilities than plain old neovim would otherwise.
local capabilities = vim.lsp.protocol.make_client_capabilities()
require("cmp_nvim_lsp").update_capabilities(capabilities)

-- List of LSP servers you want nvim to be aware of
-- For all possibilities, see:
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
local language_servers = {"rust_analyzer", "gopls"}

-- Set up each LSP server by telling it which capabilities nvim supports
local lspconfig = require("lspconfig")
for _, lsp in ipairs(language_servers) do
    lspconfig[lsp].setup {
        capabilities = capabilities,
    }
end
-- }}}

-- Colorscheme

-- vim.o["termguicolors"] = true
-- vim.cmd "colorscheme gruvbox-material"
vim.cmd "colorscheme dim"

-- The linux framebuffer terminal doesn't support underline, so it makes lines
-- blue instead, which I am not happy with.
-- TODO: Only apply this in TERMs without underline support
-- It's not sufficient to say only `hi CursorLine...` and I'm not sure why
vim.cmd "au VimEnter * hi CursorLine cterm=bold"
