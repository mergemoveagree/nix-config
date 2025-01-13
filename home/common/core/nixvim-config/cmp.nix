{pkgs
, ...
}: {
  plugins = {
    cmp = {
      enable = true;
      settings = {
        performance = {
          debounce = 60;
          fetchingTimeout = 200;
          maxViewEntries = 30;
        };
        formatting = {fields = ["kind" "abbr" "menu"];};
        sources = [
          {
            name = "nvim_lsp";
          }
          {
            name = "buffer";
            option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
            keywordLength = 3;
          }
          {
            name = "path";
            keywordLength = 3;
          }
        ];
        window = {
          completion = {border = "solid";};
          documentation = {border = "solid";};
        };
        mapping = {
          "<C-Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<C-j>" = "cmp.mapping.select_next_item()";
          "<C-k>" = "cmp.mapping.select_prev_item()";
          "<C-e>" = "cmp.mapping.abort()";
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-CR>" = "cmp.mapping.confirm({ select = true })";
          "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
        };
        experimental.ghost_text = true;
        sorting.__raw = ''
          (function()
            ai_top_comparator = function(entry1, entry2)
              local comp_item = entry1:get_completion_item()
              if comp_item ~= nil then
                if string.sub(comp_item.label, 1, 4) == "ai -" then
                  return true
                end
              end
              comp_item = entry2:get_completion_item()
              if comp_item ~= nil then
                if string.sub(comp_item.label, 1, 4) == "ai -" then
                  return false
                end
              end
              return nil
            end

            local default_sorting = require('cmp.config.default')().sorting
            local my_sorting = vim.tbl_extend("force", {}, default_sorting)
            table.insert(my_sorting.comparators, 1, ai_top_comparator)
            return my_sorting
          end
          )()
        '';
      };
    };
    cmp-nvim-lsp = {
      enable = true;
      package = pkgs.callPackage ({ buildVimPlugin
        , fetchFromGitHub
        , ...
      }: buildVimPlugin {
          pname = "cmp-nvim-lsp";
          version = "2024-05-17";
          src = fetchFromGitHub {
            owner = "hrsh7th";
            repo = "cmp-nvim-lsp";
            rev = "39e2eda76828d88b773cc27a3f61d2ad782c922d";
            hash = "sha256-CT1+Z4XJBVsl/RqvJeGmyitD6x7So0ylXvvef5jh7I8=";
          };
          meta.homepage = "https://github.com/hrsh7th/cmp-nvim-lsp/";
      }) {inherit (pkgs.vimUtils) buildVimPlugin;};
    };
    cmp-buffer.enable = true;
    cmp-path.enable = true;
    cmp-cmdline.enable = false;
  };
  extraConfigLua = ''
    kind_icons = {
      Text = "󰊄",
      Method = " ",
      Function = "󰡱 ",
      Constructor = " ",
      Field = " ",
      Variable = "󱀍 ",
      Class = " ",
      Interface = " ",
      Module = "󰕳 ",
      Property = " ",
      Unit = " ",
      Value = " ",
      Enum = " ",
      Keyword = " ",
      Snippet = " ",
      Color = " ",
      File = "",
      Reference = " ",
      Folder = " ",
      EnumMember = " ",
      Constant = " ",
      Struct = " ",
      Event = " ",
      Operator = " ",
      TypeParameter = " ",
    } 

    local cmp = require'cmp'

     -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
     cmp.setup.cmdline({'/', "?" }, {
       sources = {
         { name = 'buffer' }
       }
     })

     -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
     cmp.setup.cmdline(':', {
       sources = cmp.config.sources({
         { name = 'path' }
       }, {
         { name = 'cmdline' }
       }),
     })
  '';
}
