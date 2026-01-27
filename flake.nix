{
  description = "A nix-flake-based rocq development environment with iris";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachSystem
      [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ]
      (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        {
          devShells.default = pkgs.mkShell {
            packages = (
              (with pkgs.coqPackages_8_20; [
                coq
                iris
                serapi
              ])
              ++ (with pkgs; [ python312Packages.alectryon ])
            );
          };
        }
      );
}
