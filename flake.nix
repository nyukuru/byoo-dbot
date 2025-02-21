{
  description = "Yet another general purpose discord bot.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11-small";

  outputs = inputs: let

    # Supported systems, non-exhaustive as of now
    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];

    forAllSystems = func: 
      inputs.nixpkgs.lib.genAttrs 
        systems
        (system: func system inputs.nixpkgs.legacyPackages.${system});

    # Derivation definition
    byoo-dbot = {stdenv, cmake, dpp}: stdenv.mkDerivation {
      pname = "byoo-dbot";
      version = "1.0.0";

      src = ./.;

      buildInputs = [dpp];
      nativeBuildInputs = [cmake];
    };

  in {
    packages = forAllSystems (system: pkgs: {
      # Build command: nix build .
      default = inputs.self.packages.${system}.byoo-dbot;
      byoo-dbot = pkgs.callPackage byoo-dbot {};
    });
  };
}
