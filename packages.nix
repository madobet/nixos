{ pkgs }:
# NixPkgs:
with pkgs; [
  (pkgs.lib.hiPrio pkgs.whois)
  (yarn.override { nodejs = nodejs-10_x; })
  (python3Full.withPackages (p: with p; [ setuptools pip ]))

  zh-filename-fixer

  alacritty
  # alsa
  anki
  ark
  bat
  bind
  binutils
  cloc
  chromium
  direnv
  ffmpeg-full
  file
  git
  gwenview
  hexchat
  hmcl
  j
  jq
  kdeconnect
  libarchive
  libreoffice
  lrzsz
  mathematica
  nodejs-10_x
  obs-studio
  okular
  p7zip
  patchelf
  python27Packages.percol
  pciutils
  pinta
  socat
  spectacle
  sqliteInteractive
  stack
  shadowsocks-libarchive
  tdesktop
  telnet
  tree
  usbutils
  vlc
  vscode
]