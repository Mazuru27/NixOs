{pkgs, self, stdenv,astal, ...}: stdenv.mkDerivation {
  pname = "my-shell";

  src = ./.;

  nativeBuildInputs = with pkgs; [
    warpGAppsHook
    gobject-introspection
    ags.packages.eachSystem.default
  ];
  buildInputs = [
    pkgs.glib
    pkgs.gjs
    astal.io
    astal.astal4
    astal.hyprland
    astal.bluetooth
    astal.cava
    # Astal pakages like astal.battery or pkgs.libsoup_4
  ];

  installPhase = ''
  ags bundle app.ts $out/bin/my-shell
  '';
  preFixup = ''
    gappsWrapperArgs+=(
    --prefix PATH : $(pkgs,lib.makeBinPath
    [
      # Runtime Executables
    ])
  )
  '';
}
