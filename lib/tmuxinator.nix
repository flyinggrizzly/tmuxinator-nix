{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    types
    mkOption
    mkIf
    mkEnableOption
    mapAttrs'
    ;

  dsl = import ./tmuxinator-dsl.nix { inherit lib pkgs; };

  toArray =
    elementOrElements:
    if builtins.isList elementOrElements then elementOrElements else [ elementOrElements ];

  listIf = condition: element: if condition then toArray element else [ ];

  yamlFormat = pkgs.formats.yaml { };

  generateYaml =
    name: project:
    yamlFormat.generate "tmuxinator-nix--projects--project-${name}.yml" (dsl.prepareDefinition name project);

  cfg = config.programs.tmuxinator;
in
{
  options.programs.tmuxinator = {
    enable = mkEnableOption "Enable tmuxinator configuration";

    projects = mkOption {
      type = dsl.types.projects;
      default = [ ];
      description = "Tmuxinator project layout definitions";
    };

    package = mkOption {
      type = types.nullOr types.package;
      default = pkgs.tmuxinator;
      description = "Tmuxinator package to use. Set to null to use an external tmuxinator.";
    };

    rubyPackage = mkOption {
      type = types.nullOr types.package;
      default = pkgs.ruby;
      description = "Ruby package to use for tmuxinator. Set to null to use an external ruby.";
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      listIf (cfg.package != null) cfg.package
      ++ listIf (cfg.rubyPackage != null) cfg.rubyPackage;

    home.file = mkIf (cfg.projects != { }) (
      mapAttrs' (name: project: {
        name = ".config/tmuxinator/${name}.yml";
        value = {
          source = generateYaml name project;
        };
      }) cfg.projects
    );
  };
}
