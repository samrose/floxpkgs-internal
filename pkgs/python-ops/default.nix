{ pkgs, python, ... }:
with builtins;
with pkgs.lib;
let
  pypi_fetcher_src = builtins.fetchTarball {
    name = "nix-pypi-fetcher";
    url = "https://github.com/DavHau/nix-pypi-fetcher/tarball/c27e6c305a85f348d52ef25b7a70f0daa2576735";
    # Hash obtained using `nix-prefetch-url --unpack <url>`
    sha256 = "sha256-tVuPTcfcipxTSLpL1+YnEoWB9qMwPrLmPoGfGx6UdnQ=";
  };
  pypiFetcher = import pypi_fetcher_src { inherit pkgs; };
  fetchPypi = pypiFetcher.fetchPypi;
  fetchPypiWheel = pypiFetcher.fetchPypiWheel;
  pkgsData = fromJSON ''{"allure-pytest": {"name": "allure-pytest", "ver": "2.9.45", "build_inputs": [], "prop_build_inputs": ["allure-python-commons", "six", "pytest"], "is_root": true, "provider_info": {"provider": "wheel", "wheel_fname": "allure_pytest-2.9.45-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "allure-python-commons": {"name": "allure-python-commons", "ver": "2.9.45", "build_inputs": [], "prop_build_inputs": ["six", "pluggy", "attrs"], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "allure_python_commons-2.9.45-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "attrs": {"name": "attrs", "ver": "21.4.0", "build_inputs": [], "prop_build_inputs": [], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "attrs-21.4.0-py2.py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "cachetools": {"name": "cachetools", "ver": "5.2.0", "build_inputs": [], "prop_build_inputs": [], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "cachetools-5.2.0-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "certifi": {"name": "certifi", "ver": "2022.5.18.1", "build_inputs": [], "prop_build_inputs": [], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "certifi-2022.5.18.1-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "charset-normalizer": {"name": "charset-normalizer", "ver": "2.0.12", "build_inputs": [], "prop_build_inputs": [], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "charset_normalizer-2.0.12-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "google-auth": {"name": "google-auth", "ver": "2.7.0", "build_inputs": [], "prop_build_inputs": ["rsa", "six", "cachetools", "pyasn1-modules"], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "google_auth-2.7.0-py2.py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "idna": {"name": "idna", "ver": "3.3", "build_inputs": [], "prop_build_inputs": [], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "idna-3.3-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "iniconfig": {"name": "iniconfig", "ver": "1.1.1", "build_inputs": [], "prop_build_inputs": [], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "iniconfig-1.1.1-py2.py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "kubernetes": {"name": "kubernetes", "ver": "23.6.0", "build_inputs": [], "prop_build_inputs": ["python-dateutil", "certifi", "requests-oauthlib", "google-auth", "urllib3", "websocket-client", "six", "requests", "setuptools", "pyyaml"], "is_root": true, "provider_info": {"provider": "wheel", "wheel_fname": "kubernetes-23.6.0-py2.py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "oauthlib": {"name": "oauthlib", "ver": "3.2.0", "build_inputs": [], "prop_build_inputs": [], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "oauthlib-3.2.0-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "packaging": {"name": "packaging", "ver": "21.3", "build_inputs": [], "prop_build_inputs": ["pyparsing"], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "packaging-21.3-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "pip": {"name": "pip", "ver": "22.0.4", "build_inputs": [], "prop_build_inputs": [], "is_root": true, "provider_info": {"provider": "nixpkgs", "wheel_fname": null, "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "pluggy": {"name": "pluggy", "ver": "1.0.0", "build_inputs": [], "prop_build_inputs": [], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "pluggy-1.0.0-py2.py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "py": {"name": "py", "ver": "1.11.0", "build_inputs": [], "prop_build_inputs": [], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "py-1.11.0-py2.py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "pyasn1": {"name": "pyasn1", "ver": "0.4.8", "build_inputs": [], "prop_build_inputs": [], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "pyasn1-0.4.8-py2.py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "pyasn1-modules": {"name": "pyasn1-modules", "ver": "0.2.8", "build_inputs": [], "prop_build_inputs": ["pyasn1"], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "pyasn1_modules-0.2.8-py2.py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "pyparsing": {"name": "pyparsing", "ver": "3.0.9", "build_inputs": [], "prop_build_inputs": [], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "pyparsing-3.0.9-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "pytest": {"name": "pytest", "ver": "7.1.2", "build_inputs": [], "prop_build_inputs": ["tomli", "packaging", "attrs", "iniconfig", "py", "pluggy"], "is_root": true, "provider_info": {"provider": "wheel", "wheel_fname": "pytest-7.1.2-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "python-dateutil": {"name": "python-dateutil", "ver": "2.8.2", "build_inputs": [], "prop_build_inputs": ["six"], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "python_dateutil-2.8.2-py2.py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "pyyaml": {"name": "pyyaml", "ver": "6.0", "build_inputs": [], "prop_build_inputs": [], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "PyYAML-6.0-cp39-cp39-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_12_x86_64.manylinux2010_x86_64.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "requests": {"name": "requests", "ver": "2.27.1", "build_inputs": [], "prop_build_inputs": ["idna", "charset-normalizer", "urllib3", "certifi"], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "requests-2.27.1-py2.py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "requests-oauthlib": {"name": "requests-oauthlib", "ver": "1.3.1", "build_inputs": [], "prop_build_inputs": ["requests", "oauthlib"], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "requests_oauthlib-1.3.1-py2.py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "rsa": {"name": "rsa", "ver": "4.8", "build_inputs": [], "prop_build_inputs": ["pyasn1"], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "rsa-4.8-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "setuptools": {"name": "setuptools", "ver": "61.2.0", "build_inputs": [], "prop_build_inputs": [], "is_root": false, "provider_info": {"provider": "nixpkgs", "wheel_fname": null, "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "six": {"name": "six", "ver": "1.16.0", "build_inputs": [], "prop_build_inputs": [], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "six-1.16.0-py2.py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "tomli": {"name": "tomli", "ver": "2.0.1", "build_inputs": [], "prop_build_inputs": [], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "tomli-2.0.1-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "urllib3": {"name": "urllib3", "ver": "1.26.9", "build_inputs": [], "prop_build_inputs": [], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "urllib3-1.26.9-py2.py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}, "websocket-client": {"name": "websocket-client", "ver": "1.3.2", "build_inputs": [], "prop_build_inputs": [], "is_root": false, "provider_info": {"provider": "wheel", "wheel_fname": "websocket_client-1.3.2-py3-none-any.whl", "url": null, "hash": null}, "extras_selected": [], "removed_circular_deps": [], "build": null}}'';
  isPyModule = pkg:
    isAttrs pkg && hasAttr "pythonModule" pkg;
  normalizeName = name: (replaceStrings ["_"] ["-"] (toLower name));
  depNamesOther = [
    "depsBuildBuild"
    "depsBuildBuildPropagated"
    "nativeBuildInputs"
    "propagatedNativeBuildInputs"
    "depsBuildTarget"
    "depsBuildTargetPropagated"
    "depsHostHost"
    "depsHostHostPropagated"
    "depsTargetTarget"
    "depsTargetTargetPropagated"
    "checkInputs"
    "installCheckInputs"
  ];
  depNamesAll = depNamesOther ++ [
    "propagatedBuildInputs"
    "buildInputs"
  ];
  removeUnwantedPythonDeps = pythonSelf: pname: inputs:
    # Do not remove any deps if provider is nixpkgs and actual dependencies are unknown.
    # Otherwise we risk removing dependencies which are needed.
    if pkgsData."${pname}".provider_info.provider == "nixpkgs"
        &&
        (pkgsData."${pname}".build_inputs == null
            || pkgsData."${pname}".prop_build_inputs == null) then
      inputs
    else
      filter
        (dep:
          if ! isPyModule dep || pkgsData ? "${normalizeName (get_pname dep)}" then
            true
          else
            trace "removing dependency ${dep.name} from ${pname}" false)
        inputs;
  updatePythonDeps = newPkgs: pkg:
    if ! isPyModule pkg then pkg else
    let
      pname = normalizeName (get_pname pkg);
      newP =
        # All packages with a pname that already exists in our overrides must be replaced with our version.
        # Otherwise we will have a collision
        if newPkgs ? "${pname}" && pkg != newPkgs."${pname}" then
          trace "Updated inherited nixpkgs dep ${pname} from ${pkg.version} to ${newPkgs."${pname}".version}"
          newPkgs."${pname}"
        else
          pkg;
    in
      newP;
  updateAndRemoveDeps = pythonSelf: name: inputs:
    removeUnwantedPythonDeps pythonSelf name (map (dep: updatePythonDeps pythonSelf dep) inputs);
  cleanPythonDerivationInputs = pythonSelf: name: oldAttrs:
    mapAttrs (n: v: if elem n depNamesAll then updateAndRemoveDeps pythonSelf name v else v ) oldAttrs;
  override = pkg:
    if hasAttr "overridePythonAttrs" pkg then
        pkg.overridePythonAttrs
    else
        pkg.overrideAttrs;
  nameMap = {
    pytorch = "torch";
  };
  get_pname = pkg:
    let
      res = tryEval (
        if pkg ? src.pname then
          pkg.src.pname
        else if pkg ? pname then
          let pname = pkg.pname; in
            if nameMap ? "${pname}" then nameMap."${pname}" else pname
          else ""
      );
    in
      toString res.value;
  get_passthru = pypi_name: nix_name:
    # if pypi_name is in nixpkgs, we must pick it, otherwise risk infinite recursion.
    let
      python_pkgs = python.pkgs;
      pname = if hasAttr "${pypi_name}" python_pkgs then pypi_name else nix_name;
    in
      if hasAttr "${pname}" python_pkgs then
        let result = (tryEval
          (if isNull python_pkgs."${pname}" then
            {}
          else
            python_pkgs."${pname}".passthru));
        in
          if result.success then result.value else {}
      else {};
  allCondaDepsRec = pkg:
    let directCondaDeps =
      filter (p: p ? provider && p.provider == "conda") (pkg.propagatedBuildInputs or []);
    in
      directCondaDeps ++ filter (p: ! directCondaDeps ? p) (map (p: p.allCondaDeps) directCondaDeps);
  tests_on_off = enabled: pySelf: pySuper:
    let
      mod = {
        doCheck = enabled;
        doInstallCheck = enabled;
      };
    in
    {
      buildPythonPackage = args: pySuper.buildPythonPackage ( args // {
        doCheck = enabled;
        doInstallCheck = enabled;
      } );
      buildPythonApplication = args: pySuper.buildPythonPackage ( args // {
        doCheck = enabled;
        doInstallCheck = enabled;
      } );
    };
  pname_passthru_override = pySelf: pySuper: {
    fetchPypi = args: (pySuper.fetchPypi args).overrideAttrs (oa: {
      passthru = { inherit (args) pname; };
    });
  };
  mergeOverrides = with pkgs.lib; foldl composeExtensions (self: super: {});
  merge_with_overr = enabled: overr:
    mergeOverrides [(tests_on_off enabled) pname_passthru_override overr];
  select_pkgs = ps: [
    ps."allure-pytest"
    ps."kubernetes"
    ps."pip"
    ps."pytest"
  ];
  overrides' = manylinux1: autoPatchelfHook: merge_with_overr false (python-self: python-super: let all = {
    "allure-pytest" = python-self.buildPythonPackage {
      pname = "allure-pytest";
      version = "2.9.45";
      src = fetchPypiWheel "allure-pytest" "2.9.45" "allure_pytest-2.9.45-py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "allure-pytest" "allure-pytest") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ allure-python-commons pytest six ];
    };
    "allure-python-commons" = python-self.buildPythonPackage {
      pname = "allure-python-commons";
      version = "2.9.45";
      src = fetchPypiWheel "allure-python-commons" "2.9.45" "allure_python_commons-2.9.45-py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "allure-python-commons" "allure-python-commons") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ attrs pluggy six ];
    };
    "attrs" = python-self.buildPythonPackage {
      pname = "attrs";
      version = "21.4.0";
      src = fetchPypiWheel "attrs" "21.4.0" "attrs-21.4.0-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "attrs" "attrs") // { provider = "wheel"; };
    };
    "cachetools" = python-self.buildPythonPackage {
      pname = "cachetools";
      version = "5.2.0";
      src = fetchPypiWheel "cachetools" "5.2.0" "cachetools-5.2.0-py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "cachetools" "cachetools") // { provider = "wheel"; };
    };
    "certifi" = python-self.buildPythonPackage {
      pname = "certifi";
      version = "2022.5.18.1";
      src = fetchPypiWheel "certifi" "2022.5.18.1" "certifi-2022.5.18.1-py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "certifi" "certifi") // { provider = "wheel"; };
    };
    "charset-normalizer" = python-self.buildPythonPackage {
      pname = "charset-normalizer";
      version = "2.0.12";
      src = fetchPypiWheel "charset-normalizer" "2.0.12" "charset_normalizer-2.0.12-py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "charset-normalizer" "charset-normalizer") // { provider = "wheel"; };
    };
    "google-auth" = python-self.buildPythonPackage {
      pname = "google-auth";
      version = "2.7.0";
      src = fetchPypiWheel "google-auth" "2.7.0" "google_auth-2.7.0-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "google-auth" "google-auth") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ cachetools pyasn1-modules rsa six ];
    };
    "idna" = python-self.buildPythonPackage {
      pname = "idna";
      version = "3.3";
      src = fetchPypiWheel "idna" "3.3" "idna-3.3-py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "idna" "idna") // { provider = "wheel"; };
    };
    "iniconfig" = python-self.buildPythonPackage {
      pname = "iniconfig";
      version = "1.1.1";
      src = fetchPypiWheel "iniconfig" "1.1.1" "iniconfig-1.1.1-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "iniconfig" "iniconfig") // { provider = "wheel"; };
    };
    "kubernetes" = python-self.buildPythonPackage {
      pname = "kubernetes";
      version = "23.6.0";
      src = fetchPypiWheel "kubernetes" "23.6.0" "kubernetes-23.6.0-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "kubernetes" "kubernetes") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ certifi google-auth python-dateutil pyyaml requests requests-oauthlib setuptools six urllib3 websocket-client ];
    };
    "oauthlib" = python-self.buildPythonPackage {
      pname = "oauthlib";
      version = "3.2.0";
      src = fetchPypiWheel "oauthlib" "3.2.0" "oauthlib-3.2.0-py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "oauthlib" "oauthlib") // { provider = "wheel"; };
    };
    "packaging" = python-self.buildPythonPackage {
      pname = "packaging";
      version = "21.3";
      src = fetchPypiWheel "packaging" "21.3" "packaging-21.3-py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "packaging" "packaging") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ pyparsing ];
    };
    "pip" = override python-super."pip" ( oldAttrs:
      # filter out unwanted dependencies and replace colliding packages
      let cleanedAttrs = cleanPythonDerivationInputs python-self "pip" oldAttrs; in cleanedAttrs // {
        pname = "pip";
        version = "22.0.4";
        passthru = (get_passthru "pip" "pip") // { provider = "nixpkgs"; };
        buildInputs = with python-self; (cleanedAttrs.buildInputs or []) ++ [  ];
        propagatedBuildInputs =
          (cleanedAttrs.propagatedBuildInputs or [])
          ++ ( with python-self; [  ]);
      }
    );
    "pluggy" = python-self.buildPythonPackage {
      pname = "pluggy";
      version = "1.0.0";
      src = fetchPypiWheel "pluggy" "1.0.0" "pluggy-1.0.0-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "pluggy" "pluggy") // { provider = "wheel"; };
    };
    "py" = python-self.buildPythonPackage {
      pname = "py";
      version = "1.11.0";
      src = fetchPypiWheel "py" "1.11.0" "py-1.11.0-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "py" "py") // { provider = "wheel"; };
    };
    "pyasn1" = python-self.buildPythonPackage {
      pname = "pyasn1";
      version = "0.4.8";
      src = fetchPypiWheel "pyasn1" "0.4.8" "pyasn1-0.4.8-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "pyasn1" "pyasn1") // { provider = "wheel"; };
    };
    "pyasn1-modules" = python-self.buildPythonPackage {
      pname = "pyasn1-modules";
      version = "0.2.8";
      src = fetchPypiWheel "pyasn1-modules" "0.2.8" "pyasn1_modules-0.2.8-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "pyasn1-modules" "pyasn1-modules") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ pyasn1 ];
    };
    "pyparsing" = python-self.buildPythonPackage {
      pname = "pyparsing";
      version = "3.0.9";
      src = fetchPypiWheel "pyparsing" "3.0.9" "pyparsing-3.0.9-py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "pyparsing" "pyparsing") // { provider = "wheel"; };
    };
    "pytest" = python-self.buildPythonPackage {
      pname = "pytest";
      version = "7.1.2";
      src = fetchPypiWheel "pytest" "7.1.2" "pytest-7.1.2-py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "pytest" "pytest") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ attrs iniconfig packaging pluggy py tomli ];
    };
    "python-dateutil" = python-self.buildPythonPackage {
      pname = "python-dateutil";
      version = "2.8.2";
      src = fetchPypiWheel "python-dateutil" "2.8.2" "python_dateutil-2.8.2-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "python-dateutil" "python-dateutil") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ six ];
    };
    "pyyaml" = python-self.buildPythonPackage {
      pname = "pyyaml";
      version = "6.0";
      src = fetchPypiWheel "pyyaml" "6.0" "PyYAML-6.0-cp39-cp39-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_12_x86_64.manylinux2010_x86_64.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "pyyaml" "pyyaml") // { provider = "wheel"; };
      nativeBuildInputs = [ autoPatchelfHook ];
      autoPatchelfIgnoreMissingDeps = true;
      propagatedBuildInputs = with python-self; manylinux1 ++ [  ];
    };
    "requests" = python-self.buildPythonPackage {
      pname = "requests";
      version = "2.27.1";
      src = fetchPypiWheel "requests" "2.27.1" "requests-2.27.1-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "requests" "requests") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ certifi charset-normalizer idna urllib3 ];
    };
    "requests-oauthlib" = python-self.buildPythonPackage {
      pname = "requests-oauthlib";
      version = "1.3.1";
      src = fetchPypiWheel "requests-oauthlib" "1.3.1" "requests_oauthlib-1.3.1-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "requests-oauthlib" "requests-oauthlib") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ oauthlib requests ];
    };
    "rsa" = python-self.buildPythonPackage {
      pname = "rsa";
      version = "4.8";
      src = fetchPypiWheel "rsa" "4.8" "rsa-4.8-py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "rsa" "rsa") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ pyasn1 ];
    };
    "setuptools" = override python-super."setuptools" ( oldAttrs:
      # filter out unwanted dependencies and replace colliding packages
      let cleanedAttrs = cleanPythonDerivationInputs python-self "setuptools" oldAttrs; in cleanedAttrs // {
        pname = "setuptools";
        version = "61.2.0";
        passthru = (get_passthru "setuptools" "setuptools") // { provider = "nixpkgs"; };
        buildInputs = with python-self; (cleanedAttrs.buildInputs or []) ++ [  ];
        propagatedBuildInputs =
          (cleanedAttrs.propagatedBuildInputs or [])
          ++ ( with python-self; [  ]);
      }
    );
    "six" = python-self.buildPythonPackage {
      pname = "six";
      version = "1.16.0";
      src = fetchPypiWheel "six" "1.16.0" "six-1.16.0-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "six" "six") // { provider = "wheel"; };
    };
    "tomli" = python-self.buildPythonPackage {
      pname = "tomli";
      version = "2.0.1";
      src = fetchPypiWheel "tomli" "2.0.1" "tomli-2.0.1-py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "tomli" "tomli") // { provider = "wheel"; };
    };
    "urllib3" = python-self.buildPythonPackage {
      pname = "urllib3";
      version = "1.26.9";
      src = fetchPypiWheel "urllib3" "1.26.9" "urllib3-1.26.9-py2.py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "urllib3" "urllib3") // { provider = "wheel"; };
    };
    "websocket-client" = python-self.buildPythonPackage {
      pname = "websocket-client";
      version = "1.3.2";
      src = fetchPypiWheel "websocket-client" "1.3.2" "websocket_client-1.3.2-py3-none-any.whl";
      format = "wheel";
      dontStrip = true;
      passthru = (get_passthru "websocket-client" "websocket-client") // { provider = "wheel"; };
    };
  }; in all);
in
{
  inherit select_pkgs;
  overrides = overrides';
}
