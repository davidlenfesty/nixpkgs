{ buildPythonPackage
, python
, fetchurl
, lib
, pyside6
, cmake
, qt6
, llvmPackages_13
}:

# sphinx-build - not found! doc target disabled

let
  llvmPackages = llvmPackages_13;
  stdenv = llvmPackages.stdenv;
in

stdenv.mkDerivation rec {
  pname = "shiboken6";

  inherit (pyside6) version src;

  patches = [
    ./nix_compile_cflags.patch
  ];

  postPatch = ''
    cd sources/${pname}
  '';

  CLANG_INSTALL_DIR = llvmPackages.libclang.lib;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    llvmPackages.libclang
    llvmPackages.libllvm
    python
    qt6.qtbase
  ];

  cmakeFlags = [
    "-DBUILD_TESTS=OFF"
  ];

  #QT_LOGGING_RULES = "*.debug=true"; # debug

  dontWrapQtApps = true;

  postInstall = ''
    rm $out/bin/shiboken_tool.py
  '';

  meta = with lib; {
    description = "Generator for the pyside6 Qt bindings";
    license = with licenses; [ gpl2 lgpl21 ];
    homepage = "https://wiki.qt.io/Qt_for_Python";
    maintainers = with maintainers; [ gebner ];
    broken = stdenv.isDarwin;
  };
}
