{
	lib,
	stdenv,
	fetchurl,
	rpm,
	libsForQt5,
	openssl_legacy,
	opencolorio,
	alembic,
	freeimage,
	ace,
	cpio,
	autoPatchelfHook,
	embree,
 	glibc,
	gcc-unwrapped,
	qt6,
	tbb,
	rPackages,
	patchelf,
	python3
}:
let
	buildInputs = [ rpm cpio embree freeimage ace  tbb python3 openssl_legacy opencolorio alembic  qt6.full libsForQt5.full rPackages.libbib glibc gcc-unwrapped ];

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

	inherit src buildInputs;

	nativeBuildInputs = [ autoPatchelfHook rpm ];

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
