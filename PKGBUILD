# Maintainer: Justin Wong <jusw85 at hotmail dot com>
# Contributor: Benoit Favre <benoit.favre@gmail.com>
# Contributor: Alexander Rødseth <rodseth@gmail.com>
# Contributor: Kamil Biduś <kamil.bidus@gmail.com>

# Discussion: https://bbs.archlinux.org/viewtopic.php?pid=1853334#p1853334

pkgname=aseprite-git
_pkgname=aseprite
pkgver=1.2.13.r0.gaf4fd54c2
pkgrel=3
pkgdesc='Create animated sprites and pixel art'
arch=('x86_64' 'i686')
url='http://www.aseprite.org/'
license=('BSD' 'custom')
depends=('cmark' 'curl' 'libjpeg-turbo' 'giflib' 'tinyxml' 'pixman' 'libxcursor' 'fontconfig' 'nettle' 'shared-mime-info' 'desktop-file-utils' 'hicolor-icon-theme')
makedepends=('git' 'ninja' 'python2' 'clang')
conflicts=("${_pkgname}" "${_pkgname}-gpl")
source=(
        # "git+https://github.com/${_pkgname}/pixman.git"
        "git+https://github.com/${_pkgname}/simpleini.git"
        # "git+https://github.com/${_pkgname}/gtest.git"
        "git+https://github.com/${_pkgname}/libwebp.git"
        "git+https://github.com/${_pkgname}/flic.git"
        # "git+https://github.com/${_pkgname}/freetype2.git"
        # "git+https://github.com/${_pkgname}/zlib.git"
        # "git+https://github.com/${_pkgname}/libpng.git"
        "git+https://github.com/${_pkgname}/clip.git"
        "git+https://github.com/${_pkgname}/observable.git"
        "git+https://github.com/${_pkgname}/undo.git"
        "git+https://github.com/${_pkgname}/laf.git"
        # "git+https://github.com/${_pkgname}/cmark.git"
        # "git+https://github.com/${_pkgname}/harfbuzz.git"
        "git+https://github.com/${_pkgname}/libarchive.git"
        "git+https://github.com/${_pkgname}/json11.git"
        # "git+https://github.com/${_pkgname}/benchmark.git"
        # "git+https://github.com/${_pkgname}/giflib.git"
        "git+https://github.com/${_pkgname}/fmt.git"
        "git+https://github.com/${_pkgname}/tinyexpr.git"
        "git+https://github.com/${_pkgname}/lua"
        "git+https://github.com/${_pkgname}/stringencoders"
        # "git+https://github.com/${_pkgname}/googletest"
        "git+https://github.com/${_pkgname}/skia.git#branch=aseprite-m71"
        "git+https://github.com/${_pkgname}/${_pkgname}.git"
        'desktop.patch')
sha256sums=(
            # 'SKIP'
            # 'SKIP'
            # 'SKIP'
            # 'SKIP'
            # 'SKIP'
            # 'SKIP'
            # 'SKIP'
            # 'SKIP'
            # 'SKIP'
            # 'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'bcb6229e42cef16a8a0273c2fce67ce81d243a085c90bd52ac15183e757ff875')
_submodules=(
    # 'pixman'
    'simpleini'
    # 'gtest'
    'libwebp'
    'flic'
    # 'freetype2'
    # 'zlib'
    # 'libpng'
    'clip'
    'observable'
    'undo'
    'laf'
    # 'cmark'
    # 'harfbuzz'
    'libarchive'
    'json11'
    # 'benchmark'
    # 'giflib'
    'fmt'
    'tinyexpr'
    'lua')
_submodules_path=(
    # "third_party/pixman"
    "third_party/simpleini"
    # "third_party/gtest"
    "third_party/libwebp"
    "src/flic"
    # "third_party/freetype2"
    # "third_party/zlib"
    # "third_party/libpng"
    "src/clip"
    "src/observable"
    "src/undo"
    "laf"
    # "third_party/cmark"
    # "third_party/harfbuzz"
    "third_party/libarchive"
    "third_party/json11"
    # "third_party/benchmark"
    # "third_party/giflib"
    "third_party/fmt"
    "third_party/tinyexpr"
    "third_party/lua")

pkgver() {
    cd "${srcdir}/${_pkgname}"
    git describe --long --tags | sed 's/\([^-]*-g\)/r\1/;s/-/./g;s/^v//'
}

prepare() {
    cd "${srcdir}/${_pkgname}"
    git submodule init
    for (( i=0; i<${#_submodules[@]}; i++ )); do
        git config submodule.${_submodules_path[$i]}.url "${srcdir}/${_submodules[$i]}"
    done
    git submodule update

    cd laf
    git submodule init
    git config submodule.third_party/stringencoders.url "${srcdir}/stringencoders"
    # git config submodule.third_party/googletest.url "${srcdir}/googletest"
    git submodule update

    cd "${srcdir}/${_pkgname}"
    patch --strip=1 --input="${srcdir}/desktop.patch"
    mkdir -p build

    cd "${srcdir}/skia"
    python2 tools/git-sync-deps
}

build() {
    cd "${srcdir}/skia"
    bin/gn gen out/Clang --args='is_debug=false is_official_build=true cc="clang" cxx="clang++" skia_use_system_expat=false skia_use_system_icu=false skia_use_system_libjpeg_turbo=false skia_use_system_libpng=false skia_use_system_libwebp=false skia_use_system_zlib=false'
    ninja -C out/Clang skia

    cd "${srcdir}/${_pkgname}/build"
    cmake \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DLAF_OS_BACKEND=skia \
        -DSKIA_DIR="$srcdir/skia" \
        -DSKIA_OUT_DIR="$srcdir/skia/out/Clang" \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DUSE_SHARED_CMARK=ON \
        -DUSE_SHARED_CURL=ON \
        -DUSE_SHARED_JPEGLIB=ON \
        -DUSE_SHARED_GIFLIB=ON \
        -DUSE_SHARED_ZLIB=ON \
        -DUSE_SHARED_LIBPNG=ON \
        -DUSE_SHARED_TINYXML=ON \
        -DUSE_SHARED_PIXMAN=ON \
        -DUSE_SHARED_FREETYPE=ON \
        -DUSE_SHARED_HARFBUZZ=ON \
        -DWITH_WEBP_SUPPORT=ON \
        -DLAF_WITH_TESTS=OFF \
        -DENABLE_TESTS=OFF \
        -DENABLE_BENCHMARKS=OFF \
        -G Ninja \
        ..
    ninja ${_pkgname}
}

package() {
    cd "${srcdir}/${_pkgname}/build"
    DESTDIR="${pkgdir}" ninja install

    # Remove extraneous files
    # https://github.com/aseprite/aseprite/issues/1574
    # https://github.com/aseprite/aseprite/issues/1602
    rm -f "${pkgdir}"/usr/bin/bsd*
    rm -f "${pkgdir}"/usr/lib/pkgconfig/libarchive.pc
    rm -f "${pkgdir}"/usr/share/man/man1/bsd*

    rm -f "${pkgdir}"/usr/bin/img2webp
    rm -fr "${pkgdir}"/usr/include/webp/
    rm -f "${pkgdir}"/usr/lib/libwebp*
    rm -fr "${pkgdir}"/usr/share/WebP/
    rm -f "${pkgdir}"/usr/share/man/man1/img2webp.1

    rm -f "${pkgdir}"/usr/include/json11.hpp
    rm -f "${pkgdir}"/usr/lib/libjson11.a
    rm -f "${pkgdir}"/usr/lib/pkgconfig/json11.pc

    find "${pkgdir}" -type d -empty -delete

    cd "${srcdir}/${_pkgname}"

    install -Dm644 "src/desktop/linux/${_pkgname}.desktop" "${pkgdir}/usr/share/applications/${_pkgname}.desktop"
    install -Dm644 "src/desktop/linux/mime/${_pkgname}.xml" "${pkgdir}/usr/share/mime/packages/${_pkgname}.xml"
    for i in {16,32,48,64,128,256}; do
        install -Dm644 "data/icons/ase${i}.png" "${pkgdir}/usr/share/icons/hicolor/${i}x${i}/apps/${_pkgname}.png"
        install -Dm644 "data/icons/doc${i}.png" "${pkgdir}/usr/share/icons/hicolor/${i}x${i}/mimetypes/image-x-${_pkgname}.png"
    done
    install -Dm644 "EULA.txt" "${pkgdir}/usr/share/licenses/${pkgname}/EULA"
    install -Dm644 "${srcdir}/${_pkgname}/docs/LICENSES.md" "${pkgdir}/usr/share/licenses/${pkgname}/LICENSES"
}
