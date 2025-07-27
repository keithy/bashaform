# oci/VM.Standard.A1.Flex.nix

{ config, lib, pkgs, modulesPath, ... }:

{
  # change this only after NixOS release notes say you should.
  system.stateVersion = lib.mkDefault "22.11";

  imports = [ 
    (modulesPath + "/profiles/qemu-guest.nix")
    ./hw/networking/dhcp-eth0.nix  
    ./hw/memory/zram.nix
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "virtio_pci" "usbhid" ];
  boot.initrd.kernelModules = [ ];
  
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  boot.cleanTmpDir = true;
   
}
