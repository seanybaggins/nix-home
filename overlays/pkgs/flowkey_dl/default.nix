{ buildPythonPackage
, fetchPypi
, py
, setuptools
, wheel
, lib
, requests
, imageio
, importlib-metadata
, matplotlib
}:

buildPythonPackage rec {
  pname = "flowkey_dl";
  version = "0.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-owH+EkXQfX5vWtt9H6b6b+fcD9eXTPE4vyFZpGzRvQ4=";
  };

  pyproject = true;

  nativeBuildInputs = [
    setuptools
    py
    wheel
    requests
    imageio
    importlib-metadata
    matplotlib
  ];

  #propagatedBuildInputs = [
  #];

  #format = "pyproject";

  #doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/MatthiasLienhard/flowkey_dl";
    description = ''
      A python app to download sheet music from flowkey and save it as pdf.
    '';
    license = licenses.mit;
    #maintainers = with maintainers; [ ];
  };
}
