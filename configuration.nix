# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  environment.pathsToLink = [ "/libexec" ];



  # nixpkgs.config.allowUnfree = true;
  # hardware.opengl.enable = true;
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "console=ttyS0,115200"
    "console=tty1"
    "console=tty2"
  ];
  
  virtualisation.docker.enable = true;

  systemd.network.wait-online.anyInterface = true;
  systemd.network.wait-online.ignoredInterfaces = ["enp5s0"];
  networking.useNetworkd = true;
  networking.useDHCP = false;
  networking.nameservers = ["1.1.1.1" "1.0.0.1"];
  networking.hostName = "mark_nixos"; # Define your hostname.
  networking.wireless.iwd.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.wireless.networks.Mark_wifi_5G.psk = "67680702_mscr";
  # networking.wireless.interfaces = [ "wlp4s0" ];

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  # networking.useDHCP = false;
  # networking.interfaces.enp5s0.useDHCP = true;
  networking.interfaces.wlan0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.openvpn.servers = {
    # Use systemctl start openvpn-markVpn.service
    markVpn = { 
      config = ''config /home/mark/mark_vpn.ovpn''; 
      autoStart = false;
    };  
  };
  services.resolved = {
    domains = ["~."];
    dnssec = "true";
    extraConfig = ''      
      DNSOverTLS=yes
    '';
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autorun = false;             # for manual run
    desktopManager = {
      xterm.enable = false;
    };
    displayManager = {
      startx.enable = true;      # for manual run
      defaultSession = "none+i3";
    };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
        i3blocks
        xclip
      ];
    };
    xkbModel = "microsoft";
    layout = "us,ru(winkeys)";
    xkbOptions = "grp:caps_toggle,grp_led:caps";
    xkbVariant = "winkeys";
    # videoDrivers = [ "nvidia" ];
  };
  

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mark = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    shell="/run/current-system/sw/bin/zsh";
  };

  nix.trustedUsers = ["root" "mark" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    firefox
    htop
    git
    rxvt_unicode

    pciutils
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.zsh.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

