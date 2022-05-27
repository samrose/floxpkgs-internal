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

    (
      vscodeLib.configuredVscode pkgs
      {extensions = ["ms-python.python" "ms-python.pylint"];}
      [
        {
          "name" = "pylint";
          "publisher" = "ms-python";
          "version" = "2022.1.11371003";
          "sha256" = "15bmlf5r94ms5nkihpm59nhk3i8liqf58csg2aiyqi3iqk6m23i0";
        }
      ]
      # (builtins.fromJSON (builtins.readFile ./flox-env.lock)).vscode
    )

    # For colors!
    parallel
    gnugrep
    which
    coreutils
  ];
  postShellHook = ''
    # Show versions with a bit of color
    echo
    LC_ALL=C.UTF-8 parallel --will-cite 'flox path-info $(readlink -f $(which {})) | cut -d- -f2- ' ::: curl docker unzip aws kubectl python3 helm |
       grep -P --colour=always '(?:^|(?<=[-]))[0-9.]*|$'
  '';
}
