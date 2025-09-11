{inputs, pkgs, ...}: {


wayland.windowManager.hyprland = {
    # allow home manager to configure hyprland
      enable = true;
      systemd.enable= true;

      plugins = [
        inputs.hyprland-plugins.packages."${pkgs.system}".hyprbars
        inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
        inputs.hy3.packages.x86_64-linux.hy3

      ];

      settings = {

        # MY PROGRAMS #
        # 
         "$mod" = "SUPER";
         "$terminal" = "kitty";
         "$fileManager" = "dolphin";
         "$menu" = "walker";
         
         ## LOOK AN FEEL ##
          general = {
            "gaps_in" = 5;
            "gaps_out" = 20;
            "border_size" = 2;
                "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
                "col.inactive_border" = "rgba(595959aa)";
                "resize_on_border" = true;
                layout = "hy3";
          };
          
          decoration = {
            rounding = 5;
              blur = {
               enabled = true;
               size = 7;
               passes = 4;
               noise = "0.008";
               contrast = "0.891";
               brightness = "0.8";
                 "input_methods" = "yes";
            };
            shadow = {
              enabled = false;
            };
          };

          animations = {
               enabled = "yes";
		             "first_launch_animation" = "no";

                bezier = [
                  
                 "windowIn, 0.06, 0.71, 0.25, 1"
                "windowResize, 0.04, 0.67, 0.38, 1"
	              "workspacesMove, 0.1, 0.75, 0.15, 1"
	              	];

                animation = [
                "windowsIn, 1, 3, windowIn, slide" #popin 20%
              "windowsOut, 1, 3, windowIn, slide" #popin 70%
            "windowsMove, 1, 2.5, windowResize"
          "fade, 1, 3, default"
        "workspaces, 1, 4, workspacesMove, slidevert"
	  	"layers, 1, 4, windowIn, slide"
	  	];
   };

         

         # MONITOR SETUP #
         # 
         monitor = [
          "DP-1, 1920x1080@180, auto, 1"
          
          "HDMI-A-1, 1920x1080@60, auto, 1"
          ];
          

          # AUTOSTART AFTER STARTUP #
          #
            "exec-once" = [
              "swaync"
              "elephant"
              "walker --gapplication-service"
              ];

            
       # KEYBINDINGS  #
        bindm = [
          
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];

          
    bind =
      [ 
        "$mod, Q, exec, $terminal"
        "$mod, F, exec, firefox"
        "$mod, C, killactive,"
        "$mod, SHIFT_F4, forcekillactive,"
        "$mod, M, exit,"
        # "$mod, TAB, hyprexpo:expo, toggle"
        "$mod, F10, fullscreen,"
        "$mod, F1, exec, $menu"
        "$mod, F2, exec, $fileManager"
        "$mod, F3, togglefloating,"
        ", Print, exec, grimblast copy area"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      );
        
    };
    extraConfig = ''
  plugin = ${pkgs.hyprlandPlugins.hy3}/lib/libhy3.so

     # hyprexpo {
     #   "columns" = "3"
     #   "gap_size" = "5"
     #   "bg_col" = "rgb(111111)""
     #   "workspace_method" = "center current"
     # };


  
'';
      
  };
  
   # Linking the hyperland config
   # 
     # home.file.".config/hypr".source = ./hypr;

    # Optional, hint Electron apps to use Wayland:
   home.sessionVariables.NIXOS_OZONE_WL = "1";

   }
