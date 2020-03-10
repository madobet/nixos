{ configs, pkgs, ... }:

{
  # 启动测试用 http 服务器
  services.httpd = {
    enable = true;
    adminAddr = "verniy@tooko.ai";
    documentRoot = "${pkgs.valgrind.doc}/share/doc/valgrind/html";
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}