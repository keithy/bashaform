{ config, ... }:

{
    networking.hostName = "honey";

    imports = [
        ./configuration-hw.nix

        ./demo/locale-uk.nix
        ./demo/ice_keys-root.nix
    ];
}
