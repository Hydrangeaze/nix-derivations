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
   rPackages,
   libGLU,
   xorg,
   libstdcxx5,
   libxml2,
   libxcrypt,
   harfbuzz,
   ncurses5,
   python311Packages,
   gdbm,
   tbb_2021_11,
   tcllib,
   tk-8_5,
   openssl_1_1,
   cudaPackages,
   linuxKernel,
   python39Full,
   libxcrypt-legacy,
   wlroots,
   lib
}:
let
  buildInputs = [ libsForQt5.qt5.qtwayland libsForQt5.qt3d libsForQt5.qt5.qtquickcontrols2 libsForQt5.full libxcrypt-legacy glibc gcc-unwrapped xorg.libXrandr xorg.libXrender xorg.libSM xorg.libICE xorg.libX11 xorg.libXext python311Packages.gssapi libz libGL opencolorio alembic freeimage ace embree rPackages.libbib libGLU libstdcxx5 libxml2 libxcrypt harfbuzz ncurses5 gdbm cudaPackages.cudatoolkit tcllib  openssl_1_1 libsForQt5.qt5.qtbase tk-8_5 libsForQt5.qtquick3d libsForQt5.qtpurchasing libsForQt5.qtscxml libsForQt5.qtremoteobjects tbb_2021_11 linuxKernel.packages.linux_zen.nvidia_x11_legacy470 wlroots python39Full  ]; # there no gdbm, readline lib
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
  
  preInstallPhase = ''
    mkdir -p $out/bin/
    mkdir -p $out/substance_designer/
    
    cp $src $out/sd.rpm
    cd $out
    
    rpm2cpio sd.rpm | cpio -idmv
    rm -rf sd.rpm
    mv $out/opt/Adobe/Adobe_Substance_3D_Designer/* $out/substance_designer/
    rm -rf opt

    ln -s substance_designer/"Adobe Substance 3D Designer" bin/"Adobe Substance 3D Designer"
  '';
}
