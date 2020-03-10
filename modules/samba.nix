{ config, pkgs, ... }:
# “标准” Samba 服务器
{
  # 必须装一个 samba 软件包，不然没有 smbpasswd ？
  environment.systemPackages = with pkgs; [ samba samba4Full ];

  # 创建一个 samba 私有帐号
  users.users.samba = {
    # 相当于 User's Full Name:
    description = "Samba Private Account managed by NixOps";
    isNormalUser = false;
    isSystemUser = true;
    # 主要属组:
    group = "users";
  };

  # 创建必要的文件夹，第一次创建必须重启，
  # 而且权限位必须设置正确
  # 而且还必须手动 smbpasswd -n -a nobody
  #  -n   用这个选项后跟用户名来把这个账号的口令设为空(也就是没有口令)
  #       程序会把本地smbpasswd文件中该口令项的第一部分改为“NO PASSWORD”
  #
  #       注意如果设置了"NO    PASSWORD"之后，要允许用户以空口令登录到Samba服务器，管理员必须在smb.conf配置文件
  #       的[global]段中设置以下的参数：
  #
  #       null passwords = yes
  #
  #       只有root运行smbpasswd程序时才可以使用这个选项
  #
  boot.postBootCommands = ''
    [ ! -d "/mnt/Shares/Public" ] && mkdir -p "/mnt/Shares/Public"
    smbpasswd -n -a nobody && chown -R nobody:users "/mnt/Shares/Public"
    [ ! -d "/mnt/Shares/Private" ] && mkdir -p "/mnt/Shares/Private"
    chown -R samba:users "/mnt/Shares/Private"
    DEFAULT_PASSWD=samba123
    printf "$DEFAULT_PASSWD\n$DEFAULT_PASSWD" | smbpasswd -a samba -s
  '';
    # smbpasswd -a samba -s << EOF
    # $DEFAULT_PASSWD
    # $DEFAULT_PASSWD
    # EOF

  services.samba = {
    enable = true;
    enableNmbd = true;
    enableWinbindd = true;
    # The `samba` packages comes without cups support compiled in,
    # however `samba4Full` features printer sharing support.
    package = pkgs.samba4Full;
    # 出 bug 了，这个选项暂时没用了，无法自动同步
    # https://github.com/NixOS/nixpkgs/issues/54492
    # syncPasswordsByPam = true;
    # List of users who are denied to login via Samba
    invalidUsers = [ "root" ];
    # extraConfig 相当于 Samba 的 global 段
    extraConfig = ''
      server string = This is a Samba server on NixOS deployed by NixOps
      netbios name = smbnix
      workgroup = WORKGROUP
      # use sendfile = yes
      # max protocol = smb2
      hosts allow = 192.168.0.0/16 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';
    # 相当于 samba 设置里的 security = xxx：
    securityType = "user";
    # nsswins = true;
    shares = {
      # 匿名用户可以读写的目录:
      public = {
        comment = "Public samba share";
        path = "/mnt/Shares/Public";
        # browseable = "yes"; # 默认可见
        writable = "yes";
        public = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "nobody";
        "force group" = "users";
      };
      # 只要通过了用户名密码验证的用户都可以访问的目录:
      private = {
        comment = "Private samba share";
        path = "/mnt/Shares/Private";
        browseable = "yes";
        writable = "yes";
        public = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "samba";
        "force group" = "users";
      };
      # 只有每个用户自己可以访问的家目录，但 samba 用户不可
      homes = {
        comment = "Home Directories";
        browseable = "no";
        writable = "yes";
        "invalid users" = "samba";
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 445 139 ];
  networking.firewall.allowedUDPPorts = [ 137 138 ];
}
