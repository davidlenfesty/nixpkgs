{ lib
, buildPythonPackage
, cffi
, fetchPypi
, zope_interface
, sphinx
, manuel
, pythonOlder
}:

buildPythonPackage rec {
  pname = "persistent";
  version = "4.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nRd+rT+jwfXWKjbUUmdUs3bgUEx9S3XLmqUvt3HexrI=";
  };

  nativeBuildInputs = [
    sphinx
    manuel
  ];

  propagatedBuildInputs = [
    zope_interface
    cffi
  ];

  pythonImportsCheck = [
    "persistent"
  ];

  meta = with lib; {
    description = "Automatic persistence for Python objects";
    homepage = "https://github.com/zopefoundation/persistent/";
    license = licenses.zpl21;
    maintainers = with maintainers; [ ];
  };
}
