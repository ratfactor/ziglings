{ pkgs ? import <nixpkgs> { } }:

with pkgs;
let
  zig =
    # needs 0.8.0 dev version
    stdenv.mkDerivation
      {
        name = "zig";
        src = fetchTarball {
          url =
            if stdenv.isDarwin then
              "https://ziglang.org/builds/zig-macos-x86_64-0.8.0-dev.1983+e2cc02717.tar.xz"
            else "https://ziglang.org/builds/zig-linux-x86_64-0.8.0-dev.1983+e2cc02717.tar.xz";
          sha256 = "sha256:0wgzygg9a5glnhw6kg3w2v7n7bihzz427kpx8h2nw2rvbwq2lb4r";
        };
        dontConfigure = true;
        dontBuild = true;
        installPhase = ''
          mkdir -p $out
          mv ./lib $out/
          mkdir -p $out/bin
          mv ./zig $out/bin
          mkdir -p $out/doc
          #mv ./langref.html $out/doc
        '';
      };
in

mkShell rec {
  buildInputs = [
    zig
  ];
}

