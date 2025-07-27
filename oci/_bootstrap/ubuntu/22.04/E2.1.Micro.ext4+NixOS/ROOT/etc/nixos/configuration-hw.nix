# oci/VM.Standard.E2.1.Micro.ext4.exUbuntu22.04
# Ubuntu 22.04.1 LTS + nixos-infect 22.11 (bca605ce2c91bc4d79bf8afaa4e7ee4fee9563d4)
#
# NOTE: Ubuntu disk layout is good enough, ext4 fs

# Device      Start      End  Sectors  Size Type
# /dev/sda1  227328 97677278 97449951 46.5G Linux filesystem
# /dev/sda14   2048    10239     8192    4M BIOS boot
# /dev/sda15  10240   227327   217088  106M EFI System

{ config, lib, pkgs, modulesPath, ... }:

{
  # change this only after NixOS release notes say you should.
  system.stateVersion = lib.mkDefault "22.11";

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" ];
  boot.initrd.kernelModules = [ "nvme" ];

  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  imports = [ 
    (modulesPath + "/profiles/qemu-guest.nix")
    ./hw/boot/grub.nix

    ./hw/memory/zram.nix
    ./hw/memory/low.nix

    ./hw/networking/dhcp-eth0.nix  
    ./hw/networking/sshd.nix
  ];

  # ==========================================================
  # default layout derived from lustrated Ubuntu 22.04-slim
  # modified to be more generic by-label rather than by-uuid
  
  fileSystems."/boot" = { device = "/dev/disk/by-label/UEFI"; 
                          fsType = "vfat"; };
  fileSystems."/"     = { device = "/dev/sda1"; 
                          fsType = "ext4"; };
}
