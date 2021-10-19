{ pkgs ? import <nixpkgs> { }, system ? builtins.currentSystem }:
let
  zig-overlay = builtins.fetchTarball "https://github.com/arqv/zig-overlay/archive/main.tar.gz";
  zig = (import zig-overlay { inherit pkgs system; }).master.latest;
  run = pkgs.writeShellScriptBin "run" ''
    ${pkgs.fd}/bin/fd -e zig | ${pkgs.entr}/bin/entr ${zig}/bin/zig build
  '';
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [ entr fd ] ++ [ zig run ];
}
