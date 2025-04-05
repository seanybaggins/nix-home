{ stdenv
, lib
, meson
, fetchgit
, gettext
, pkg-config
, cmake
, glib
, python3
, gtk4
, desktop-file-utils
, ninja
, librsvg
, python3Packages
}:

stdenv.mkDerivation rec {
  pname = "breezy-desktop";
  version = "2.1.1-beta";

  src = fetchgit {
    url = "https://github.com/wheaney/breezy-desktop.git";
    rev = "v2.1.1-beta";
    sha256 = "sha256-BF2NJbWDN4ujlC8WjOU+Gi6YLWPnzbdIrrG6ZmtgKl4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    meson
    gettext
    pkg-config
    cmake
    ninja
    librsvg
    python3Packages.wheel
    python3Packages.setuptools
  ];

  buildInputs = [
    python3
    glib
    gtk4
    desktop-file-utils
    python3Packages.pygobject3
  ];

  dependencies = [
    python3Packages.pygobject3
  ];

  configurePhase = ''
    cd ui
    meson setup build
  '';

  buildPhase = ''
    cd build
    meson compile

    # prepare extension
    cd ../..
    unlink gnome/src/schemas/com.xronlinux.BreezyDesktop.gschema.xml
    cp ui/data/com.xronlinux.BreezyDesktop.gschema.xml gnome/src/schemas/
    glib-compile-schemas --targetdir="gnome/src/schemas" "gnome/src/schemas"

    unlink gnome/src/textures/custom_banner.png
    cp vulkan/custom_banner.png gnome/src/textures/

    unlink gnome/src/textures/calibrating.png
    cp modules/sombrero/calibrating.png gnome/src/textures/

    unlink gnome/src/Sombrero.frag
    cp modules/sombrero/Sombrero.frag gnome/src/

    # create icon
    rsvg-convert ui/data/icons/hicolor/scalable/apps/com.xronlinux.BreezyDesktop.svg -w 64 -h 64 -o ui/data/icons/hicolor/com.xronlinux.BreezyDesktop_64.png
    rsvg-convert ui/data/icons/hicolor/scalable/apps/com.xronlinux.BreezyDesktop.svg -w 128 -h 128 -o ui/data/icons/hicolor/com.xronlinux.BreezyDesktop_128.png
    rsvg-convert ui/data/icons/hicolor/scalable/apps/com.xronlinux.BreezyDesktop.svg -w 256 -h 256 -o ui/data/icons/hicolor/com.xronlinux.BreezyDesktop_256.png
    rsvg-convert ui/data/icons/hicolor/scalable/apps/com.xronlinux.BreezyDesktop.svg -w 1024 -h 1024 -o ui/data/icons/hicolor/com.xronlinux.BreezyDesktop_1024.png

    ls
  '';

  installPhase = ''

    mkdir -p $out/share/glib-2.0/schemas
    cp -r ui/data/com.xronlinux.BreezyDesktop.gschema.xml $out/share/glib-2.0/schemas/com.xronlinux.BreezyDesktop.gschema.xml

    mkdir -p "$out/share/gnome-shell/extensions/${passthru.extensionUuid}"
    cp -r gnome/src/* $out/share/gnome-shell/extensions/${passthru.extensionUuid}

    mkdir -p $out/share/breezydesktop/breezydesktop
    cp -r ui/src/*.py $out/share/breezydesktop/breezydesktop

    mkdir -p $out/share/local
    cp -r ui/po/mo/* $out/share/local

    cp ui/modules/PyXRLinuxDriverIPC/xrdriveripc.py $out/share/breezydesktop/breezydesktop/xrdriveripc.py

    mkdir -p $out/bin
    cp ui/build/src/breezydesktop $out/bin
    cp ui/build/src/virtualdisplay $out/bin

    cp ui/build/src/breezydesktop.gresource $out/share/breezydesktop/breezydesktop

    mkdir -p $out/share/applications
    cp ui/build/data/com.xronlinux.BreezyDesktop.desktop $out/share/applications/com.xronlinux.BreezyDesktop.desktop

    #mkdir -p $out/share/icons
    #cp ui/data/icons/hicolor/com.xronlinux.BreezyDesktop* 

  '';

  passthru = {
    extensionUuid = "breezydesktop@xronlinux.com";
    extensionPortalSlug = "breezy-desktop";
  };

  meta = {
    description = "Breezy Desktop is a tool to allow both gaming and productivity in a virtual space using AR Glasses.";
    homepage = "https://github.com/wheaney/breezy-desktop";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };

}
