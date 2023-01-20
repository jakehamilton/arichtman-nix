{ lib, pkgs, ... }:
{
  networking.hostName = "bruce-banner";

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "nixos";
    startMenuLaunchers = true;

    # Enable native Docker support
    docker-native.enable = true;
  };

  virtualisation.docker = {
    autoPrune.enable = true;
    enable = true;
    rootless.enable = true;
    rootless.setSocketVariable = true;
  };
  time.timeZone = "Australia/Brisbane";

  services.ntp = {
    enable = true;
    servers = [
      "pool.ntp.org"
    ];
  };
  #Enable nix flakes
  # TODO: Use this or the nix.extraOptions?
  nix.package = pkgs.nixFlakes;

  # Set system packages
  environment.systemPackages = with pkgs; [
    wget
    git
    home-manager
  ];
  users.users.nixos = {
    extraGroups = [ "docker" "wheel" ];
    isNormalUser = true;
  };

  # Enable VSCode server fixer service
  services.vscode-server.enable = true;

  # Enable unfree packages (for vscode stuff)
  nixpkgs.config.allowUnfree = true;

  # Enable flakes and CLI v3
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  nix.settings.auto-optimise-store = true;
  # TODO: Should we set this both here _and_ in home-manager?
  # TODO: Will using unstable/master nixpkgs/h-m have any affects with this?
  system.stateVersion = "22.11";

}