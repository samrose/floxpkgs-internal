{ callPackage, fetchFrom, inputs}:

let d = fetchFrom inputs "git+ssh://git@github.com/flox/flox?ref=tng";
in callPackage d {}
