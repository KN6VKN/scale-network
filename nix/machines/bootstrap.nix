{ config, pkgs, ... }:
{
  boot = {
    kernelParams = [ "console=ttyS0,115200n8" ];
    loader.grub.extraConfig = "
    serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1
    terminal_input serial
    terminal_output serial
    ";
  };

  networking = {
    firewall.enable = true;
  };

  systemd.network = {
    netdevs = {
      "10-bond0" = {
        netdevConfig = {
          Kind = "bond";
          Name = "bond0";
        };
        bondConfig = {
          Mode = "802.3ad";
          LACPTransmitRate = "fast";
          TransmitHashPolicy = "layer3+4";
        };
      };
    };
    networks = {
      "30-eno1" = {
        matchConfig.Name = "eno1";
        networkConfig.Bond = "bond0";
      };
      "30-eno2" = {
        matchConfig.Name = "eno2";
        networkConfig.Bond = "bond0";
      };
      "40-eno3" = {
        matchConfig.Name = "eno3";
        networkConfig.Bond = "bond0";
      };
      "50-eno4" = {
        matchConfig.Name = "eno4";
        networkConfig.Bond = "bond0";
      };
      "60-bond0" = {
        matchConfig.Name = "bond0";
        linkConfig = {
          RequiredForOnline = "carrier";
        };
        networkConfig.LinkLocalAddressing = "no";
        networkConfig = {
          DHCP = "ipv4";
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    wget
    git
    vim
  ];

  services.openssh = {
    enable = true;
    openFirewall = true;
  };
}