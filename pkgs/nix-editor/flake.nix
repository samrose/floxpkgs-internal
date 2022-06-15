{
  inputs.src.url = "github:vlinkz/nix-editor";

  outputs = {capacitor,...} @ args: capacitor args ({lib, ...}: {
    packages = {system, inputs,...}: inputs.src.packages.${system}.nixeditor;
  });
}
