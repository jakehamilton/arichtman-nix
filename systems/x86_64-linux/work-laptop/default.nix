{ lib, pkgs, ... }:

with lib;
{

  networking.hostName = "work-laptop";


  services.yubikey-agent.enable = true;

  # https://github.com/nix-community/NixOS-WSL/issues/185
  systemd.services.nixs-wsl-systemd-fix = {
    description = "Fix the /dev/shm symlink to be a mount";
    unitConfig = {
      DefaultDependencies = "no";
      Before = "sysinit.target";
      ConditionPathExists = "/dev/shm";
      ConditionPathIsSymbolicLink = "/dev/shm";
      ConditionPathIsMountPoint = "/run/shm";
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [
        "${pkgs.coreutils-full}/bin/rm /dev/shm"
        "/run/wrappers/bin/mount --bind -o X-mount.mkdir /run/shm /dev/shm"
      ];
    };
    wantedBy = [ "sysinit.target" "systemd-tmpfiles-setup-dev.service" "sytemd-tmpfiles-setup.service" "systemd-sysctl.service" ];
  };

}