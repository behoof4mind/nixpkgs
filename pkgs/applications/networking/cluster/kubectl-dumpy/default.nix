{
  stdenv,
  fetchurl,
  lib,
}:

let
  version = "0.2.0";
  baseUrl = "https://github.com/larryTheSlap/dumpy/releases/download/v${version}";
  arch =
    if stdenv.isAarch64 then
      "arm64"
    else if stdenv.isx86_64 then
      "x86_64"
    else if stdenv.isi686 then
      "i386"
    else
      throw "Unsupported architecture";
  os =
    if stdenv.isDarwin then
      "Darwin"
    else if stdenv.isLinux then
      "Linux"
    else
      throw "Unsupported OS";
  url = "${baseUrl}/dumpy_${os}_${arch}.tar.gz";
in
stdenv.mkDerivation {
  pname = "dumpy";
  inherit version;

  src = fetchurl {
    url = url;
    sha256 = "sha256-C3KSxnqmIUTNjbZm8zeDMOEmssFU/TMVz0Ihj/N4r38=";
  };

  phases = [
    "unpackPhase"
    "installPhase"
  ];

  unpackPhase = ''
    tar -xzf $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp kubectl-dumpy $out/bin/
  '';

  meta = with lib; {
    description = "Kubernetes CLI plugin for live capture of network traffic from various resources";
    homepage = "https://github.com/larryTheSlap/dumpy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ behoof4mind ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
