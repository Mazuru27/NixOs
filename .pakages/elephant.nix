{pkgs, self, buildGo125Module, lib, ... }: buildGo125Module {
  pname = "elephant";
  version = "0.1.0";

        src = ./.;

        vendorHash = "sha256-shdrMMCdAntH/V1wWHG6kBYWf3Kn4DNimHyCtLrWIWE=";

        buildInputs = with pkgs; [
          protobuf
        ];

        nativeBuildInputs = with pkgs; [
          protoc-gen-go
          makeWrapper
        ];

        # Build from cmd/elephant/elephant.go
        subPackages = [
          "cmd/elephant"
        ];

        postFixup = ''
          wrapProgram $out/bin/elephant \
              --prefix PATH : ${lib.makeBinPath (with pkgs; [fd])}
        '';

        meta = with lib; {
          description = "Powerful data provider service and backend for building custom application launchers";
          homepage = "https://github.com/abenz1267/elephant";
          license = licenses.gpl3Only;
          maintainers = [];
          platforms = platforms.linux;
        };
}
