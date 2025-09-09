{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    hyprland.url = "github:hyprwm/Hyprland";
    
    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

     hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
     hy3 = {
      url = "github:outfoxxed/hy3"; # where {version} is the hyprland release version
      # or "github:outfoxxed/hy3" to follow the development branch.
      # (you may encounter issues if you dont do the same for hyprland)
      inputs.hyprland.follows = "hyprland";
      };
  

  astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.astal.follows = "astal";
    };
  
};
  outputs = inputs@{ nixpkgs, home-manager, hyprland, hy3, ags, astal, ... }: 
    let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    in {

      ####Plugins#####
          packages.${system}.default = pkgs.stdenv.mkDerivation { 
      pname = "my-shell";

      src = ./.;

      nativeBuildInputs = with pkgs; [
        wrapGAppsHook
        gobject-introspection
        ags.packages.${system}.default
      ];

      buildInputs = [
        pkgs.glib
        pkgs.gjs
        astal.io
        astal.astal4
        # packages like astal.battery or pkgs.libsoup_4
      ];

      installPhase = ''
        ags bundle app.ts $out/bin/my-shell
      '';

      preFixup = ''
        gappsWrapperArgs+=(
          --prefix PATH : ${pkgs.lib.makeBinPath ([
            # runtime executables
          ])}
        )
      '';
    };
    
    nixosConfigurations = {

      mazuru = nixpkgs.lib.nixosSystem {
        
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        
    
       ####MODULES#### 
        modules = [
          ./configuration.nix

          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            # home-manager.specialArgs = {inherit hy3;};
            home-manager.users.mazuru = import ./home.nix;


          }
        ];
      };
    };
  };
}
