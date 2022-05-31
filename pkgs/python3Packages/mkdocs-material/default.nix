{ lib
, stdenv
, fetchPypi
, buildPythonPackage
, markdown
, mkdocs
, pygments
, pymdown-extensions
, pytest
, pyyaml
}:

buildPythonPackage rec {
  pname = "mkdocs-material";
  version = "6.1.6";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nyx9m7x2nlx8p7328rndy57wxiwyi597nn0fl7aihlxna9hi0wb";
  };

  postPatch = ''
    # Not sure why the cyclic dependency?
    sed -i '/mkdocs-material-extensions/d' requirements.txt mkdocs_material.egg-info/requires.txt
  '';

  propagatedBuildInputs = [
    markdown
    mkdocs
    pygments
    pymdown-extensions
  ];

  meta = with lib; {
    description = "Material for MkDocs";
    maintainers = [ maintainers.limeytexan ];
    homepage = https://squidfunk.github.io/mkdocs-material/;
  };
}
