{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "simple-sddm-2";
  version = "1.0";

  src = pkgs.fetchFromGitHub {
    owner = "JaKooLit";
    repo = "simple-sddm-2";
    rev = "master";
    sha256 = "1cv17y57mcjp7rb79iski4jji33jpxdy45r264xl9ky6zial9dfn";
  };

  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -r . $out/share/sddm/themes/simple-sddm-2
  '';
}
