{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "<package-name>";
  version = "<version>";

  src = fetchurl {
    url = "https://example.com/${pname}-${version}.tar.gz";
    sha256 = "<hash>";
  };

  buildInputs = [ ];

  nativeBuildInputs = [ ];

  #unpackPhase = ''

  #'';

  #patchPhase = ''

  #'';

  #configurePhase = ''

  #'';

  #buildPhase = ''

  #'';

  #checkPhase = ''

  #'';

  #installPhase = ''

  #'';

  #fixupPhase = ''

  #'';

  # Meta information
  meta = with lib; {
    description = "Description of the package";
    homepage = "https://example.com/${pname}";
    license = licenses.<license-name>;
    maintainers = [ maintainers.<maintainer-name> ];
  };
}
