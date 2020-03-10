{ config, pkgs, ... }:

{
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    layout = "us";
    xkbOptions = "eurosign:e";
    # xkbOptions = "terminate:ctrl_alt_bksp,caps:ctrl_modifier";

    fonts.fonts = with pkgs; [
      iosevka-bin
      sarasa-gothic
      noto-fonts-emoji
      noto-fonts-cjk
      powerline-fonts
    ];

    # 不创建目录链接有一些程序可能会找不到字体？
    fonts.enableFontDir = true;

    fonts.fontconfig.defaultFonts = {
      monospace = [ "Iosevka Term" "Sarasa Term SC" ];
      sansSerif = [ "Sarasa Gothic SC" "Noto Sans CJK SC" ];
      serif = [ "Noto Serif CJK SC" "Sarasa Gothic SC" ];
      emoji = [ "Noto Color Emoji" ];
    };

    # Enable touchpad support.
    libinput.enable = true;

    # KDE 5 桌面环境
    # displayManager.sddm = {
    #   enable = true;
    #   extraConfig = ''
    #     [X11]
    #     ServerArguments=-nolisten tcp -dpi 144
    #     MinimumVT=1
    #   '';
    # };
    # desktopManager.plasma5.enable = true;

    # i3-gaps
    services.xserver.windowManager = {
        i3-gaps.enable = true;
        default = "i3-gaps";
    };
  };
}
