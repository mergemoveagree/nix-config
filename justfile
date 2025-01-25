ungit:
  if [ ! -d /home/user/nix-config/.git.bk ]; then mv /home/user/nix-config/.git{,.bk}; echo -e "\033[32mCommand successful\033[0m"; else echo -e "\033[31mAlready ungit'd\033[0m"; fi
regit:
  if [ ! -d /home/user/nix-config/.git ]; then mv /home/user/nix-config/.git{.bk,}; echo -e "\033[32mCommand successful\033[0m";  else echo -e "\033[31mAlready git'd\033[0m"; fi
