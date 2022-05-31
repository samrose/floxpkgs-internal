{ lib, stdenv, fetchPypi, buildPythonPackage, mkdocs, python-dateutil, termcolor
, pyyaml, jinja2, mkdocs-macros-test, mkdocs-material }:

buildPythonPackage rec {
  pname = "mkdocs-macros-plugin";
  version = "0.5.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit version;
    inherit pname;
    sha256 = "0dzq63chy0qgbikgskczda344m58sb3j3iiqr9f7dn863dlwpybh";
  };

  propagatedBuildInputs = [
    mkdocs
    python-dateutil
    termcolor
    pyyaml
    jinja2
    mkdocs-macros-test
    mkdocs-material
  ];

  doCheck =
    false; # fails with AttributeError: module 'mkdocs' has no attribute 'plugins'

  meta = with lib; {
    description = "Unleash the power of MkDocs with variables and macros";
    maintainers = teams.deshaw.members;
    homepage = "https://github.com/fralau/mkdocs_macros_plugin";
  };
}
