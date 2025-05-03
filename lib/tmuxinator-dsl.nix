{ lib, pkgs, ... }:
let
  inherit (lib)
    types
    mkOption
    ;
in
{
  types = rec {
    window = types.submodule {
      options = {
        name = mkOption {
          type = types.str;
          description = "Name of the tmux window";
        };
        root = mkOption {
          type = types.nullOr types.string;
          default = null;
          description = "Root directory of the tmux window";
        };
        layout = mkOption {
          # Expectation is to use utilities.constants.tmuxLayouts, but they all resolve to string and allowing
          # arbitrary values also permits custom layout strings from e.g. `% tmux list-windows`
          type = types.nullOr types.string;
          default = null;
          description = "Tmux layout to use for the window";
        };
        panes = mkOption {
          type = types.nullOr (types.listOf types.str);
          default = null;
          description = "List of commands to run in the tmux window";
        };
      };
    };

    project = types.submodule {
      options = {
        name = mkOption {
          type = types.str;
          description = "Name of the tmuxinator project";
        };
        root = mkOption {
          type = types.string;
          description = "Root directory of the project";
        };
        pre = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Command to run before starting the session";
        };
        post = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Command to run after starting the session";
        };
        startup_window = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Window to focus on startup";
        };
        windows = mkOption {
          type = types.listOf window;
          description = "List of windows to create in the tmux project";
        };
      };
    };
  };

  compact = project: lib.filterAttrsRecursive (n: v: v != null) project;
}
