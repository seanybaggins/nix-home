{
  cmake,
  openssl,
  libevdev,
  libusb1,
  json_c,
  curl,
  hidapi,
  stdenv,
  pkg-config,
  fetchgit,
  python3,
  wayland,
  python3Packages,
  gcc,
}:

stdenv.mkDerivation {
  name = "xr-linux-driver";

  src = fetchgit {
    url = "https://github.com/wheaney/XRLinuxDriver.git";
    rev = "v2.0.4";
    sha256 = "sha256-/2NZoCClv+yeK+4cOM0v2n7qEq9tURExHuk2Lpq95P0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    python3Packages.pyaml
  ];

  BREEZY_DESKTOP = 1;

  cmakeFlags = [
    "-DSYSTEM_INSTALL=1"
  ];

  buildInputs = [
    openssl
    libevdev
    libusb1
    json_c
    curl
    hidapi
    wayland
    gcc
  ];

  NIX_LDFLAGS = [
    "-lstdc++"
    "-latomic"
  ];

  postInstall = ''
    # Install the main driver binary
    install -Dm755 xrDriver $out/bin/xrDriver

    # Modify the systemd user service
    cd ..
    substituteInPlace systemd/xr-driver.service \
      --replace 'ExecStart=/usr/bin/xrDriver' 'ExecStart=xrDriver' \
      --replace 'WantedBy=graphical.target' 'WantedBy=default.target'
    sed -i '/Environment/d' systemd/xr-driver.service

    # Install the modified systemd user service
    install -Dm644 systemd/xr-driver.service $out/lib/systemd/user/xr-driver.service

    # Install the CLI binary
    install -Dm755 bin/xr_driver_cli $out/bin/xr_driver_cli

    # Install shared and static libraries explicitly
    install -Dm755 lib/x86_64/libGlassSDK.so           $out/lib/libGlassSDK.so
    install -Dm755 lib/x86_64/libRayNeoXRMiniSDK.so    $out/lib/libRayNeoXRMiniSDK.so
    install -Dm644 lib/x86_64/libviture_one_sdk.a      $out/lib/libviture_one_sdk.a
    install -Dm644 lib/aarch64/libviture_one_sdk.a     $out/lib/libviture_one_sdk_aarch64.a

    # Install udev rules
    install -Dm644 udev/70-viture-xr.rules   -t $out/lib/udev/rules.d/
    install -Dm644 udev/70-xreal-xr.rules    -t $out/lib/udev/rules.d/
    install -Dm644 udev/70-rayneo-xr.rules   -t $out/lib/udev/rules.d/
    install -Dm644 udev/70-rokid-xr.rules    -t $out/lib/udev/rules.d/
    install -Dm644 udev/70-uinput-xr.rules   -t $out/lib/udev/rules.d/

    # Ensure the uinput module is loaded
    mkdir -p $out/lib/modules-load.d
    echo uinput > $out/lib/modules-load.d/xr-linux-driver.conf

    ldd $out/bin/xrDriver
  '';

  preFixup = ''
    echo "Patching binaries to fix /build references"

    patchelf --replace-needed libGlassSDK.so $out/lib/libGlassSDK.so $out/bin/xrDriver
    patchelf --replace-needed libRayNeoXRMiniSDK.so $out/lib/libRayNeoXRMiniSDK.so $out/bin/xrDriver
    patchelf --replace-needed libhidapi-hidraw.so.0 $out/lib/libhidapi-hidraw.so.0 $out/bin/xrDriver
  '';

}
