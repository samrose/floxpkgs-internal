{ flox, nix-installers, runCommand }:
let
  inherit (flox) version;
  removeStorePathAndHash = p: with builtins;
    let
      prefixLen = (stringLength storeDir) + 34;
    in
      substring prefixLen ((stringLength p) - prefixLen) p;

in runCommand "flox-installers.${version}" { } ''
  set -x
  mkdir -p $out/nix-support
  cp ${nix-installers.deb.outPath} \
    $out/${removeStorePathAndHash nix-installers.deb.outPath}
  cp ${nix-installers.rpm.outPath} \
    $out/${removeStorePathAndHash nix-installers.rpm.outPath}
  cp ${nix-installers.pacman.outPath} \
    $out/${removeStorePathAndHash nix-installers.pacman.outPath}
  cp ${nix-installers.tarball.outPath} \
    $out/${removeStorePathAndHash nix-installers.tarball.outPath}
  cat <<EOF > $out/nix-support/hydra-build-products
  file binary-dist "$out/${removeStorePathAndHash nix-installers.deb.outPath}"
  file binary-dist "$out/${removeStorePathAndHash nix-installers.rpm.outPath}"
  file binary-dist "$out/${removeStorePathAndHash nix-installers.pacman.outPath}"
  file binary-dist "$out/${removeStorePathAndHash nix-installers.tarball.outPath}"
  EOF
  set +x
''
