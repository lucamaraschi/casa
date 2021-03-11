{
  description = "Home manager for non-nixos system"

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.LS_COLORS = {
    url = "github:trapd00r/LS_COLORS";
    flake = false;
  };

  outputs = { self, ... }@inputs:
  let

    overlays = [
        # nixos-unstable-overlay
        (self: super: {
          opencv4 = super.opencv4.override { enableUnfree = false; enableCuda = false; };
          blender = super.blender.override { cudaSupport = false; };
        })
        inputs.neovim-nightly-overlay.overlay
        (final: prev: { LS_COLORS = inputs.LS_COLORS; })
      ];
    in
    {
      homeConfigurations = {
        mac = inputs.home-manager.lib.homeManagerConfiguration {
          configuration = { pkgs, config, ... }:
            {
              xdg.configFile."nix/nix.conf".source = ./configs/nix/nix.conf;
              nixpkgs.config = import ./configs/nix/config.nix;
              nixpkgs.overlays = overlays;
              imports = [
                ./modules/cli.nix
                ./modules/git.nix
                ./modules/home-manager.nix
                ./modules/neovim.nix
                ./modules/nix-utilities.nix
                ./modules/ssh.nix
              ];
              programs.zsh.initExtra = builtins.readFile ./configs/zsh/mac_zshrc.zsh;
            };
            system = "x86_64-darwin";
            homeDirectory = "/Users/luca";
            username = "luca";
          };
        };
        mac = self.homeConfigurations.mac.activationPackage;
      };
  }
