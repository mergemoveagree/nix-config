{
  imports = [
    ./neotree.nix
    ./indent-blankline.nix
    ./navic.nix
    ./treesitter.nix
    ./todo-comments.nix
    ./illuminate.nix

    ./cmp.nix
    ./bufferline.nix
    ./lualine.nix
    ./lsp.nix
    ./neominimap.nix
  ];

  colorschemes.nord.enable = true;
  plugins.web-devicons.enable = true;  # For neotree and bufferline

  globals.mapleader = " ";
  clipboard.providers.wl-copy.enable = true;
  opts = {
    number = true;
    relativenumber = false;
    clipboard = "unnamedplus";
    tabstop = 2;
    softtabstop = 2;
    expandtab = true;
    smartindent = true;
    shiftwidth = 2;
    breakindent = true;
    cursorline = true;
    scrolloff = 8;
    foldmethod = "manual";
    foldenable = false;
    linebreak = true;
    spell = false;
    termguicolors = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "]b";
      action = "<cmd>BufferLineCycleNext<cr>";
      options = {
        desc = "Cycle to next buffer";
      };
    }
    {
      mode = "n";
      key = "[b";
      action = "<cmd>BufferLineCyclePrev<cr>";
      options = {
        desc = "Cycle to previous buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>c";
      action = "<cmd>bdelete<cr>";
      options = {
        desc = "Delete buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>bp";
      action = "<cmd>BufferLineTogglePin<cr>";
      options = {
        desc = "Toggle pin";
      };
    }
  ];
}
