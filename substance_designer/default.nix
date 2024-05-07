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
   opencolorio,
   alembic,
   freeimage,
   ace,
   embree,
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
   readline,
   tcllib,
   tk,
   openssl_1_1,
   cudaPackages,
   libxcrypt-legacy
}:
let
  buildInputs = [ libsForQt5.qt5.qtwayland libsForQt5.qt3d libsForQt5.qt5.qtquickcontrols2 libsForQt5.full libxcrypt-legacy glibc gcc-unwrapped xorg.libXrandr xorg.libXrender xorg.libSM xorg.libICE xorg.libX11 xorg.libXext python311Packages.gssapi libz libGL opencolorio alembic freeimage ace embree rPackages.libbib python3 libGLU libstdcxx5 libxml2 libxcrypt harfbuzz ncurses5 gdbm readline cudaPackages.cudatoolkit tcllib tk openssl_1_1 tbb libsForQt5.qt5.qtbase ];
  nativeBuildInputs = [ autoPatchelfHook rpm cpio libsForQt5.wrapQtAppsHook ];
  
  src = 
  if stdenv.hostPlatform.system == "x86_64-linux" then
    fetchurl {
      url = "https://download.substance3d.com/adobe-substance-3d-designer/12.x/Adobe_Substance_3D_Designer-12.2.1-5947-linux-x64-standard.rpm";
      sha256 = "t8fmzDqNAVzafm015siyUyGdlEAYh8kpFoSEmg8EqsY=";
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
    mkdir -p $out/bin/
    mkdir -p $out/substance_designer/
    
    cp $src $out
    cd $out
    
    rpm2cpio *.rpm | cpio -idmv
    rm -rf *.rpm
    mv $out/opt/Adobe/Adobe_Substance_3D_Designer/* $out/substance_designer/
    rm -rf opt
    
    mv substance_designer/"Adobe Substance 3D Designer" substance_designer/sd3D
    ln -s substance_designer/sd3D bin/
  '';
}
