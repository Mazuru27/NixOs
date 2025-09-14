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
  imports = [inputs.walker.homeManagerModules.default
    inputs.ags.homeManagerModules.default
    ./hyprland/hypr.nix
    ./hyprland/hyprPanel.nix
  ];
  # programs.rofi.enable = false;
  # programs.eww.enable = true;
  # services.swaync.enable = true;
  services.swww.enable = true;
  # programs.mpvpaper.enable = true;
    programs.ags.enable = true;

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
  ################# WALKER ####################
     programs.walker = {
  enable = true;
  runAsService = true;

  # All options from the config.toml can be used here.
  config = {
    placeholders."default".input = "Example";
    providers.prefixes = [
      {provider = "websearch"; prefix = "+";}
      {provider = "providerlist"; prefix = "_";}
    ];
    keybinds.quick_activate = ["F1" "F2" "F3"];
  };

  # If this is not set the default styling is used.
  theme.style = ''
    * {
      color: #dcd7ba;
    }
  '';
};
######################## END ########################

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
