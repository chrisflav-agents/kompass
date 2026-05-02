{
  description = "Python venv development template";

  inputs = {
    utils.url = "github:numtide/flake-utils";
    process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";
    services-flake.url = "github:juspay/services-flake";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
    flake-parts,
    services-flake,
    process-compose-flake,
    ...
  }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      pythonPackages = pkgs.python313Packages;
      servicesMod = (import process-compose-flake.lib { inherit pkgs; }).evalModules {
        modules = [
          services-flake.processComposeModules.default
          {
            services.redis."r1".enable = true;
          }
        ];
      };
    in {
      packages."${system}"."myservices" = servicesMod.config.outputs.package;
      devShells."${system}".default = pkgs.mkShell {
        name = "python-venv";
        #venvDir = "./.venv";
        buildInputs = [
          # A Python interpreter including the 'venv' module is required to bootstrap
          # the environment.
          pythonPackages.python

          (pkgs.writeShellScriptBin "myservices" ''
            exec ${servicesMod.config.outputs.package}/bin/* "$@"
          '')

          # This executes some shell code to initialize a venv in $venvDir before
          # dropping into the shell
          # pythonPackages.venvShellHook

          pkgs.gettext
          pkgs.pkg-config
          pkgs.mariadb
          pkgs.libmysqlclient
          pkgs.libxcrypt
          # Required for Pillow
          pkgs.libjpeg
          pkgs.libpng
          pkgs.freetype
          pkgs.lcms2
          pkgs.libavif
          pkgs.libimagequant
          pkgs.libjpeg
          pkgs.libraqm
          pkgs.libtiff
          pkgs.libwebp
          pkgs.libxcb
          pkgs.openjpeg
          pkgs.zlib-ng
          pkgs.zlib
        ];

        shellHook = ''
          export PS1="\[\033[1;34m\][nix:kompass]\[\033[0m\] $PS1"
        '';

        ## Run this command, only after creating the virtual environment
        #postVenvCreation = ''
        #  unset SOURCE_DATE_EPOCH
        #  pip install -r requirements.txt
        #'';

        # Now we can execute any commands within the virtual environment.
        # This is optional and can be left out to run pip manually.
        #postShellHook = ''
        #  # allow pip to install wheels
        #  unset SOURCE_DATE_EPOCH
        #  pip install -r requirements.txt
        #'';
      };
    };
}
