{ lib, stdenv, fetchPypi, buildPythonPackage, mkdocs }:

buildPythonPackage rec {
  pname = "mkdocs-include-markdown-plugin";
  version = "2.7.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit version;
    pname = "mkdocs_include_markdown_plugin";
    sha256 = "b1fc1e7f14cafbd86f75fefe4c51a655ec1703f092e8ef079d3adb2f596936d8";
  };

  propagatedBuildInputs = [ mkdocs ];

  doCheck = false;  # fails with AttributeError: module 'mkdocs' has no attribute 'plugins'

  meta = with lib; {
    description = "Mkdocs Markdown includer plugin";
    maintainers = teams.deshaw.members;
    homepage = https://github.com/mondeja/mkdocs-include-markdown-plugin;
  };
}
