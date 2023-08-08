{ buildPythonPackage
, fetchPypi
, lib
, setuptools
, openai
}:

buildPythonPackage rec {
  pname = "gpt-engineer";
  version = "0.0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BQe/pGS9nCBuj7IlAE0DuwPJXfuhQNMc3kK2TnXeXnY=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    openai
  ];

  format = "pyproject";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/AntonOsika/gpt-engineer";
    description = ''
      Specify what you want it to build, the AI asks for clarification, and then builds it.

      GPT Engineer is made to be easy to adapt, extend, and make your agent learn how you want your code to look. It generates an entire codebase based on a prompt.
    '';
    license = licenses.mit;
    #maintainers = with maintainers; [ ];
  };
}
