{ config
, lib
, ...
}: let
  common_settings = {
    blur_passes = 0;
    blur_size = 7;
    noise = 0.0117;
    contrast = 0.8916;
    brightness = 0.8172;
    vibrancy = 0.1696;
    vibrancy_darkness = 0.0;
  };
  primary_monitor = lib.lists.findFirst ({primary, ...}: primary) null config.hostSpec.monitors;
  verify_monitor = lib.throwIfNot (primary_monitor != null) "No primary monitor found.";
in {
  programs.hyprlock.enable = true;
  programs.hyprlock.settings = {
    background = map ({ portName, lockscreen, ... }: {
      monitor = portName;
      path = lockscreen;
    } // common_settings) config.hostSpec.monitors;
    input-field = {
      monitor = verify_monitor primary_monitor;
      size = "200, 50";
      outline_thickness = 3;
      dots_size = 0.33; # Scale of input-field height, 0.2 - 0.8
      dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
      dots_center = false;
      dots_rounding = -1; # -1 default circle, -2 follow input-field rounding
      outer_color = "rgb(151515)";
      inner_color = "rgb(200, 200, 200)";
      font_color = "rgb(10, 10, 10)";
      fade_on_empty = true;
      fade_timeout = 1000; # Milliseconds before fade_on_empty is triggered.
      placeholder_text = "<i>Input Password...</i>"; # Text rendered in the input box when it's empty.
      hide_input = false;
      rounding = -1; # -1 means complete rounding (circle/oval)
      check_color = "rgb(204, 136, 34)";
      fail_color = "rgb(204, 34, 34)"; # if authentication failed, changes outer_color and fail message color
      fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>"; # can be set to empty
      fail_timeout = 2000; # milliseconds before fail_text and fail_color disappears
      fail_transition = 300; # transition time in ms between normal outer_color and fail_color
      capslock_color = -1;
      numlock_color = -1;
      bothlock_color = -1; # when both locks are active. -1 means don't change outer color (same for above)
      invert_numlock = false; # change color if numlock is off
      swap_font_color = false; # see below
      position = "0, -20";
      halign = "center";
      valign = "center";
    };
  };
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "pidof hyprlock || hyprlock";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 150;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
