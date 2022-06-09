{
  inputs.src.url = "github:vlinkz/nix-editor";

  outputs = _:
  _.capacitor _ ({lib, ...}: {
    packages.default = {system, inputs,...}: inputs.src.packages.${system}.nixeditor;
  });
}
