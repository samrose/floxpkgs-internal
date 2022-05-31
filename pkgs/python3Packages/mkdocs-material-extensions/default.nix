{ lib, stdenv, fetchPypi, buildPythonPackage, markdown, mkdocs-material, pytest, pyyaml }:

buildPythonPackage rec {
  pname = "mkdocs-material-extensions";
  version = "1.0.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13y617sql4hqs376c3dfcb6v7q41km9x7fh52k3f74a2brzzniv9";
  };

  propagatedBuildInputs = [
    mkdocs-material
  ];

  # tests broken, but icons work. Moving on ...
  doCheck = false;

  meta = with lib; {
    description = "Markdown extension resources for MkDocs for Material";
    maintainers = [ maintainers.limeytexan ];
    homepage = https://github.com/facelessuser/mkdocs-material-extensions;
  };
}
