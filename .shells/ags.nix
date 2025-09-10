{
  pkgs,
  mkShell,
  self,
  stdenv, ...
}: mkShell {
  buildInputs = [
    (self.packages.${stdenv.system}.ags.override {
      extraPackages = [
        # cherry pick packages
      ];
    })
  ];
}
