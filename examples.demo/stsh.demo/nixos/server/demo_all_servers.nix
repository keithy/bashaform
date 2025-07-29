{ config, lib ... }:

{
    imports = [
        ../box/function/findAllNixFiles.nixf lib ../demo/all_servers
    ];
}
