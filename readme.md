# tmuxinator-nix

A home-manager (required!) module for managing tmuxinator configs.

## Installation

```
# flake.nix

{
  inputs = {
    # Requires home-manager atm
    home-manager.url = "github:nix-community/home-manager";

    tmuxinator.url = "github:flyinggrizzly/tmuxinator-nix";
  };
  outputs = {
    { tmuxinator, ... }@inputs:
    {
      config.programs.tmuxinator = {
        enable = true;
        rubyPackage = null; # use ruby provided elsewhere in the flake or system
        projects = {
          projectName = {
            root = "~/";
            windows = [
            {
              name = "my-cool-window";
              root = "~/window-root";
              layout = inputs.tmuxinator.lib.constants.layouts.wideRightMainVertical;
            }
            { name = "scratch"; }
            ];
          };
        };
      };
    };
  };
}
```
