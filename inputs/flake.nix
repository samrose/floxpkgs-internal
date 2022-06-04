rec {

  inputs.floxpkgsv1.url = "git+ssh://git@github.com/flox/floxpkgsv1";
  inputs.floxpkgsv1.flake = false;




  outputs = {self, capacitor, ...} @ inputs:  inputs ;

}
