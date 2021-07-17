-- vim:fdm=marker

-- CHANGELOG {{{1
-- Transition to neovim 0.5!
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
-- * plugin: fugitive => neogit
--     * Speed issues have been addressed
--
-- MISSING
--
-- * plugin: Character alignment plugin
-- * plugin: base16 color scheme
-- * plugin: autocompletion/syntax highlighting
-- * plugin: Airline or similar

-- SETTINGS {{{1

vim.g["config_path"] = "~/.config/nvim/"

-- Indentation
local indent = 4
vim.o["expandtab"] = true
vim.o["smartindent"] = true
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

-- REMAPS {{{1

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

  -- Theme
  use {"sainnhe/gruvbox-material"}

  -- Usability
  use {"tpope/vim-commentary"}           -- Allow commenting blocks of code
  use {"tpope/vim-repeat"}               -- Allow repeating supported plugins with `.`
  use {"tpope/vim-surround"}             -- For manipulating surrounding text
  use {"tpope/vim-unimpaired"}           -- Complimentary pairs of mappings
  use {"tpope/vim-vinegar"}              -- Enhance the default file explorer, netrw

  use {"jpalardy/vim-slime"}             -- Send buffer snippets to a REPL
  use {"editorconfig/editorconfig-vim"}  -- Obey `.editorconfig` files (https://editorconfig.org/)

  -- Git
  use { "TimUntersberger/neogit", requires = "nvim-lua/plenary.nvim" }
  use { "lewis6991/gitsigns.nvim",       -- Show git status in gutter. Bindings to stage hunks.
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("gitsigns").setup()
        end }

  use {
      "nvim-telescope/telescope.nvim",
      requires = {{"nvim-lua/popup.nvim"}, {"nvim-lua/plenary.nvim"}}
  }
end)
-- To update things: `PackerSync`

-- Colorscheme

vim.o["termguicolors"] = true
vim.cmd "colorscheme gruvbox-material"

-- Plugin Settings

-- Assume SLIME target is the next tmux pane
vim.g["slime_target"] = "tmux"
vim.g["slime_default_config"] = {socket_name=vim.split(vim.env["TMUX"], ",")[1], target_pane=":.+"}

vim.api.nvim_set_keymap("n", "<leader>ff", ":Telescope find_files<cr>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>fg", ":Telescope live_grep<cr>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>fb", ":Telescope buffers<cr>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>fh", ":Telescope help_tags<cr>", {noremap = true})
