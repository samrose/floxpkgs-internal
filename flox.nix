{_}: {
  nix-installers = _.nix-installers + "/default.nix";
  python3Packages = _.floxpkgsv1 + "/pythonPackages";
}
