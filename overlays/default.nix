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
}
