{ inputs,config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mazuru";
  home.homeDirectory = "/home/mazuru";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

   # Hyprland Start--------------------------------------------------------------------

  programs.kitty.enable = true;
  programs.rofi.enable = true;
  programs.eww.enable = true;
  services.swaync.enable = true;
  services.swww.enable = true;

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
         "$menu" = "rofi --show drun --show-icons";
         
         ## LOOK AN FEEL ##
          general = {
            "gaps_in" = 5;
            "gaps_out" = 20;
            "border_size" = 2;
                "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
                "col.inactive_border" = "rgba(595959aa)";
                "resize_on_border" = true;
                "layout" = "hy3";
          };
          
          decoration = {
            rounding = 5;
              blur = {
               enable = true;
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
          "DP-1, 1920x1080@180, auto, 1.25"
          
          "HDMI-A-1, 1920x1080@60, auto, 1"
          ];
          

          # AUTOSTART AFTER STARTUP #
          #
            "exec-once" = "swaync";

            
       # KEYBINDINGS  #     
    bind =
      [ 
        "$mod, Q, exec, $terminal"
        "$mod, F, exec, firefox"
        "$mod, C, killactive,"
        "$mod, M, exit,"
        "$mod, F1, exec, $menu"
        ", Print, exec, grimblast copy area"
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
      
  };
  
  
   # Linking the hyperland config
   # 
     # home.file.".config/hypr".source = ./hypr;

    # Optional, hint Electron apps to use Wayland:
   home.sessionVariables.NIXOS_OZONE_WL = "1";

  # Hyprland End________________________________________________________________________
  # Github Start------------------------------------------------------------------------

    programs.git= {
      enable = true;
      userName="MD-Maz";
      userEmail = "mdmazuru27@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        safe.directory = "/etc/nixos";
      };
    };
  
  
  # Github End__________________________________________________________________________


    programs.neovim = {
       enable = true;
     };

     programs.helix = {
       
       enable = true;
       defaultEditor = true;
       settings.theme = "merionette";
     };


  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [

    #My programs

      heroic
      bottles
      vesktop
      vencord
      nnn #Terminal file manager

    # archives

      zip
      xz
      unzip
      p7zip

    # utils
      fzf
      eza
      neofetch
      grimblast

    # misc
      file
      which
      tree

    # Nix related
    #
    # It provides the command 'nom' works jsut like 'nix'
    # with more details log output
      nix-output-monitor
      

    # Productivity

      hugo
      glow

      btop
      iotop
      iftop
    # Hyprland programs  
      

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/mazuru/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
