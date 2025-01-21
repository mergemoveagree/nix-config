{ pkgs
, lib
, config
, ...
}: let
  cpu-temp-script = pkgs.substituteAll {
    src = ./cpu-temp.sh;
    isExecutable = true;
    env = {
      inherit (pkgs)
        bash
        lm_sensors
      ;
    };
  };
in {
  home.packages = with pkgs; [
    playerctl
  ]
  ++ (with pkgs.nerd-fonts; [
    martian-mono
    jetbrains-mono
  ]);

  programs.waybar = {
    enable = true;
    style = ./style.css;
    settings.mainBar = {
      # Based on https://github.com/Anik200/dotfiles/tree/super-waybar
      layer = "top";
      position = "top";
      mode = "dock";
      margin-left = 10;
      margin-right = 10;
      margin-top = 7;
      margin-bottom = 0;
      exclusive = true;
      passthrough = false;
      reload_style_on_change = true;

      modules-left = [ "custom/smallspacer" "custom/ws" "custom/left1" "hyprland/workspaces" "custom/right1" "custom/spacer" "mpris" ];
      modules-center = ["custom/padd" "custom/l_end" "custom/r_end" "hyprland/window" "custom/padd"];
      modules-right = ["custom/padd" "custom/l_end" "group/expand" "network" "group/expand-3" "group/expand-2" "idle_inhibitor" "memory" "cpu" "power-profiles-daemon" "custom/cputemp" "clock" "custom/notification" "custom/padd"];

      "custom/ws" = {
        format = " ";
        tooltip = false;
        min-length = 3;
        max-length = 3;
      };

      "custom/right1" = {
        format = "";
        tooltip = false;
      };

      "custom/left1" = {
        format = "";
        tooltip = false;
      };

      power-profiles-daemon = {
        format = " {icon} ";
        tooltip-format = "Power profile: {profile}\nDriver: {driver}";
        tooltip = true;
        format-icons = {
          default = "";
          performance = "";
          balanced = "";
          power-saver = "";
        };
      };

      mpris = {
        format = "{player_icon} {dynamic}";
        format-paused = "<span color='grey'>{status_icon} {dynamic}</span>";
        max-length = 50;
        player-icons = {
          default = "⏸";
          mpv = "🎵";
        };
        status-icons = {
          paused = "▶"; 
        };
      };

      "custom/cputemp" = {
        exec = "${cpu-temp-script}";
        return-type = "json";
        format = "{}";
        tooltip = true;
        interval = 5;
        min-length = 8;
        max-length = 8;
      };

      "custom/smallspacer".format = " ";

      memory =  {
        interval = 1;
        rotate =  270;
        format = "{icon}";
        format-icons = [ "󰝦 " "󰪞 " "󰪟 " "󰪠 " "󰪡 " "󰪢 " "󰪣 " "󰪤 " "󰪥 " ];
        max-length = 10;
      };
      cpu = {
        interval = 1;
        format = "{icon}";
        rotate = 270;
        format-icons = [ "󰝦 " "󰪞 " "󰪟 " "󰪠 " "󰪡 " "󰪢 " "󰪣 " "󰪤 " "󰪥 " ];
      };

      tray = {
        icon-size = 16;
        rotate = 0;
        spacing = 3;
      };

      "group/expand" = {
        orientation = "horizontal";
        drawer = {
          transition-duration = 600;
          children-class = "not-power";
          transition-to-left = true;
          #click-to-reveal = true;
        };
        modules = ["custom/menu" "custom/spacer" "tray"];
      };

      "custom/menu" = {
        format = "󰅃";
        rotate = 90;
      };

      "custom/notification" = {
        tooltip = false;
        format = "{icon}";
        format-icons = {
          notification = "󰅸 ";
          none = "󰂜 ";
          dnd-notification = "󰅸 ";
          dnd-none = "󱏨 ";
          inhibited-notification = "󰅸 ";
          inhibited-none = "󰂜 ";
          dnd-inhibited-notification = "󰅸 ";
          dnd-inhibited-none = "󱏨 ";
        };
        return-type = "json";
        exec = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
        on-click-right = "${pkgs.swaynotificationcenter}/bin/swaync-client -d -sw";
        on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
        escape = true;
      };

      "hyprland/window" = {  
        format = "{}";
        max-length = 120;
        icon = false;
        icon-size = 13;
        rewrite = {
          "~" = "  Terminal";
          zsh = "  Terminal";
          kitty = "  Terminal";
          "(.*)Mozilla Firefox" = "<span foreground='#f38ba8'>󰈹 </span> Firefox";
          "(.*) — Mozilla Firefox" = "<span foreground='#f38ba8'>󰈹 </span> $1";
          vesktop = "<span foreground='#89b4fa'> </span> Discord";
          "• Discord(.*)" = "Discord$1";
          "(.*)Discord(.*)" = "<span foreground='#89b4fa'> </span> $1Discord$2";
          "(.*).jpg" = "  $1.jpg";
          "(.*).png" = "  $1.png";
          "(.*).svg" = "  $1.svg";
        };
      };

      "custom/spacer".format = "|";

      "hyprland/workspaces" = {
        persistent-workspaces = {
          "${(lib.lists.findFirst ({ primary, ... }: primary) null config.hostSpec.monitors).portName}" = [ 1 ];
        };
        on-scroll-up = "hyprctl dispatch workspace +1";
        on-scroll-down = "hyprctl dispatch workspace -1";
      };

      idle_inhibitor = {
        format = "{icon}";
        rotate = 0;
        format-icons = {
          activated = "󰥔";
          deactivated = "";
        };
      };

      clock = {
        format = "󱑂 {:%H:%M}";
        tooltip = true;
        tooltip-format = "<tt>{calendar}</tt>";
        calendar = {
          mode = "month";
          mode-mon-col = 3;
          on-scroll = 1;
          on-click-right = "mode";
          format = {
            months = "<span color='#ffead3'><b>{}</b></span>";
            weekdays = "<span color='#ffcc66'><b>{}</b></span>";
            today = "<span color='#ff6699'><b>{}</b></span>";
          };
        };
      };

      battery = {
        states = {
          good = 95;
          warning = 30;
          critical = 20;
        };
        format = "{icon}";
        rotate = 0;
        format-charging = "<span color='#a6d189'>󱐋</span>";
        format-plugged = "󰂄";
        format-alt = "<<span weight='bold' color='#c2864a'>{time} <span weight='bold' color='white'>| <span weight='bold' color='#82d457'>{capacity}%</span></span></span>";
        format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        on-click-right = "pkill waybar & hyprctl dispatch exec waybar";
      };

      backlight = {
        device = "intel_backlight";
        rotate = 0;
        format = "{icon}";
        format-icons = [ "󰃞 " "󰃝 " "󰃟 " "󰃠 " ];
        scroll-step = 1;
        min-length = 2;
      };

      "group/expand-2" = {
        orientation = "horizontal";
        drawer = {
          transition-duration = 600;
          children-class = "not-power";
          transition-to-left = true;
          click-to-reveal = true;
        };
        modules = [ "backlight" "backlight/slider" "custom/smallspacer" ];
      };
        "group/expand-3" = {
          orientation = "horizontal";
          drawer = {
            transition-duration = 600;
            children-class = "not-power";
            transition-to-left = true;
            click-to-reveal = true;
          };
          modules = [ "pulseaudio" "pulseaudio/slider" ];
        };

        network = {
          tooltip = true;
          format-wifi = "{icon} ";
          format-icons = [ "󰤟 " "󰤢 " "󰤥 " ];
          rotate = 0;
          format-ethernet = "󰈀 ";
          tooltip-format = "Network: <big><b>{essid}</b></big>\nSignal strength: <b>{signaldBm}dBm ({signalStrength}%)</b>\nFrequency: <b>{frequency}MHz</b>\nInterface: <b>{ifname}</b>\nIP: <b>{ipaddr}/{cidr}</b>\nGateway: <b>{gwaddr}</b>\nNetmask: <b>{netmask}</b>";
          format-linked = "󰈀 {ifname} (No IP)";
          format-disconnected = " ";
          tooltip-format-disconnected = "Disconnected";
          interval = 2;
        };

        pulseaudio = {
          format = "{icon}";
          rotate = 0;
          format-muted = "婢";
          tooltip-format = "{icon} {desc} // {volume}%";
          scroll-step = 5;
          format-icons = {
            headphone = " ";
            hands-free = " ";
            headset = " ";
            phone = " ";
            portable = " ";
            car = " ";
            default = [ " " " " " " ];
          };
        };

        "pulseaudio#microphone" = {
          format = "{format_source}";
          rotate = 0;
          format-source = "";
          format-source-muted = "";
          on-click = "pavucontrol -t 4";
          on-click-middle = "volumecontrol.sh -i m";
          on-scroll-up = "volumecontrol.sh -i i";
          on-scroll-down = "volumecontrol.sh -i d";
          tooltip-format = "{format_source} {source_desc} // {source_volume}%";
          scroll-step = 5;
        };

        "backlight/slider" = {
          min = 5;
          max = 100;
          rotate = 0;
          device = "intel_backlight";
          scroll-step = 1;
        };
      
        "pulseaudio/slider" = {
          min = 5;
          max = 100;
          rotate = 0;
          device = "pulseaudio";
          scroll-step = 1;
        };

        "custom/l_end" = {
          format = " ";
          interval = "once";
          tooltip = false;
        };

        "custom/r_end" = {
          format = " ";
          interval = "once";
          tooltip = false;
        };

        "custom/sl_end" = {
          format = " ";
          interval = "once";
          tooltip = false;
        };

        "custom/sr_end" = {
          format = " ";
          interval = "once";
          tooltip = false;
        };

        "custom/rl_end" = {
          format = " ";
          interval = "once";
          tooltip = false;
        };

        "custom/rr_end" = {
          format = " ";
          interval = "once";
          tooltip = false;
        };

        "custom/padd" = {
          format = "  ";
          interval = "once";
          tooltip = false;
        };

      };
    };
}
