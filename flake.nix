{
  description = "An implementation of Nix in Zig";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-24.11";
    flake-utils.url = "github:numtide/flake-utils";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    zig = {
      url = "github:mitchellh/zig-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs-stable";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "";
      };
    };

    zig2nix = {
      url = "github:jcollie/zig2nix?ref=c311d8e77a6ee0d995f40a6e10a89a3a4ab04f9a";
      inputs = {
        nixpkgs.follows = "nixpkgs-stable";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = {
    self,
    nixpkgs-unstable,
    nixpkgs-stable,
    zig,
    zig2nix,
    ...
  }:
    builtins.foldl' nixpkgs-stable.lib.recursiveUpdate {} (
      builtins.map (
        system: let
          pkgs-stable = nixpkgs-stable.legacyPackages.${system};
          pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
        in {
          devShell.${system} = pkgs-stable.callPackage ./dev/shell.nix {
            zig = zig.packages.${system}."0.13.0";
            inherit zig2nix;
          };

          packages.${system} = let
            mkArgs = optimize: {
              inherit optimize;

              revision = self.shortRev or self.dirtyShortRev or "dirty";
            };
          in rec {
            deps = pkgs-stable.callPackage ./build.zig.zon.nix {};
            malum-debug = pkgs-stable.callPackage ./nix/package.nix (mkArgs "Debug");
            malum-releasesafe = pkgs-stable.callPackage ./nix/package.nix (mkArgs "ReleaseSafe");
            malum-releasefast = pkgs-stable.callPackage ./nix/package.nix (mkArgs "ReleaseFast");

            malum = malum-releasefast;
            default = malum;
          };

          formatter.${system} = pkgs-stable.alejandra;
        }
        # Our supported systems are the same supported systems as the Zig binaries.
      ) (builtins.attrNames zig.packages)
    )
    // {
      overlays = {
        default = self.overlays.releasefast;
        releasefast = final: prev: {
          malum = self.packages.${prev.system}.malum-releasefast;
        };
        debug = final: prev: {
          malum = self.packages.${prev.system}.malum-debug;
        };
      };
    };

  nixConfig = {
    extra-substituters = ["https://malum.cachix.org"];
    extra-trusted-public-keys = [];
  };
}
