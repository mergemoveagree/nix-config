{ config
, lib
, ...
}: {
  config = lib.mkIf config.hostSpec.enableZsh {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ll = "ls -l";
      };
    };
  };

  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = config.hostSpec.enableZsh;
  programs.fzf.enableBashIntegration = !config.hostSpec.enableZsh;

  programs.thefuck.enable = true;
  programs.thefuck.enableZshIntegration = config.hostSpec.enableZsh;
  programs.thefuck.enableBashIntegration = !config.hostSpec.enableZsh;
}
