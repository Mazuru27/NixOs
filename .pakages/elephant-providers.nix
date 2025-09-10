{pkgs, self, buildGo125Module, lib,  ...}: buildGo125Module rec {
  pname = "elephant-providers";
        version = "0.1.0";

        src = ./.;

        vendorHash = "sha256-shdrMMCdAntH/V1wWHG6kBYWf3Kn4DNimHyCtLrWIWE=";

        nativeBuildInputs = with pkgs; [
          protobuf
          protoc-gen-go
        ];

        excludedProviders = [
          "archlinuxpkgs"
        ];

        buildPhase = ''
          runHook preBuild:
          echo "Building elephant providers..."
          EXCLUDE_LIST="${lib.concatStringsSep " " excludedProviders}"
          is_excluded() {
            target="$1"
            for e in $EXCLUDE_LIST; do
              [ -z "$e" ] && continue
              if [ "$e" = "$target" ]; then
                return 0
              fi
            done
            return 1
          }
          if [ -d ./internal/providers ]; then
            for dir in ./internal/providers/*; do
              [ -d "$dir" ] || continue
              provider=$(basename "$dir")
              if is_excluded "$provider"; then
                echo "Skipping excluded provider: $provider"
                continue
              fi
              set -- "$dir"/*.go
              if [ -e "$1" ]; then
                echo "Building provider: $provider"
                if ! go build -buildmode=plugin -o "$provider.so" ./internal/providers/"$provider"; then
                  echo "⚠ Failed to build provider: $provider"
                  exit 1
                fi
                echo "Built $provider.so"
              else
                echo "Skipping $provider: no .go files found"
              fi
            done
          else
            echo "No providers directory found at ./internal/providers"
          fi
          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
          mkdir -p $out/lib/elephant/providers
          # Copy all built .so files
          for so_file in *.so; do
            if [[ -f "$so_file" ]]; then
              cp "$so_file" "$out/lib/elephant/providers/"
              echo "Installed provider: $so_file"
            fi
          done
          runHook postInstall
        '';

        meta = with lib; {
          description = "Elephant providers (Go plugins)";
          homepage = "https://github.com/abenz1267/elephant";
          license = licenses.gpl3Only;
          platforms = platforms.linux;
        };
}
