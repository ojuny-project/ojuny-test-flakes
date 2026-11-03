{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.ojuny-desktop.nixosModules.default
    inputs.stylix.nixosModules.stylix
  ];

  system.stateVersion = "26.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  users.users.user = {
    isNormalUser = true;
    initialPassword = "test";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "input"
    ];
  };

  desktop.ojuny.enable = true;
  desktop.ojuny.stylix.enable = true;

  stylix.enable = true;
  stylix.polarity = "dark";
  stylix.image = "${inputs.ojuny-desktop.outPath}/lib/wallpapers/preset-default.png";
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";

  stylix.fonts.monospace.name = "CaskaydiaCove Nerd Font";
  stylix.fonts.monospace.package = pkgs.nerd-fonts.caskaydia-cove;
  stylix.fonts.sansSerif.name = "CaskaydiaCove Nerd Font";
  stylix.fonts.sansSerif.package = pkgs.nerd-fonts.caskaydia-cove;
  stylix.fonts.serif.name = "CaskaydiaCove Nerd Font";
  stylix.fonts.serif.package = pkgs.nerd-fonts.caskaydia-cove;

  stylix.icons.enable = true;
  stylix.icons.dark = "Papirus-Dark";
  stylix.icons.light = "Papirus-Light";
  stylix.icons.package = pkgs.papirus-icon-theme;

  stylix.cursor.name = "Bibata-Modern-Classic";
  stylix.cursor.package = pkgs.bibata-cursors;
  stylix.cursor.size = 24;
}
