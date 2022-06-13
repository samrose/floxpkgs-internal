{ stdenv
, asciinema-scenario
, entr
, m4
, mkdocs
, python3Packages
, which
, fetchFrom
, inputs
}:

let
  pythonPackages = python3Packages;

in
stdenv.mkDerivation {
  src = fetchFrom inputs "git+ssh://git@github.com/flox/floxdocs?ref=tng";
  name = "floxdocs-tng";
  version = "0.1";

  # Required for "pymdownx.snippets".
  propagatedBuildInputs = [
	pythonPackages.pymdown-extensions
	pythonPackages.mkdocs-material
	pythonPackages.mkdocs-material-extensions
	pythonPackages.mkdocs-include-markdown-plugin
	pythonPackages.mkdocs-macros-plugin
	pythonPackages.setuptools
  ];
  nativeBuildInputs = [ asciinema-scenario entr m4 mkdocs which ];
  makeFlags = [ "DOCTYPE=internal" ];
  buildFlags = [ "build" ];
  installPhase = ''
    cp -R build/site $out
  '';
}
