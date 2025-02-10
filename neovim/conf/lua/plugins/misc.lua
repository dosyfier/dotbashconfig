return {
  -- Helper for git difftool / mergetool
  {
    "sindrets/diffview.nvim",
    opts = {
      hooks = {
        diff_buf_read = function(_)
          -- Change local options in diff buffers
          vim.opt_local.wrap = true
          vim.opt.wrap = true
        end
      }
    }
  },

  -- Git command bindings
  "tpope/vim-fugitive",

  -- XML files edition
  "sukima/xmledit",

  -- TreeSitter integration (incremental parser)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- Not doing great, e.g. with Ansible...
      highlight = { enable = false },
      indent = { enable = false }
    }
  },
  "nvim-treesitter/playground",

  -- Great Tim Pope's plugins
  "tpope/vim-sleuth",
  "tpope/vim-surround",

  -- Logstash syntax highlight
  "robbles/logstash.vim",

  -- Ansible syntax highlight
  "pearofducks/ansible-vim",

  -- NGINX config files syntax highlighting
  "chr4/nginx.vim",

  -- Highlight and search for todo comments (TODO, FIXME, ...)
  "folke/todo-comments.nvim",
}
