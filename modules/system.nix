{ config, pkgs, ... }:

{
  # 测试能否解决无线网卡驱动问题
  hardware.enableAllFirmware = true;

  # Select internationalisation properties.
  i18n = { 
    # consoleFont = "Lat2-Terminus16";  # 默认值
    consoleColors = [
      "544b49"
      "a55344"
      "a8b55e"
      "e3b27d"
      "6d94c4"
      "6a6dac"
      "00b8b4"
      "fde2c9"
      "6c524b"
      "f7ac90"
      "91dc84"
      "e7c5a4"
      "bad5e2"
      "897ed8"
      "4fdad5"
      "fdf2e4"
    ];
    consoleKeyMap = "us";

    # List of additional packages that provide console fonts,
    # keymaps and other resources.
    # consolePackages = with pkgs.kbdKeymaps; [ dvp neo ];

    # 太强了，让控制台也有 xkb 的布局！
    consoleUseXkbConfig = true;

    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      # enabled = "fcitx";
      enabled = "ibus";
      fcitx.engines = with pkgs.fcitx-engines; [ anthy cloudpinyin libpinyin rime ];
      ibus = {
        engines = with pkgs.ibus-engines; [ anthy libpinyin ];
        # panel =
      };
      # uim.toolbar =
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # https://nixos.org/nixos/options.html#powermanagement
  powerManagement = {
    enable = true;

    # 默认 performance
    # cpuFreqGovernor = "powersave";

    # Whether to enable powertop auto tuning on startup
    # PowerTOP 是一个Intel提供的在用户空间、内核和硬件层面的节电工具。它可以监视进程，
    # 并显示哪些进程利用CPU并从空闲状态唤醒它，从而识别具有特殊高功率需求的应用程序。
    powertop.enable = true;

    # 其他可用选项：
    # - 在系统关机或待机或休眠时执行命令？
    # - 在系统开机或从待机/休眠恢复时执行命令？
    # - Commands executed after the system resumes from suspend-to-RAM
  };

  # https://nixos.org/nixos/options.html#switchdocked
  services.logind = {
    # extraConfig =
    # killUserProcesses =
    # lidSwitch = "suspend";
    lidSwitchDocked = "ignore";
    # lidSwitchExternalPower 默认行为和 lidSwitch 一样
    lidSwitchExternalPower = "ignore";
  };

  # 打印机
  services.printing.enable = true;

  # nixpkgs/nixos/modules/services/audio/alsa.nix
  sound = {
    # Whether to enable ALSA sound.
    enable = true;

    # Whether to enable ALSA OSS emulation
    # (with certain cards sound mixing may not work!).
    enableOSSEmulation = true;

    # extraConfig =

    # Whether to enable volume and capture control with keyboard media keys.
    # 默认关闭，因为一般桌面环境都有自己的音量控制
    # 在 minimalistic desktop 环境中你可能会想要启用它
    # 或者work from bare linux ttys/framebuffers.
    # mediaKeys = {
    #   enable = true;
    #   # The value by which to increment/decrement volume on media keys.
    #   # See amixer(1) for allowed values.
    #   # volumeStep = "1";
    # };
  };

  # https://nixos.org/nixos/options.html#hardware.pulseaudio
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

}
