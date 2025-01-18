{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    zeitgeist
    plocate
  ];

  xdg.configFile."xfce4/helpers.rc".text = ''
    TerminalEmulator=${pkgs.kitty}/bin/kitty
  '';

  xdg.configFile."Thunar/uca.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <actions>
    <action>
      <icon>utilities-terminal</icon>
      <name>Open Terminal Here</name>
      <submenu></submenu>
      <unique-id>1737193214336806-1</unique-id>
      <command>${pkgs.xfce.exo}/bin/exo-open --working-directory %f --launch TerminalEmulator</command>
      <description>Open terminal in selected directory</description>
      <range></range>
      <patterns>*</patterns>
      <startup-notify/>
      <directories/>
    </action>
    <action>
      <icon>edit-find</icon>
      <name>Search with Catfish</name>
      <submenu></submenu>
      <unique-id>1737237387060213-1</unique-id>
      <command>${pkgs.xfce.catfish}/bin/catfish --path=%f</command>
      <description>Search recursively through selected directories</description>
      <range></range>
      <patterns>*</patterns>
      <startup-notify/>
      <directories/>
    </action>
    </actions>
  '';
}
