{
  outputs = {self, ...}: {
    pins = builtins.listToAttrs (map (x: {
        name = builtins.replaceStrings ["."] ["_"] x.name;
        value = x;
      })
      self.__pins);
    __pins = [
      (builtins.getFlake "github:NixOS/nixpkgs/4080fdcc788253bca716d559e952ccfb873ebf11").legacyPackages.x86_64-linux.kubernetes-helm
    ];
  };
}
