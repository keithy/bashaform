# oci/VM.Standard.E2.1.Micro.xfs.exOracle7
# Oracle-Linux-7.9-2022.12.15-0 + nixos-infect 22.11 (bca605ce2c91bc4d79bf8afaa4e7ee4fee9563d4)
#
# NOTE: Oracle 7.9 disk layout wastes 8G as swap nixos-infect will try to seamlessly adopt it.

{ config, lib, pkgs, modulesPath, ... }:

{
  # change this only after NixOS release notes say you should.
  system.stateVersion = lib.mkDefault "22.11";

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront"  "vmw_pvscsi"];
  boot.initrd.kernelModules = [ "nvme" ];

  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # ==========================================================

  imports = [ 
    (modulesPath + "/profiles/qemu-guest.nix")
    ./hw/boot/grub.nix

    ./hw/memory/zram.nix
    ./hw/memory/low.nix

    ./hw/networking/dhcp-eth0.nix  
    ./hw/networking/sshd.nix
  ];

  # ==========================================================
  # default layout derived from lustrated Oracle 8
  # modified to be more generic by-label rather than by-uuid
  
  fileSystems."/boot" = { device = "/dev/disk/by-partlabel/EFI\\x20System\\x20Partition"; fsType = "vfat"; };
  fileSystems."/" = { device = "/dev/sda3"; fsType = "xfs"; };
  swapDevices = [ { device = "/dev/sda2"; } ];
}

# NOTE: Oracle 7.9 disk layout 

#         Start          End    Size  Type               Name
# 1         2048       411647    200M  EFI System        EFI System Partition
# 2       411648     17188863      8G  Linux swap      
# 3     17188864     97675263   38.4G  Microsoft basic 