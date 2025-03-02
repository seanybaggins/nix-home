final: prev:

{
  #gpt-engineer = final.callPackage ./pkgs/gpt-engineer {
  #  buildPythonPackage = prev.python3Packages.buildPythonPackage;
  #  setuptools = prev.python3Packages.setuptools;
  #  openai = prev.python3Packages.openai;
  #};

  flowkey_dl = final.callPackage ./pkgs/flowkey_dl {
    buildPythonPackage = prev.python3Packages.buildPythonPackage;
    py = prev.python3Packages.py;
    setuptools = prev.python3Packages.setuptools;
    wheel = prev.python3Packages.wheel;
    requests = prev.python3Packages.requests;
    imageio = prev.python3Packages.imageio;
    importlib-metadata = prev.python3Packages.importlib-metadata;
    matplotlib = prev.python3Packages.matplotlib;
  };

  gpt4all = prev.gpt4all.overrideAttrs (oldAttrs: rec {
    version = "3.9.0";
    src = final.fetchFromGitHub {
      fetchSubmodules = true;
      hash = "sha256-DbMoDdP7tEku3zZiCOmPz3iHQF5acg97gd+tLKoFu/o=";
      owner = "nomic-ai";
      repo = "gpt4all";
      rev = "v${version}";
    };
    patches = [
      (final.fetchpatch {
        url = "https://raw.githubusercontent.com/drupol/nixpkgs/refs/heads/master/pkgs/by-name/gp/gpt4all/embedding-local.patch";
        sha256 = "sha256-cDJ1OR9WDvfoWNUsMfzGfcTH+dn+13GFEG+IDOxAOmw=";
      })
    ];
  });
}
