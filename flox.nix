{_}: {
  # External proto-derivation trees
  nix-installers = _.nix-installers + "/default.nix";
  python2Packages = _.floxpkgsv1 + "/pythonPackages";
  python3Packages = _.floxpkgsv1 + "/pythonPackages";
}
