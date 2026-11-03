{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
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

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "bck-old-file";

  home-manager.users.user = {
    imports = [
      inputs.stylix.homeModules.stylix
      inputs.ojuny-desktop.homeManagerModules.default
    ];

    home.username = "user";
    home.homeDirectory = "/home/user";
    home.stateVersion = "26.05";

    desktop.ojuny.enable = true;
    desktop.ojuny.stylix.enable = true;

    stylix.enable = true;
    stylix.overlays.enable = false;
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
  };

  stylix.enable = true;
  stylix.homeManagerIntegration.autoImport = false;
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
