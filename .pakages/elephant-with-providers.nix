{pkgs, self, stdenv, lib,  ...}:  stdenv.mkDerivation {
        pname = "elephant-with-providers";
        version = "0.1.0";

        dontUnpack = true;

        buildInputs = [
          self.packages.${pkgs.stdenv.system}.elephant
          self.packages.${pkgs.stdenv.system}.elephant-providers
        ];

        nativeBuildInputs = with pkgs; [
          makeWrapper
        ];

        installPhase = ''
          mkdir -p $out/bin $out/lib/elephant
          cp ${self.packages.${pkgs.stdenv.system}.elephant}/bin/elephant $out/bin/
          cp -r ${self.packages.${pkgs.stdenv.system}.elephant-providers}/lib/elephant/providers $out/lib/elephant/
        '';

        postFixup = ''
          wrapProgram $out/bin/elephant \
            --prefix PATH : ${
            lib.makeBinPath (
              with pkgs; [
                wl-clipboard
                libqalculate
              ]
            )
          }
        '';

        meta = with lib; {
          description = "Elephant with all providers (complete installation)";
          homepage = "https://github.com/abenz1267/elephant";
          license = licenses.gpl3Only;
          platforms = platforms.linux;
        };
      }
