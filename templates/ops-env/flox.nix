/*
curl, docker.io, python3, python3-pip, python3-venv, unzip Latest versions
Python packages
allure-pytest, kubernetes, pytest
allure-pytest and pytest latest versions
I might want to pin the kubernetes version
Manually installation
AWS CLI v2+
kubectl Currently latest, but I would like to pin the version
Helm Latest v3.x
*/
{
  paths = [
    curl
    docker
    unzip
    awscli2
    kubectl
    "kubernetes-helm@3.8"

    (mkPython {
      python = "python39";
      requirements = ''
        pip
        allure-pytest==2.9.45
        kubernetes
        pytest
      '';
    })


    # For colors!
    parallel gnugrep which coreutils
  ];
  postShellHook = ''
    # Show versions with a bit of color
    echo
    parallel --will-cite 'flox path-info $(readlink -f $(which {})) | cut -d- -f2- ' ::: curl docker unzip aws kubectl python3 helm |
       grep -P --colour=always '(?:^|(?<=[-]))[0-9.]*|$'
    '';
}
