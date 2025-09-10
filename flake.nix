{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    systems.url = "github:nix-systems/default-linux";

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

    walker.url = "github:abenz1267/walker";
  };

  outputs = inputs @ {
    ags,
    astal,
    home-manager,
    hy3,
    hyprland,
    nixpkgs,
    self,
    systems,
    walker,
    ...
  }: let
    inherit (nixpkgs) lib;

    forAllSystems = function:
      nixpkgs.lib.genAttrs (import systems) (system: function nixpkgs.legacyPackages.${system});
  in {
    ### NixOS ###

    nixosConfigurations = {
      "mazuru" = lib.nixosSystem {
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

    nixosModules = rec {
      default = elephant;
      elephant = import ./nix/modules/nixos.nix self;
    };

    ### Home-Manager ###

    homeModules = rec {
      default = elephant;
      elephant = import ./nix/modules/home-manager.nix self;
    };

    ### Packages Stuff ###

    formatter = forAllSystems (pkgs: pkgs.alejandra);

    devShells = forAllSystems (pkgs: {

      ags = pkgs.callPackage /etc/nixos/.shells/ags.nix {inherit self;};
      
      elephant = pkgs.callPackage /etc/nixos/.shells/elephant.nix {inherit self;};
    });

    packages = forAllSystems (pkgs: {

      # AGS Package
      ags = pkgs.callPackage /etc/nixos/.pakages/ags.nix {};

      # Main elephant binary
      elephant = pkgs.callPackage /etc/nixos/.pakages/elephant.nix {};

      # Providers package - builds all providers with same Go toolchain
      elephant-providers = pkgs.callPackage /etc/nixos/.pakages/elephant-providers.nix {};

      # Combined package with elephant + providers
      elephant-with-providers = pkgs.callPackage /etc/nixos/.pakages/elephant-with-providers.nix {};

    });
  };
}
