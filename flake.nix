{
  description = "Mkdocs environment";

  inputs = {
    nixpkgs      = { url = "github:NixOS/nixpkgs"; };
    flake-utils  = { url = "github:numtide/flake-utils";      inputs.nixpkgs.follows = "nixpkgs"; };
    poetry2nix   = { url = "github:nix-community/poetry2nix"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = inputs@{
    self,
    nixpkgs,
    flake-utils,
    poetry2nix,
    ...
  }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ]
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;

            overlays = [  poetry2nix.overlay ];
          };

          test =     pkgs.poetry2nix.mkPoetryEnv {
            projectDir = ./.;
          };
        in
          {
            devShell = pkgs.mkShell {
              buildInputs = with pkgs; [
                poetry
                test.env
              ];
            };
          });
}
