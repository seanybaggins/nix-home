{
  inputs,
  pkgs,
  lib,
  ...
}:
{

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "nix-2.16.2"
  ];

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  users.users.sean = {
    isNormalUser = true;
    home = "/home/sean";
    description = "Sean Link";
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "docker"
      "storage"
    ];
    shell = pkgs.zsh;
  };
  #nix.gc = {
  #  automatic = true;
  #  dates = "weekly";
  #  options = "--delete-older-than 15d";
  #};
  services.udev.packages = with pkgs; [
    trezor-udev-rules
    zsa-udev-rules
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="199e", ATTR{idProduct}=="9410", MODE="0660", GROUP="video"
  '';

  services.xserver.desktopManager.gnome.enable = true;
  programs.ssh.askPassword = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";

  services.xserver.displayManager = {
    setupCommands = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --rotate right
    '';
    sddm = {
      enable = true;
    };
  };
  virtualisation.docker.enable = true;

  # For virt-manager
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  # for a WiFi printer
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.avahi.openFirewall = true;

  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    firefox
    curl
    git
    wget
    udiskie
    breezy-desktop
  ];
  hardware.bluetooth.enable = true;
  networking.networkmanager.enable = true;
  time.timeZone = "America/Denver";
  services.xserver.xkbOptions = "caps:escape";
  services.xserver.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;
  swapDevices = [
    {
      device = "/swapfile";
      size = 1024;
    }
  ];

  # Enable binfmt emulation of aarch64-linux.
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  services.syncthing = {
    enable = true;
    user = "sean";
    dataDir = "/home/sean";
  };

  # Allow the SD card to be discovered from the gamespoce UI
  #users.groups.storage = { };
  #services.udisks2.enable = true;
  #services.udisks2.mountOnMedia = true;
  #systemd.services.udiskie = {
  #  description = "Udiskie Automount Service";
  #  wantedBy = [ "paths.target" ];
  #  #after = [ "graphical-session-pre.target" ];
  #  #partOf = [ "graphical-session.target" ];
  #  serviceConfig = {
  #    ExecStart = "${pkgs.udiskie}/bin/udiskie --no-file-manager --no-notify";
  #    Restart = "always";
  #    #User = "sean";
  #  };
  #};
  #environment.etc."polkit-1/rules.d/50-udiskie.rules".text = ''
  #  polkit.addRule(function(action, subject) {
  #    var YES = polkit.Result.YES;
  #    var permission = {
  #      // required for udisks1:
  #      "org.freedesktop.udisks.filesystem-mount": YES,
  #      "org.freedesktop.udisks.luks-unlock": YES,
  #      "org.freedesktop.udisks.drive-eject": YES,
  #      "org.freedesktop.udisks.drive-detach": YES,
  #      // required for udisks2:
  #      "org.freedesktop.udisks2.filesystem-mount": YES,
  #      "org.freedesktop.udisks2.encrypted-unlock": YES,
  #      "org.freedesktop.udisks2.eject-media": YES,
  #      "org.freedesktop.udisks2.power-off-drive": YES,
  #      // required for udisks2 if using udiskie from another seat (e.g. systemd):
  #      "org.freedesktop.udisks2.filesystem-mount-other-seat": YES,
  #      "org.freedesktop.udisks2.filesystem-unmount-others": YES,
  #      "org.freedesktop.udisks2.encrypted-unlock-other-seat": YES,
  #      "org.freedesktop.udisks2.encrypted-unlock-system": YES,
  #      "org.freedesktop.udisks2.eject-media-other-seat": YES,
  #      "org.freedesktop.udisks2.power-off-drive-other-seat": YES
  #    };
  #    if (subject.isInGroup("storage")) {
  #      return permission[action.id];
  #    }
  #  });
  #'';

  # Enable touchpad support
  services.xserver.libinput.enable = true;

  imports = [
    "${inputs.jovian}/modules"
    # Generated using nixos-generate-config --show-hardware-config
    ../machines/steamdeck/hardware-configuration.nix
  ];

  jovian = {
    steam.enable = true;
    devices.steamdeck.enable = true;
  };

  system.stateVersion = "25.05";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "sean-steamdeck";
  boot.initrd.availableKernelModules = lib.mkAfter [
    "usb_storage"
    "sd_mod"
  ];
}
