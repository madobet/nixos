{ config, pkgs, ... }:
# Define a user account. Don't forget to set a password with ‘passwd’
{
  users.users.madobet = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "vboxusers" "docker" "wireshark" ]; # Enable ‘sudo’ for the user.
    packages = pkgs.callPackage ../packages.nix {};
  };
}
