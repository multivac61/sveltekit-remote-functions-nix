{
  description = "sveltekit-remote-functions";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
      systems,
    }:
    let
      eachSystem =
        f: nixpkgs.lib.genAttrs (import systems) (system: f system nixpkgs.legacyPackages.${system});

      systemOutputs = eachSystem (
        _system: pkgs:
        let
          # Build prettier-plugin-svelte from version-3 branch (Svelte 5 support)
          prettier-plugin-svelte = pkgs.buildNpmPackage rec {
            pname = "prettier-plugin-svelte";
            version = "3-unstable-2025-01-29";

            src = pkgs.fetchFromGitHub {
              owner = "sveltejs";
              repo = "prettier-plugin-svelte";
              rev = "7d68c92243a654ca0a35606dede44694941ad805"; # Latest commit on version-3 branch
              hash = "sha256-6DoMm7KpWUEDrnYE7K7l/dtYVEvVzfWgG0kkNl5m9Qk=";
            };

            npmDepsHash = "sha256-MG1DiutTelg6GQwIbMya+mQTx6UoDoRHZvAkVYC9deI=";

            dontNpmPrune = true;

            # Keep prettier and svelte in node_modules to avoid "Cannot find module" errors
            postInstall = ''
              pushd "$nodeModulesPath"
              # Keep only essential dependencies (prettier, svelte, and this plugin)
              find -mindepth 1 -maxdepth 1 -type d -print0 | \
                grep --null-data -Exv "\./(@?prettier.*|svelte|prettier-plugin-svelte)" | \
                xargs -0 rm -rfv || true
              popd
            '';
          };

          treefmtEval = treefmt-nix.lib.evalModule pkgs {
            # Nix formatters
            programs.deadnix.enable = true;
            programs.nixfmt.enable = true;

            # Shell formatters
            programs.shellcheck.enable = true;
            programs.shfmt.enable = true;

            # JavaScript/TypeScript/Svelte formatter
            programs.prettier = {
              enable = true;
              settings = {
                plugins = [
                  "${prettier-plugin-svelte}/lib/node_modules/prettier-plugin-svelte/plugin.js"
                ];
                overrides = [
                  {
                    files = [ "*.svelte" ];
                    options = {
                      parser = "svelte";
                    };
                  }
                ];
              };
              includes = [
                "*.ts"
                "*.js"
                "*.json"
                "*.svelte"
                "*.md"
              ];
            };

            settings.formatter.shfmt.includes = [ "*.envrc" ];

            settings.global.excludes = [
              "*.png"
              "*.jpg"
              "*.zip"
              "*.touchosc"
              "*.pdf"
              "*.svg"
              "*.ico"
              "*.webp"
              "*.gif"
              "node_modules"
              ".svelte-kit"
              "pnpm-lock.yaml"
              "package-lock.json"
              # Exclude files using {@render} syntax until plugin fully supports Svelte 5
              "src/routes/+layout.svelte"
              "src/routes/admin/+layout.svelte"
            ];
          };
        in
        {
          formatter = treefmtEval.config.build.wrapper;
          checks.formatting = treefmtEval.config.build.check self;
          devshell.default = pkgs.mkShell {
            packages = with pkgs; [
              pnpm
              nodejs_20
            ];
          };
          packages.default = pkgs.stdenv.mkDerivation (finalAttrs: {
            pname = "sveltekit-remote-functions";
            version = "0.01";
            src = ./.;
            pnpmDeps = pkgs.pnpm.fetchDeps {
              inherit (finalAttrs) pname version src;
              hash = "sha256-Kn+5AkZ2yz4tpEtmX523pK2RvteizZYVpcArQuKhNhg=";
              fetcherVersion = 2;
            };
            # This needs to change before
            BETTER_AUTH_SECRET = "wLG7usiXdIRJjq3NxwfUqW9pO2wum1gy";
            DATABASE_URL = "file:local.db";

            nativeBuildInputs = with pkgs; [
              nodejs
              pnpm.configHook
              makeWrapper
            ];

            buildPhase = ''
              runHook preBuild
              pnpm build
              runHook postBuild
            '';

            installPhase = ''
              runHook preInstall

              mkdir -p $out/build

              # Copy build output
              cp -r build/* $out/build/

              # Copy package files and install only production dependencies
              cp package.json pnpm-lock.yaml $out/build/
              cd $out/build
              pnpm install --prod --frozen-lockfile

              # Create wrapper to run the server
              makeWrapper ${pkgs.nodejs}/bin/node $out/bin/server \
                --chdir $out/build \
                --set NODE_PATH "$out/build/node_modules" \
                --add-flags "index.js"

              runHook postInstall
            '';
          });
        }
      );
    in
    {
      devShells = nixpkgs.lib.mapAttrs (_system: outputs: outputs.devshell) systemOutputs;
      formatter = nixpkgs.lib.mapAttrs (_system: outputs: outputs.formatter) systemOutputs;
      packages = nixpkgs.lib.mapAttrs (_system: outputs: outputs.packages) systemOutputs;
      checks = nixpkgs.lib.mapAttrs (_system: outputs: outputs.checks) systemOutputs;
    };
}
