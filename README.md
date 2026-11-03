# ojuny-test-flakes

Standalone flakes that test the install paths of the Ojuny desktop modules.
Each example pins its own inputs, configures Stylix with the
everforest-dark-hard theme, and targets `x86_64-linux`. The three examples cover
a standalone Home Manager install, Home Manager on NixOS, and the NixOS module.

## Status

Untested. No version is stated and no run is recorded for this page. The
examples use the `github:ojuny-project/ojuny-desktop` input and their own
`flake.lock` files.

## Requirements

- Nix with `experimental-features = nix-command flakes`.
- `x86_64-linux`; each flake hardcodes that system.
- Network access for the flake inputs and for the build.
- `home-manager` on `PATH` for the standalone Home Manager switch.
- For the NixOS examples, an existing machine whose disk layout matches the
  placeholder `/dev/disk/by-label/nixos`, or an edit to that path first.

Disk, memory, and GPU requirements are not stated.

## Install

Clone the repository and enter it:

```console
$ git clone https://github.com/ojuny-project/ojuny-test-flakes
$ cd ojuny-test-flakes
```

Check all three examples:

```console
$ ./scripts/check-all.sh
=== checking other-distro-home-manager ===
=== checking nixos-home-manager ===
=== checking nixos-module ===
```

Expected: each `nix flake check` exits 0. The script uses `set -e`, so the first
failure stops the run.

Build one output directly:

```console
$ nix build ./other-distro-home-manager#homeConfigurations.user.activationPackage
$ nix build ./nixos-home-manager#nixosConfigurations.ojuny-hm.config.system.build.toplevel
$ nix build ./nixos-module#nixosConfigurations.ojuny-module.config.system.build.toplevel
```

Each command writes a `result` symlink. `readlink -f result` prints the store
path of the activation package or the NixOS system closure.

## Usage

Apply the standalone Home Manager example on an existing Linux installation:

```console
$ home-manager switch --flake ./other-distro-home-manager#user
```

Apply a NixOS example:

```console
$ sudo nixos-rebuild switch --flake ./nixos-home-manager#ojuny-hm
$ sudo nixos-rebuild switch --flake ./nixos-module#ojuny-module
```

Expected: a new Home Manager or system generation. These paths are not verified
on this page.

To test a local ojuny-desktop checkout, override the input. Run this from the
repository root and adjust the path:

```console
$ nix build ./nixos-module#nixosConfigurations.ojuny-module.config.system.build.toplevel \
    --override-input ojuny-desktop path:../ojuny-desktop
```

Add `--override-input stylix path:../stylix` to test a local Stylix checkout at
the same time.

`nixos-home-manager` configures Stylix at both levels, sets
`stylix.homeManagerIntegration.autoImport = false`, and imports
`stylix.homeModules.stylix` in the user configuration to avoid recursion with
the default wallpaper.

## Limits

The user is `user` with home `/home/user` and password `test`. The root
filesystem is the placeholder `/dev/disk/by-label/nixos`. Both NixOS examples
use systemd-boot and a single `/` filesystem.

The NixOS Home Manager example configures the user environment only and adds no
display manager or Wayland session. The NixOS module example gets a session from
the Ojuny module but still assumes an existing display manager. No settings GUI,
template setup, installer ISO, `nix run`, virtual machine test, secrets, or
hardware configuration is included.

## Documentation

- [scripts/check-all.sh](scripts/check-all.sh) shows the check loop and its paths.
- [other-distro-home-manager/flake.nix](other-distro-home-manager/flake.nix) shows the standalone Home Manager wiring.
- [nixos-home-manager/configuration.nix](nixos-home-manager/configuration.nix) shows the Stylix integration on NixOS.
- [nixos-module/configuration.nix](nixos-module/configuration.nix) shows the NixOS module inputs.

## Contributing

Open issues at <https://github.com/ojuny-project/ojuny-test-flakes/issues>. A patch
must run `./scripts/check-all.sh` and state which example and commit it was
tested on. Keep each example self-contained with its own lock file.

## License

No license file is present. The repository does not state reuse terms.
