ungit:
  if [ ! -d ~/nix-config/.git.bk ]; then mv ~/nix-config/.git{,.bk}; echo -e "\033[32mCommand successful\033[0m"; else echo -e "\033[31mAlready ungit'd\033[0m"; fi
regit:
  if [ ! -d ~/nix-config/.git ]; then mv ~/nix-config/.git{.bk,}; echo -e "\033[32mCommand successful\033[0m";  else echo -e "\033[31mAlready git'd\033[0m"; fi
