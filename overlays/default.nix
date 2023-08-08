final: prev:

{
  gpt-engineer = final.callPackage ./pkgs/gpt-engineer {
    buildPythonPackage = prev.python3Packages.buildPythonPackage;
    setuptools = prev.python3Packages.setuptools;
    openai = prev.python3Packages.openai;
  };
}
