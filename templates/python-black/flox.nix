{
  paths = [
    cowsay

    "kubernetes-helm@3.8"
    "hello@2.10"

    (mkPython {
      python = "python39";
      requirements = ''
        requests
      '';
    })

  ];
}
