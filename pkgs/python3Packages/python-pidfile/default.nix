{ lib, buildPythonPackage, fetchPypi, psutil }:

buildPythonPackage rec {
  pname = "python-pidfile";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1l19aklxmhjc4vnx74cizjyz3vr0ifggizlzb5sgaxdw87grf40y";
  };

  propagatedBuildInputs = [ psutil ];

  meta = with lib; {
    description = "Python context manager for managing pid files";
    homepage = "https://github.com/mosquito/python-pidfile";
    license = with licenses; [ mit ];
    maintainers = [ teams.deshaw.members ];
  };
}
