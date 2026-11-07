{
  description = "Ojuny test flakes";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      source = nixpkgs.lib.cleanSource ./.;
    in
    {
      apps = forAllSystems (system: {
        ci = {
          type = "app";
          program = "${
            nixpkgs.legacyPackages.${system}.writeShellApplication {
              name = "ci";
              runtimeInputs = [ nixpkgs.legacyPackages.${system}.nix ];
              text = ''
                exec nix flake check "$@"
              '';
            }
          }/bin/ci";
        };
      });

      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          examples = pkgs.runCommand "check-test-flakes" { } ''
            for example in other-distro-home-manager nixos-home-manager nixos-module; do
              test -f ${source}/$example/flake.nix
              test -f ${source}/$example/flake.lock
            done
            test -x ${source}/scripts/check-all.sh
            touch $out
          '';

          default = self.checks.${system}.examples;
        }
      );

      hydraJobs = forAllSystems (system: self.checks.${system});
    };
}
