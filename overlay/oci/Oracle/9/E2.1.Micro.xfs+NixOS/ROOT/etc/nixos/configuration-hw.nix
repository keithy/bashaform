# oci/VM.Standard.E2.1.Micro.xfs.exOracle9
# Oracle-Linux-8.6-2022.12.15-0 + nixos-infect 22.11 (bca605ce2c91bc4d79bf8afaa4e7ee4fee9563d4)
#
# NOTE: Oracle 9 disk layout wastes 15G as reserved space for diagnostic data
# Include a script to reclaim it.
# https://community.oracle.com/customerconnect/discussion/656453/oci-what-is-the-ocivolume-oled-volume-mounted-on-var-oled-filesystem

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
  # default layout derived from lustrated Oracle 9
  # modified to be more generic by-label rather than by-uuid

  fileSystems."/boot" = { device = "/dev/disk/by-partlabel/EFI\\x20System\\x20Partition"; fsType = "vfat"; };
  fileSystems."/" = { device = "/dev/mapper/ocivolume-root"; fsType = "xfs"; };

  # Prefer not to waste the oled volume, but nixos-infect does not adopt it or install /nix to it
  # fileSystems."/nix" = { device = "/dev/mapper/ocivolume-oled"; fsType = "xfs"; };
  # Instead here is a script to extend the existing volume

  environment.systemPackages = [ 
    (pkgs.writeScriptBin "oracle_reclaim_oled.sh" (''
      #! /usr/bin/env bash

      lvremove ocivolume/oled
      lvextend /dev/ocivolume/root -l +100%FREE --resizefs
      
      ''))  
  ];
}

# Device       Start      End  Sectors  Size Type
# /dev/sda1     2048   206847   204800  100M EFI System
# /dev/sda2   206848  4401151  4194304    2G Linux filesystem
# /dev/sda3  4401152 97675263 93274112 44.5G Linux LVM

# Disk /dev/mapper/ocivolume-root: 29.47 GiB, 31646023680 bytes, 61808640 sectors
# Units: sectors of 1 * 512 = 512 bytes
# Sector size (logical/physical): 512 bytes / 4096 bytes
# I/O size (minimum/optimal): 4096 bytes / 1048576 bytes

# Disk /dev/mapper/ocivolume-oled: 15 GiB, 16106127360 bytes, 31457280 sectors
# Units: sectors of 1 * 512 = 512 bytes
# Sector size (logical/physical): 512 bytes / 4096 bytes
# I/O size (minimum/optimal): 4096 bytes / 1048576 bytes