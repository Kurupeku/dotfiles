local fn = vim.fn
local api = vim.api

-- packer.nvimがインストールされていない際のbootstrap
local install_dir = fn.stdpath('data') .. '/site/pack/packer/opt/'
local install_path = install_dir .. 'packer.nvim'
local packer_bootstrap
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system { 'mkdir', '-p', install_dir }
  packer_bootstrap = fn.system {
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path
  }
end
api.nvim_command 'packadd packer.nvim'

-- このファイルに変更があった際にPackerSyncとPackerCompileを実行する
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

local packer = require 'packer'
local util = require 'packer.util'
local disable_nerd = fn.empty(fn.glob([[~/nerd-fonts/install.sh]])) > 0

return packer.startup {
  function(use)
    -- 自身も管理対象に追加
    use { 'wbthomason/packer.nvim', opt = true }

    -- 非依存プラグイン
    use 'nvim-lua/plenary.nvim'
    use 'MunifTanjim/nui.nvim'
    use "tami5/sqlite.lua"

    -- Nvim builtin LSP用プラグイン
    use 'neovim/nvim-lspconfig'
    use { 'williamboman/nvim-lsp-installer', config = function() require 'plugins.nvim-lsp-installer' end, after = { 'nvim-lspconfig' } }
    use { 'tami5/lspsaga.nvim', config = function() require 'plugins.lspsaga' end, after = { 'nvim-lsp-installer' } }
    use { "folke/trouble.nvim", after = { "nvim-lsp-installer", "lsp-colors.nvim" }, config = function() require("plugins.trouble") end }
    use { 'j-hui/fidget.nvim', after = { 'nvim-lsp-installer' }, config = function() require 'fidget'.setup() end }
    use 'folke/lsp-colors.nvim'

    -- AutoComplete関連のプラグイン
    use { 'windwp/nvim-autopairs', config = function() require 'plugins.nvim-autopairs' end }
    use { 'hrsh7th/nvim-cmp', after = { 'lspkind-nvim', 'nvim-autopairs', 'cmp-nvim-lsp' }, config = function() require 'plugins.nvim-cmp' end }
    use { 'onsails/lspkind-nvim' }
    use { "nvim-telescope/telescope-frecency.nvim", config = function() require "telescope".load_extension("frecency") end, after = { "sqlite.lua", "telescope.nvim" }
    }
    use { 'hrsh7th/cmp-nvim-lsp' }
    use { 'hrsh7th/cmp-nvim-lsp-signature-help', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-nvim-lsp-document-symbol', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-path', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-omni', after = 'nvim-cmp' }
    use { 'zbirenbaum/copilot-cmp', after = { 'nvim-cmp', 'copilot.lua' } }
    use { 'hrsh7th/cmp-emoji', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-calc', after = 'nvim-cmp' }
    use { 'f3fora/cmp-spell', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' }
    use { "lukas-reineke/cmp-rg", after = 'nvim-cmp' }
    use { 'hrsh7th/vim-vsnip', config = function() require 'plugins.vim-vsnip' end }
    use { 'hrsh7th/vim-vsnip-integ', after = { 'vim-vsnip' } }
    use { 'ray-x/cmp-treesitter', after = { 'nvim-cmp', 'nvim-treesitter' } }
    use { 'windwp/nvim-ts-autotag', after = { 'nvim-treesitter' } }

    -- AI補完系
    use { 'github/copilot.vim', cmd = { 'Copilot' } }
    use { 'zbirenbaum/copilot.lua', after = 'copilot.vim', config = function() require 'plugins.copilot' end }

    -- ファイラー
    use { 'nvim-neo-tree/neo-tree.nvim', config = function() require 'plugins.neo-tree' end, after = { 'plenary.nvim', 'nui.nvim', 'nvim-web-devicons' } }

    -- ファジーファインダー
    use { 'nvim-telescope/telescope.nvim', config = function() require 'plugins.telescope' end, after = { 'plenary.nvim' } }

    -- ターミナル操作
    use { "akinsho/toggleterm.nvim", config = function() require 'plugins.toggleterm' end, event = 'VimEnter' }

    -- ビジュアルスター検索
    use { 'haya14busa/vim-asterisk', config = function() require 'plugins.vim-asterisk' end, event = 'VimEnter' }

    -- カラースキーマ
    use { 'EdenEast/nightfox.nvim', config = function() vim.cmd [[colorscheme nordfox]] end }

    -- Syntax Highlight
    use { 'nvim-treesitter/nvim-treesitter', config = function() require 'plugins.nvim-treesitter' end, run = ':TSUpdate' }
    use { 'yioneko/nvim-yati', after = { 'nvim-treesitter' } }
    use { 'mfussenegger/nvim-ts-hint-textobject', after = { 'nvim-treesitter' } }
    use { 'm-demare/hlargs.nvim', config = function() require 'hlargs'.setup() end, after = { 'nvim-treesitter' } }
    use { 'David-Kunz/treesitter-unit', config = function() require 'plugins.treesitter-unit' end, after = { 'nvim-treesitter' } }

    -- Icon表示
    use { 'kyazdani42/nvim-web-devicons', config = function() require 'nvim-web-devicons'.setup() end, disable = disable_nerd }

    -- ステータスライン
    use { 'nvim-lualine/lualine.nvim', config = function() require 'plugins.lualine' end }

    -- タブ表示
    use { 'akinsho/bufferline.nvim', config = function() require 'plugins.bufferline' end, tag = "*" }

    -- 選択範囲拡張プラグイン
    use { 'terryma/vim-expand-region', config = function() require 'plugins.vim-expand-region' end, event = 'VimEnter' }

    -- ワードジャンプ
    use { 'phaazon/hop.nvim', config = function() require 'plugins.hop' end, event = 'VimEnter' }

    -- スクロールの円滑化
    use { 'karb94/neoscroll.nvim', config = function() require 'neoscroll'.setup() end, event = 'VimEnter' }

    -- 通知カスタマイズ
    use { 'rcarriga/nvim-notify', config = function() require 'plugins.nvim-notify' end, event = 'VimEnter' }

    -- インデントの可視化
    use { 'lukas-reineke/indent-blankline.nvim', config = function() require 'plugins.indent-blankline' end, event = 'BufEnter' }

    -- 空白の可視化
    use { "McAuleyPenney/tidy.nvim", event = "BufWritePre" }

    -- エディターコンフィグの適応
    use { 'editorconfig/editorconfig-vim', event = 'BufEnter' }

    -- ブラケットユーティリティ
    use { 'tpope/vim-surround', event = "BufEnter" }
    use { 'tpope/vim-repeat', event = 'VimEnter' }

    -- オートセーブ
    use { "Pocco81/AutoSave.nvim", config = function() require 'plugins.autosave' end, event = 'BufEnter' }

    -- コメントアウト
    use { 'numToStr/Comment.nvim', config = function() require('Comment').setup() end, event = 'BufEnter' }

    -- カラーコードの可視化
    use { 'norcalli/nvim-colorizer.lua', config = function() require 'colorizer'.setup() end, event = 'BufEnter' }

    -- インデントの可視化
    use { 'Yggdroot/indentLine', event = 'BufEnter' }

    -- インサートモードに入ると絶対行数表示に変更
    use { 'myusuf3/numbers.vim', event = 'BufEnter' }

    -- バッファを消してもウィンドウを保持
    use { 'famiu/bufdelete.nvim', event = 'VimEnter' }

    -- カーソル下の単語をブラウザで検索
    use { 'tyru/open-browser.vim', config = function() require 'plugins.open-browser' end, event = 'BufEnter' }

    -- ドキュメントの日本語化
    use 'vim-jp/vimdoc-ja'

    -- 起動時間の高速化
    use 'lewis6991/impatient.nvim'

    -- Golang用プラグイン
    use { 'mattn/vim-goimports', setup = function() vim.api.nvim_set_var('goimports_simplify', 1) end, ft = { 'go' } }

    if packer_bootstrap then
      packer.sync()
    end
  end,
  config = {
    display = {
      open_fn = util.float,
    }
  }
}
