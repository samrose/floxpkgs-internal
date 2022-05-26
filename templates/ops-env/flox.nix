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
