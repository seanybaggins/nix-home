{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  makeWrapper,
  nodejs,
  git,
  openssh,
}:

buildNpmPackage rec {
  pname = "mintable";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "kevinschaich";
    repo = pname;
    rev = "${version}";
    hash = "sha256-/PIEuSDc4fgg2urGbbUWXkzgcTbEzkvaX11EB1j6h2Q=";
  };

  #dontNpmBuild = true;
  npmDepsHash = "sha256-HPC0TSmmxBHkysWyQgD/l9RVnG/AdQ3ykzEz9Z/pO+c=";

  prePatch = ''
    cp ${./package-lock.json} ./package-lock.json
    cp ${./package.json} ./package.json
  '';

  #preInstall = ''
  #  mkdir -p $out/share
  #  cp ${./release-it.json} $out/share/release-it.json
  #'';

  #postInstall = ''
  #  mv $out/bin/release-it $out/bin/release-it-raw

  #  # Use release-it's built-in binary, but wrap config
  #  makeWrapper $out/bin/release-it-raw $out/bin/release-it \
  #    --add-flags "--config $out/share/release-it.json" \
  #    --set PATH ${
  #      lib.makeBinPath [
  #        nodejs
  #        git
  #        openssh
  #      ]
  #    }
  #'';

  meta = {
    description = "Conventional changelog plugin for release-it";
    homepage = "https://github.com/release-it/conventional-changelog";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
