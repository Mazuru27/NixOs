{pkgs, mkShell, self, stdenv, ...}: mkShell {
  name = "elephant";
  inputsFrom = [self.packages.${pkgs.stdenv.system}.elephant];
  buildInputs = with pkgs; [
    go
    gcc
    protobuf
    protoc-gen-connect-go
  ];
}
