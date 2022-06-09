{
  inputs.src.url = "github:vlinkz/nix-editor";

  outputs = _:
  _.capacitor _ ({lib,src, ...}: {
    packages.default = {system,...}: src.packages.${system}.nixeditor;
  });
}
