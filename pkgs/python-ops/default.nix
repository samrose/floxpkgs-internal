{python3, ...}: python3.withPackages (ps: with ps; [
  kubernetes
  pystest
  allure-pytest
  pip
])
