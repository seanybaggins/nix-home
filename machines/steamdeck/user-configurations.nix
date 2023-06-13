{ ... }:
{
  fileSystems."/home/sean/lightdeck/yocto" = {
    device = "/dev/disk/by-uuid/5c7f8cf8-5613-4ad7-a4b2-62cd963352e2"; 
    fsType = "ext4"; 
    options = [ "nofail" ]; # boot even when the SD card is not present
  };

  # Make sure the yocto user is owned by sean and not root.
  systemd.tmpfiles.rules = [
    "d /home/sean/lightdeck/yocto 0755 sean users - -"
  ];
}
