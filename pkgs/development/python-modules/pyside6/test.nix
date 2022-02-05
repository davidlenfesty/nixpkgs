# FIXME "pip install" cannot find PySide6
# it works when i remove install_requires

{ lib
, python3
, qt6
, fetchFromGitHub
}:

{
  python-pyside6-hello = python3.pkgs.buildPythonApplication rec {
    pname = "qt6-pyside-test";
    version = "0.0.1";

    src = fetchFromGitHub {
      owner = "GRomR1";
      repo = "python-pyside6-hello";
      rev = "1531b409168ff530300a7fed0c33387c635ff235";
      sha256 = "Y12z8ex/WU/Bc55RidvylPh8wytL8mXMjSMHd433Yos=";
    };

    postUnpack = ''
      (
      cd $sourceRoot

      # add shebang line
      (
        echo '#! /usr/bin/env python3'
        cat main.py
      ) >${pname}
      rm main.py

      # add setup.py
      cat >setup.py <<'EOF'
      from setuptools import setup
      setup(
        name='${pname}',
        version='${version}',
        scripts=['${pname}'],

        # FIXME
        #install_requires=['PySide6'],
        # ERROR: Could not find a version that satisfies the requirement PySide6

      )
      EOF
      )
    '';

    # debug pipInstallPhase
    # pkgs/development/interpreters/python/hooks/pip-install-hook.sh
    preInstall = "set -x";
    postInstall = "set +x";
    pipInstallFlags = [ "--verbose" ];
    /*
      /nix/store/i6vabb4div9iy6lsl642d86k1q8riasn-python3-3.9.9/bin/python3.9
      -m pip install
      ./qt6_pyside_hello-0.0.1-py3-none-any.whl
      --no-index
      --no-warn-script-location
      --prefix=/nix/store/1vd6d5iq9i2ha0fj8dm8p9s24lakq7cp-qt6-pyside-hello-0.0.1
      --no-cache

      Processing ./qt6_pyside_hello-0.0.1-py3-none-any.whl
      ERROR: Could not find a version that satisfies the requirement PySide6 (from qt6-pyside-hello) (from versions: none)
      ERROR: No matching distribution found for PySide6
    */

    propagatedBuildInputs = with python3.pkgs; [
      pyside6
    ];

    doCheck = false;

    nativeBuildInputs = [ qt6.wrapQtAppsHook ];

    postFixup = ''
      wrapQtApp $out/bin/${pname}
    '';

    meta = with lib; {
      description = "PySide6 Hello World app";
      homepage = "https://github.com/GRomR1/python-pyside6-hello";
      license = licenses.mit;
      maintainers = with maintainers; [ milahu ];
    };
  };
}
