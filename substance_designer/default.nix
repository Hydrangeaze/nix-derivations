{
   stdenv,
   rpm,
   cpio,
   fetchurl,
   glibc,
   gcc-unwrapped,
   autoPatchelfHook,
   libz,
   libGL,
   libsForQt5,
#   openssl_legacy,
   opencolorio,
   alembic,
   freeimage,
   ace,
   embree,
#   qt6,
   tbb,
   rPackages,
   python3,
   libGLU,
   xorg,
   libstdcxx5,
   libxml2,
   libxcrypt,
   harfbuzz,
   ncurses5,
   python311Packages,
   gdbm,
   ncurses,
   readline,
   tcllib,
   tk,
   openssl_1_1,
   cudaPackages,
   libxcrypt-legacy,
   qtbase,
   wrapQtAppsHook
}:
let
	buildInputs = [ libsForQt5.qt5.qtwayland libxcrypt-legacy libsForQt5.full libsForQt5.qt3d glibc gcc-unwrapped xorg.libXrandr xorg.libXrender xorg.libSM xorg.libICE xorg.libX11 xorg.libXext python311Packages.gssapi libz libGL opencolorio alembic freeimage ace embree rPackages.libbib python3 libGLU libstdcxx5 libxml2 libxcrypt harfbuzz ncurses5 gdbm ncurses readline cudaPackages.cudatoolkit tcllib tk openssl_1_1 tbb qtbase ];
	nativeBuildInputs = [ autoPatchelfHook rpm cpio wrapQtAppsHook ];

	src = 
	if stdenv.hostPlatform.system == "x86_64-linux" then
		fetchurl {
			url = "https://download.substance3d.com/adobe-substance-3d-designer/11.x/Adobe_Substance_3D_Designer-11.3.1-5355-linux-x64-standard.rpm";
			sha256 = "3P5PwPdKXngWibKjhIZZqi3Lu7l6OmBJ5i0ldKzmaM8=";
		}
	else
		throw "Substance Designern not supported on ${stdenv.hostPlatform.system}";
in
stdenv.mkDerivation {
	name = "substance_designer";

	system = "x86_64-linux";

	inherit src buildInputs nativeBuildInputs;

	unpackPhase = "true";
	
	installPhase = ''
		mkdir -p $out
		cp $src $out
		cd $out
		
		rpm2cpio *.rpm | cpio -idmv
		rm -rf *.rpm

		mv $out/opt/Adobe/Adobe_Substance_3D_Designer/* $out
		rm -rf opt
	'';

}
