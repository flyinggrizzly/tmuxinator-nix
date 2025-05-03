{ lib, pkgs, ... }:
let
  inherit (lib)
    types
    mkOption
    ;

  transformWindows =
    windows:
    (map (window: {
      ${window.name} = removeAttrs window [ "name" ];
    }))
      windows;

  compact =
    project:
    lib.filterAttrsRecursive (name: value: if name == "windows" then true else value != null) project
    // {
      windows = transformWindows project.windows;
    };
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
          type = types.nullOr types.str;
          default = null;
          description = "Root directory of the tmux window";
        };
        layout = mkOption {
          # Expectation is to use utilities.constants.tmuxLayouts, but they all resolve to string and allowing
          # arbitrary values also permits custom layout strings from e.g. `% tmux list-windows`
          type = types.nullOr types.str;
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
        root = mkOption {
          type = types.str;
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
    projects = types.attrsOf project;
  };

  prepareDefinition = name: project: { inherit name; } // (compact project);
}
