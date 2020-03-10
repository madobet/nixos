{ config, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    ports = [ 22 ];

    # startWhenNeeded = false;

    forwardX11 = true;
    allowSFTP = true;
    permitRootLogin = "yes";

    # sftpFlags = [];

    # Specifies whether remote hosts are allowed to connect to ports forwarded
    # for the client.
    # Server(我) <--> Client（Server forward 给它了一个 port） <--> Remote Hosts
    # gatewayPorts = "no";

    openFirewall = true;  # 自动打开防火墙端口

    # 由 set 组成的 list:
    # listenAddresses = [
    #   { addr = "192.168.3.1"; port = 22; }
    #   { addr = "0.0.0.0"; port = 64022; }
    # ];

    # passwordAuthentication = true;
    # challengeResponseAuthentication = true;

    # NixOS can automatically generate SSH host keys
    # hostKeys = [
    #   { type = "rsa"; bits = 4096; path = "/etc/ssh/ssh_host_rsa_key"; rounds = 100; openSSHFormat = true; }
    #   { type = "ed25519"; path = "/etc/ssh/ssh_host_ed25519_key"; rounds = 100; comment = "key comment"; }
    # ];

    # Files from which authorized keys are read, 但似乎不能是 URL？
    # authorizedKeysFiles = [ "" ];

    # ciphers = [ "" ];

    # macs =
    # logLevel =
    # useDns =
    # extraConfig =
    # moduliFile =
  };
  # networking.firewall.allowedTCPPorts = [ 22 ];
}