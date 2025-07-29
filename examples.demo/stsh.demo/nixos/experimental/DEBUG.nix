#. ## Fully freeform option for debugging/reporting
#.
#. As a module is evolving, and for debugging, a fully freeform
#. config entry lets you see whatever is the result,
#. like a poor man's variable watch.
#. we check the result after a build. (also REPORT.nix)
#.
#. `nixos-rebuild build; nixos-option debug`
#< p

{ config, options, pkgs, lib, ... }: 

with  pkgs.lib; {
    options.debug = 
        mkOption {
            default = {};
            description = "Watching Expressions";
            type = types.submodule { freeformType = types.anything; };
        };

    config.debug = { };

    config.environment.interactiveShellInit = ''
        alias D="sudo nixos-option debug | sed -n '/Value:/,/Default:/{//!p}'"
    '';
}
