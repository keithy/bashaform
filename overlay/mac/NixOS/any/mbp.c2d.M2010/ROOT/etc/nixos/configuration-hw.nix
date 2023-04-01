# https://everymac.com/systems/apple/macbook_pro/specs/macbook-pro-core-2-duo-2.4-aluminum-13-mid-2010-unibody-specs.html

{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")

      ./hw/memory/zram.nix
      ./hw/memory/low.nix

      ./hw/server/dont_sleep.nix
      
      ./hw/mac/efibootmgr.nix
      ./hw/mac/on_laptop_ignore_lid.nix

      ./hw/networking/sshd.nix
      ./hw/networking/dhcp-eth0.nix  
      ./hw/networking/wifi.nix
    ];

  boot.initrd.availableKernelModules = [ "ohci_pci" "ehci_pci" "ahci" "firewire_ohci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  # Allow unfree packages (for wireless drivers above)
  nixpkgs.config.allowUnfree = true;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

}
