# 以下内容覆盖 Acer 的 /etc/nixos/configuration.nix 即可作为本地配置使用
# 和设备、硬件强关联的内容写在此处，其他模块化共享
# 再 nixos-rebuild switch
{ config, pkgs, ... }:
{
  # 允许非自由软件
  nixpkgs.config.allowUnfree = true;

  # imports 是个特殊的 list？内置命令？
  # 整个函数？里只能用一次
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../modules/boot.nix
    ../modules/system.nix
    ../modules/openssh.nix
    ../modules/graphical.nix
    ../modules/printing.nix
    ../modules/test-http.nix
    ../modules/samba.nix
  ];

  # Use the systemd-boot EFI boot loader.
  # boot set（或者说对象）的 loader set 的 systemd-boot 的 enable 布尔变量的值是 true
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "acer"; # Define your hostname.
  # Acer 的无线缺少驱动
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp4s0f0.useDHCP = true;
  # networking.interfaces.wlp3s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  networking.proxy.default = "http://192.168.8.23:1913/";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # 对于 SSD 可以用这个：
  # services.fstrim = {
  #   enable = true;
  #   interval = "tuesday";  
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget curl vim git
    zsh
    htop
    chromium firefox
    # firefox*-bin versions do *not* work with browserpass.
    # If you require such Firefox versions,
    # use the stateful setup described below.
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  programs.browserpass.enable = true;
  # browserpass 有一个麻烦的地方，装完以后还要手动 make 一下：
  # $ DESTDIR=~/.nix-profile make -f ~/.nix-profile/lib/browserpass/Makefile hosts-chromium-user
  # $ DESTDIR=~/.nix-profile make -f ~/.nix-profile/lib/browserpass/Makefile hosts-firefox-user

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
  # 系统自动更新 https://nixos.org/nixos/manual/#sec-upgrading-automatic
  # system.autoUpgrade.enable = true;

  # 在 systemd 启动后执行的命令
  # 因为是 Stage2 阶段调用的，所以必须在下次重启时才能生效，重新 deploy 不会立即生效
  # boot.postBootCommands = ''
  #  mkdir /tmp/Aha
  # '';

}
