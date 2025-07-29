{ config, options, lib, ... }: 

with lib; {
    options.report = mkOption {
            default = {};
            description = "System Reports";
            type = types.submodule { freeformType = types.anything; };
    };

    config.report = { };

    config.environment.interactiveShellInit = ''
        alias R="sudo nixos-option report | sed -n '/Value:/,/Default:/{//!p}'"  
    '';
}

# nixos-option is being retired