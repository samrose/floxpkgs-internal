{ flox, nix-installers, runCommand }:
let
  inherit (flox) version;

in runCommand "flox-installers.${version}" { } ''
  mkdir -p $out/nix-support
  cp ${nix-installers.deb.outPath} $out/flox-${version}.deb
  cp ${nix-installers.rpm.outPath} $out/flox-${version}.rpm
  cp ${nix-installers.pacman.outPath} $out/flox-${version}.pacman
  touch $out/nix-support/hydra-build-products
  echo "file binary-dist \"$out/flox-${version}.deb\" >> $out/nix-support/hydra-build-products
  echo "file binary-dist \"$out/flox-${version}.rpm\" >> $out/nix-support/hydra-build-products
  echo "file binary-dist \"$out/flox-${version}.pacman\" >> $out/nix-support/hydra-build-products
''
